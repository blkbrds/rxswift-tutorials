//
//  DeepDiveViewController.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/22/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class DeepDiveViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    enum CellType: Int {
        case conditional
        case combination
        case filtering
        case mathematical
        case transformation
        case timeBase

        static let count: Int = {
            var max = 0
            while let _ = CellType(rawValue: max) { max += 1 }
            return max
        }()

        var title: String {
            var text = "3.2.\(rawValue + 1). "
            switch self {
            case .conditional: text += "Conditional"
            case .combination: text += "Combination"
            case .filtering: text += "Filtering"
            case .mathematical: text += "Mathematical"
            case .transformation: text += "Transformation"
            case .timeBase: text += "TimeBase"
            }
            return text
        }
    }

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupData()
    }

    private func setupData() {
        let observable: Variable<[String]> = Variable([])
        let dataSource = observable.asObservable()
        dataSource.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (_, title, cell) in
            cell.textLabel?.text = "\(title)"
        }.disposed(by: disposeBag)
        for i in 0..<CellType.count {
            guard let cellType = CellType(rawValue: i) else { return }
            observable.value.append(cellType.title)
        }
        let indexPath = tableView.rx.itemSelected
        indexPath.subscribe(onNext: { [weak self] value in
            guard let this = self,
                let cellType = CellType(rawValue: value.row) else { return }
            this.tableView.deselectRow(at: value, animated: true)
            switch cellType {
            case .combination:
                let controller = CombinationCocoa()
                this.navigationController?.pushViewController(controller, animated: true)
            case .transformation:
                Transformation()
            default: break
                // TODO: implement then
            }
        }).disposed(by: disposeBag)
    }
}
