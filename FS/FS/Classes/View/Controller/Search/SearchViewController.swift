//
//  SearchViewController.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUtils

class SearchViewController: ViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    let searchViewHeight: CGFloat = 92.5

    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupObservables()
    }

    private func setupUI() {
        title = "Search"
        setupTableView()
        setupSearchBar()
    }

    private func setupTableView() {
        tableView.registerNib(VenueCell.self)
        tableView.rowHeight = 143.0
        tableView.tableFooterView = UIView()
    }

    private func setupSearchBar() {
        let textField = searchBar.value(forKey: "_searchField") as? UITextField
        textField?.clearButtonMode = .never
    }

    private func setupViewModel() {
        viewModel = SearchViewModel(searchControl: searchBar.rx.text)
    }

    private func setupObservables() {
        tableView.rx
            .itemSelected
            .map { indexPath in
                return self.viewModel.viewModelForItem(at: indexPath)
            }
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (viewModel) in
                let controller = VenueDetailViewController()
                controller.viewModel = viewModel
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.variable
            .asObservable()
            .do(onNext: { (_) in
                self.indicator.stopAnimating()
            }, onError: { (_) in
                self.indicator.stopAnimating()
            }, onCompleted: {
                self.indicator.stopAnimating()
            })
            .bind(to: tableView.rx.items(cellIdentifier: "VenueCell", cellType: VenueCell.self)) { (index, cellViewModel, cell) in
                cell.viewModel = cellViewModel
            }.disposed(by: disposeBag)

        searchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { (str) -> Bool in
                return str.count >= 3
            }
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
