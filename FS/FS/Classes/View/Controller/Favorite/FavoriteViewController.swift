//
//  FavoriteViewController.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import SwiftUtils

final class FavoriteViewController: ViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = FavoriteViewModel() {
        didSet {
            updateView()
        }
    }

    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        configTableView()
        updateView()
    }

    // MARK: - Private method
    private func configTableView() {
        tableView.register(UINib(nibName: VenueCell.identifier, bundle: nil),
                           forCellReuseIdentifier: VenueCell.identifier)
        tableView.rowHeight = 186
    }

    private func setupTableViewBinding() {
        viewModel.venues
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: VenueCell.identifier)) { (row, _, cell) in
                guard let cell = cell as? VenueCell else { return }
                cell.viewModel = self.viewModel.viewModelForItem(at: IndexPath(row: row, section: 0))
            }
            .disposed(by: disposeBag)

        // Handle item deleted
        tableView.rx.itemDeleted.subscribe { (event) in
            switch event {
            case .next(let element):
                self.viewModel.removeFavorite(at: element)
            default:
                break
            }
        }.disposed(by: disposeBag)

        // Handle when did select cell
        tableView.rx.itemSelected
            .map { indexPath in
                self.viewModel.venue(at: indexPath)
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
                    print(error.localizedDescription)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        // Set delegate
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    // MARK: - Public methods
    func updateView() {
        setupTableViewBinding()
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDelegate {
    @nonobjc func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
