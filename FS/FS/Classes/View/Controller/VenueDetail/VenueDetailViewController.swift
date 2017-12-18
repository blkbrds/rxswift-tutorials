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
import RxDataSources

final class VenueDetailViewController: ViewController {
    private weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var bag = DisposeBag()
    var viewModel: VenueDetailViewModel?

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
        let shareBarButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: nil,
            action: nil
        )
        shareBarButton.rx.tap
            .subscribe { event in
                
            }
            .disposed(by: disposeBag)

        let favoriteBarButton: UIBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_favorite"),
            style: .plain,
            target: nil,
            action: nil
        )
        favoriteBarButton.rx.tap
            .subscribe { event in
                self.viewModel?.toggleFavorite()
            }
            .disposed(by: disposeBag)
        viewModel?.isFavorite.asObservable()
            .bind(onNext: {
                favoriteBarButton.tintColor = $0 ? .red : shareBarButton.tintColor
            })
            .disposed(by: disposeBag)

        navigationItem.setRightBarButtonItems(
            [favoriteBarButton, shareBarButton],
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

