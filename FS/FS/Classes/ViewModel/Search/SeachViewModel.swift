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

    let cellViewModels: Observable<[VenueCellViewModel]>
    private let subject = PublishSubject<[VenueCellViewModel]>()
    let bag = DisposeBag()

    init(searchControl: ControlProperty<String?>) {
        cellViewModels = subject
        searchControl.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .filter { (str) -> Bool in
                return str.count >= 3
            }
            .flatMapLatest { (keyword) in
                return API.search(with: keyword)
            }
            .map({ (venues) -> [VenueCellViewModel] in
                return venues.map({ (venue) -> VenueCellViewModel in
                    return VenueCellViewModel(venue: venue)
                })
            })
            .subscribe(onNext: { (viewModels) in
                self.subject.onNext(viewModels)
            })
            .disposed(by: bag)

        searchControl.orEmpty
            .filter { (str) -> Bool in
                return str.count < 3
            }
            .subscribe(onNext: { _ in
                self.subject.onNext([])
            })
            .addDisposableTo(bag)
    }
}
