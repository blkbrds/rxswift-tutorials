//
//  HomeViewModel.swift
//  FS
//
//  Created by at-thinhuv on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MVVM

struct HomeViewModel {

    // MARK: - Properties
    var venues: Variable<[Venue]> = Variable([])
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var isRefreshing: Variable<Bool> = Variable(false)
    var type: String = ""

    private var bag = DisposeBag()

    init() {
        getVenues()
    }

    private func getVenues() {
        API.getVenues(params: [:])
            .subscribe { (event) in
                if let venues = event.element {
                    self.venues.value.append(contentsOf: venues)
                    self.isLoading.onCompleted()
                } else {
                    if let error = event.error {
                        self.isLoading.onError(error)
                    }
                }
                self.isRefreshing.value = false
            }
            .disposed(by: bag)
    }

    // MARK: Public functions
    func refresh() {
        if isRefreshing.value  {
            return
        }
        isRefreshing.value = true
        venues.value.removeAll()
        getVenues()
    }
}
