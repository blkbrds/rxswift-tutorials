//
//  HomeViewController.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SVProgressHUD

final class HomeViewController: ViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    // MARK: - Properties
    private var refreshControl = UIRefreshControl()
    var viewModel = HomeViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        configuration()
    }

    // MARK: - Private
    private func configuration() {
        let nib = UINib(nibName: "VenueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VenueCell")
        tableView.rowHeight = 143.0
        tableView.addSubview(refreshControl)


        // Bind tableview
        viewModel.venues.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "VenueCell", cellType: VenueCell.self)) { (index, venue, cell) in
                cell.viewModel = VenueCellViewModel(venue: venue)
            }
            .disposed(by: disposeBag)

        // TableView itemSelected
        tableView.rx.itemSelected
            .map { indexPath in
                self.viewModel.venueItem(at: indexPath)
            }
            .subscribe { [weak self] (event) in
                guard let this = self else { return }
                switch event {
                case .next(let venue):
                    if let selectRowIndexPath = this.tableView.indexPathForSelectedRow {
                        this.tableView.deselectRow(at: selectRowIndexPath, animated: true)
                    }
                    guard let venue = venue else { return }
                    let viewModel = VenueDetailViewModel(venueId: venue.id)
                    let detailController = VenueDetailViewController()
                    detailController.viewModel = viewModel
                    this.navigationController?.pushViewController(detailController, animated: true)
                case .error(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
                    let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                    alert.addAction(closeAction)
                    this.present(alert, animated: true, completion: nil)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        // selectedSegmentIndex
        segmentedControl.rx.selectedSegmentIndex
            .asObservable()
            .map { rawValue -> HomeViewModel.Section? in
                return HomeViewModel.Section(rawValue: rawValue)
            }
            .unwrap()
            .bind(to: viewModel.section)
            .disposed(by: disposeBag)

        // Refresh
        viewModel.isRefreshing.asDriver()
            .drive(refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] (_) in
                guard let this = self else { return }
                this.viewModel.refresh()
            })
            .disposed(by: disposeBag)

        // ContentOffset
        tableView.rx.contentOffset
            .map { $0.y }
            .subscribe { (event) in
                if let y = event.element {
                    let maximumOffset = self.tableView.contentSize.height - self.tableView.frame.size.height
                    if !self.viewModel.isLoadmore.value && y == maximumOffset {
                        self.viewModel.isLoadmore.value = true
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
