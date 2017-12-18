//
//  CarController.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import MVVM
import RxSwift

class CarController: BaseViewController, MVVM.View {
    @IBOutlet private weak var tableView: UITableView!

    var viewModel = CarListViewModel() {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        updateView()
    }

    func updateView() {
        setupObservable()
    }

    private func setupObservable() {
        viewModel.dataObservable
            .bind(to: tableView.rx.items(cellIdentifier: "CarCell", cellType: CarTableViewCell.self)) { [weak self] (row, _, cell) in
                guard let this = self else { return }
                cell.viewModel = this.viewModel.viewModelForItem(at: IndexPath(row: row, section: 0))
            }
            .addDisposableTo(disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let this = self else { return }
                this.showAlert(message: "select row \(indexPath.row)")
            })
            .addDisposableTo(disposeBag)
    }
}
