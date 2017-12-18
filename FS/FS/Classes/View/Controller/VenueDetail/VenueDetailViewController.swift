//
//  VenueDetailViewController.swift
//  FS
//
//  Created by at-thinhuv on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SVProgressHUD
import RxDataSources

enum VenueSection: Int {
    case information
    case tips

    var count: Int { return VenueSection.tips.rawValue + 1 }
}

enum InformationItem: String {
    case name
    case address
    case categories
    case rating

    var count: Int { return 4 }
}

final class VenueDetailViewController: ViewController {
    private weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var bag = DisposeBag()
    var viewModel: VenueDetailViewModel?
    private var shareButtonItem: UIBarButtonItem!
    private var favoriteButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        configRightBarButtonItems()
        configTableView()
        configPageView()
    }

    private func configTableView() {
        var nib = UINib(nibName: "InformationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "InformationCell")
        nib = UINib(nibName: "TipCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TipCell")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        // Data source

        let dataSource = RxTableViewSectionedReloadDataSource<DetailVenueSection>()
        dataSource.configureCell = { (dataSource, tableView, indexPath, item) in
            switch dataSource[indexPath] {
            case .information(let viewModel):
                guard let cell = tableView.dequeue(InformationCell.self) else { fatalError("Can not deque InformationCell")}
                cell.viewModel = viewModel
                return cell
            case .tips(let viewModel):
                guard let  cell = tableView.dequeue(TipCell.self) else { fatalError("Can not deque TipCell")}
                cell.viewModel = viewModel
                return cell
            }
        }
        dataSource.titleForHeaderInSection = { dataSource, index in
            if index == 0 {
                return "Information"
            }
            return "Tips"
        }
        
        viewModel?.dataSource.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }


    private func configRightBarButtonItems() {
        favoriteButtonItem = UIBarButtonItem()
        favoriteButtonItem?.rx.tap
            .subscribe { event in
                self.viewModel?.toggleFavorite()
                .subscribe()
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)

        self.viewModel?.toggleFavorite()
            .map({ (value) -> String in
                return value ? "Favorite" : "Unfavorite"
            })
            .asObservable()
            .bind(to: favoriteButtonItem.rx.title)
        .disposed(by: disposeBag)

        shareButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: nil,
            action: nil
        )
        shareButtonItem?.rx.tap
            .subscribe { event in
                self.viewModel?.toggleFavorite()
                .subscribe()
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        viewModel?.isFavorite.asObservable()
            .bind(onNext: {
                self.favoriteButtonItem.tintColor = $0 ? .red : self.shareButtonItem.tintColor
            })
            .disposed(by: disposeBag)

        navigationItem.setRightBarButtonItems(
            [favoriteButtonItem, shareButtonItem],
            animated: true
        )
    }

    private func configPageView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = headerTableView.bounds.size
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .leastNormalMagnitude
        layout.minimumLineSpacing = .leastNormalMagnitude
        let collectionView = UICollectionView(frame: headerTableView.bounds, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.registerClass(UICollectionViewCell.self)
        collectionView.backgroundColor = .white
        viewModel?.urlStrings.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "UICollectionViewCell", cellType: UICollectionViewCell.self)) { (row, url, cell) in
                let imageView = UIImageView(frame: cell.bounds)
                cell.addSubview(imageView)
                imageView.setImage(path: url).subscribe().disposed(by: self.bag)
            }
            .disposed(by: bag)
        headerTableView.addSubview(collectionView)
        self.collectionView = collectionView
    }
}

