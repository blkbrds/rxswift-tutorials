//
//  SearchController.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift

final class SearchController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var data: [String] = []
    var dataSearch: [String] = []
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        configRx()
    }

    private func setupData() {
        data.removeAll()
        dataSearch.removeAll()
        for i in 0 ... 30 {
            let item = "Number is \(i)"
            data.append(item)
        }
        dataSearch = data
    }

    // MARK: - Rx
    private func configRx() {
        searchBar.rx.text.orEmpty // Observable property
        .distinctUntilChanged() // If didn't occur, check if the new value is the same as old.
        .subscribe(onNext: { [weak self] (text) in // Here subscribe to every new value
            guard let this = self else { return }
            this.dataSearch = this.data.filter({ (str) -> Bool in
                str.lowercased().contains(text.lowercased())
            })
            if this.dataSearch.isEmpty && text.isEmpty {
                this.dataSearch = this.data
            }
            this.tableView.reloadData()
        })
        .disposed(by: disposeBag) // dispose it on deinit.
    }
}

 extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSearch.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = dataSearch[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
 }
