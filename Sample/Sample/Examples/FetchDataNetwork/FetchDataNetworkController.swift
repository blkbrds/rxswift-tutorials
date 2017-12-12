//
//  FetchDataNetworkController.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/13/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

// https://www.raywenderlich.com/158364/rxswift-transforming-operators-practice

class FetchDataNetworkController: UITableViewController {

    fileprivate let disposeBag = DisposeBag()
    let eventService = EventService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // reload tableView when list events ([Event]) changes
        eventService.events.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                guard let this = self else { return }
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            })
            .addDisposableTo(disposeBag)

        // get Events from web
        eventService.getEvents()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventService.events.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = eventService.events.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath)
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.repo + ", " + event.action.replacingOccurrences(of: "Event", with: "").lowercased()
        cell.imageView?.kf.setImage(with: event.imageUrl, placeholder: Image(named: "blank-avatar"))
        return cell
    }
}
