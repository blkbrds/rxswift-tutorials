//
//  MenuViewController.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/22/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    enum SectionType: Int {
        case gettingStarted
        case deepDive

        static let count: Int = {
            var max = 0
            while let _ = SectionType(rawValue: max) { max += 1 }
            return max
        }()

        var title: String {
            switch self {
            case .gettingStarted: return "Getting Started"
            case .deepDive: return "Deep Dive"
            }
        }

        var numberOfRows: Int {
            switch self {
            case .gettingStarted: return GettingStarted.count
            case .deepDive: return DeepDive.count
            }
        }

        func titleForRow(at row: Int) -> String {
            switch self {
            case .gettingStarted:
                guard let gettingStarted = GettingStarted(rawValue: row) else { return "" }
                return gettingStarted.title
            case .deepDive:
                guard let gettingStarted = DeepDive(rawValue: row) else { return "" }
                return gettingStarted.title
            }
        }
    }

    enum GettingStarted: Int {
        case observable
        case observer
        case `operator`

        static let count: Int = {
            var max = 0
            while let _ = GettingStarted(rawValue: max) { max += 1 }
            return max
        }()

        var title: String {
            var text = "\(rawValue + 1). "
            switch self {
            case .observable: text += "Observable"
            case .observer: text += "Observer"
            case .`operator`: text += "Operator"
            }
            return text
        }
    }

    enum DeepDive: Int {
        case creation
        case operators

        static let count: Int = {
            var max = 0
            while let _ = DeepDive(rawValue: max) { max += 1 }
            return max
        }()

        var title: String {
            var text = "\(rawValue + 1). "
            switch self {
            case .creation: text += "Creation"
            case .operators: text += "Operators"
            }
            return text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        guard let sectionType = SectionType(rawValue: section) else { return header }
        header?.textLabel?.text = sectionType.title
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .deepDive:
            guard let cellType = DeepDive(rawValue: indexPath.section) else { return }
            switch cellType {
            case .operators:
                let controller = DeepDiveViewController()
                navigationController?.pushViewController(controller, animated: true)
            default: break
            }
        default: break
            // TODO: implement then
        }
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        return sectionType.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return cell }
        cell.textLabel?.text = sectionType.titleForRow(at: indexPath.row)
        return cell
    }
}
