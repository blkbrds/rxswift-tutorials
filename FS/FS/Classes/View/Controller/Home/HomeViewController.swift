//
//  HomeViewController.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class HomeViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    private var refreshControl = UIRefreshControl()
    var viewModel = HomeViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        setupUI()
        setupData()
    }

    // MARK: - Private
    private func setupUI() {
        let nib = UINib(nibName: "VenueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VenueCell")
        tableView.rowHeight = 143.0
        tableView.addSubview(refreshControl)

        tableView.rx.itemSelected
            .map { indexPath in
                self.viewModel.venues.value[indexPath.row]
            }
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] (event) in
                guard let this = self else { return }
                switch event {
                case .next(let venue):
                    if let selectRowIndexPath = this.tableView.indexPathForSelectedRow {
                        this.tableView.deselectRow(at: selectRowIndexPath, animated: true)
                    }
                    let viewModel = VenueDetailViewModel(venueId: venue.id)
                    let detailController = VenueDetailViewController()
                    detailController.viewModel = viewModel
                    this.navigationController?.pushViewController(detailController, animated: true)
                case .error(let error):
                    print("dkm", error.localizedDescription)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    private func setupData() {
        viewModel.venues.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "VenueCell", cellType: VenueCell.self)) { (index, venue, cell) in
                cell.viewModel = VenueCellViewModel(venue: venue)
            }
            .disposed(by: disposeBag)

        viewModel.isRefreshing.asDriver().drive(refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { (_) in
                self.viewModel.refresh()
            })
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
            .subscribeOn(MainScheduler.instance)
            .subscribe { (event) in
                let maximumOffset = self.tableView.contentSize.height - self.tableView.frame.size.height
                if !self.viewModel.isLoadmore.value, let currentOffset = event.element?.y, maximumOffset == currentOffset {
                    self.viewModel.isLoadmore.value = true
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    @IBAction func segmentedTouchUpInside(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel.section.value = .coffee
        } else {
            viewModel.section.value = .food
        }
    }
}
