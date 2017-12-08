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

    let searchViewHeight: CGFloat = 92.5

    var viewModel: SearchViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupObservables()
    }

    private func setupUI() {
        title = "Search"
        setupTableView()
    }

    private func setupTableView() {
        tableView.registerClass(SearchCell.self)
    }

    private func setupViewModel() {
        viewModel = SearchViewModel(searchControl: searchBar.rx.text)
    }

    private func setupObservables() {
        viewModel.cellViewModels
            .drive(tableView.rx.items) { (tableView, index, cellViewModel) -> UITableViewCell in
                let cell: SearchCell = tableView.dequeue(SearchCell.self)
                cell.textLabel?.text = cellViewModel.venue.id
                return cell
            }.disposed(by: bag)

        tableView.rx.contentOffset
            .subscribe { (_) in
                if self.searchBar.isFirstResponder {
                    _ = self.searchBar.resignFirstResponder()
                }
            }.disposed(by: bag)
    }
}
