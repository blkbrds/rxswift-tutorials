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

class HomeViewController: ViewController {
    private var tableView = UITableView()
    private var refreshControl = UIRefreshControl()
    var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        configureTableView()
        setup()
    }

    private func setup() {
        viewModel.venues.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: VenueCell.identifier, cellType: VenueCell.self)) { (index, venue, cell) in
                let indexPath = IndexPath(row: index, section: 0)
                cell.viewModel = self.viewModel.viewModelForItem(at: indexPath)
            }.disposed(by: disposeBag)

        viewModel.isRefreshing.asDriver().drive(refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { (_) in
                self.viewModel.refresh()
            })
            .disposed(by: disposeBag)
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        let nib = UINib(nibName: VenueCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: VenueCell.identifier)
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
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VenueCell.height
    }
}

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
