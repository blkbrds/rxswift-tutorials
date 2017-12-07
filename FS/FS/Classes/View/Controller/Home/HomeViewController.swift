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
        configTableView()
        setup()
    }

    // MARK: - Private funtions
    private func configTableView() {
        let nib = UINib(nibName: "VenueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VenueCell")
        tableView.rowHeight = 143.0
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControl)

        tableView.rx.itemSelected
            .map { indexPath in
                self.viewModel.venues.value[indexPath.row]
            }
            .subscribeOn(MainScheduler.instance)
            .subscribe { (event) in
                switch event {
                case .next(let venue):
                    let viewModel = VenueDetailViewModel(venueId: venue.id)
                    let detailController = VenueDetailViewController()
                    detailController.viewModel = viewModel
                    self.navigationController?.pushViewController(detailController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    private func setup() {
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
    }
}

// MAKR: - SVProgressHUD
extension SVProgressHUD {
    static var animating: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            if let element = event.element {
                if element {
                    self.show()
                } else {
                    self.dismiss()
                }
            } else {
                self.dismiss()
            }
        }
    }
}
