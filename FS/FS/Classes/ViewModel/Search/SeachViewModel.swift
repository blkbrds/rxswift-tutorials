//
//  SeachViewModel.swift
//  FS
//
//  Created by Mylo Ho on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {

    let cellViewModels: Driver<[CellViewModel]>

    init(searchControl: ControlProperty<String?>) {
        cellViewModels = searchControl.orEmpty
            .filter { (str) -> Bool in
                return str.count >= 3
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (keyword) in
                return API.search(with: keyword)
            }
            .map({ (venues) -> [CellViewModel] in
                return venues.map({ (venue) -> CellViewModel in
                    return CellViewModel(venue: venue)
                })
            }).asDriver(onErrorJustReturn: [])
    }
}

class CellViewModel {
    let venue: Venue

    init(venue: Venue) {
        self.venue = venue
    }
}
