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

class HomeViewModel {

    enum Section: Int {
        case coffee = 0
        case food

        var name: String {
            switch self {
            case .coffee:
                return "coffee"
            case .food:
                return "food"
            }
        }
    }

    // MARK: - Properties
    var venues: Variable<[Venue]> = Variable([])
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var isRefreshing: Variable<Bool> = Variable(false)
    var isLoadmore: Variable<Bool> = Variable(false)
    var section: Variable<Section> = Variable(Section.coffee)

    private var bag = DisposeBag()

    init() {
        setup()
    }

    // MARK: - Private
    private func setup() {
        isLoadmore.asObservable()
            .filter { $0 == true }
            .subscribe(onNext: { (_) in
                self.getVenues()
            })
            .disposed(by: bag)

        section.asObservable()
            .subscribe(onNext: { section in
                self.venues.value.removeAll()
                self.getVenues()
            })
            .disposed(by: bag)
    }

    private func getVenues() {
        var params: JSObject = [:]
        params["section"] = section.value.name
        params["offset"] = venues.value.count
        API.getVenues(params: params).withHUD()
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
                self.isLoadmore.value = false
            }
            .disposed(by: bag)
    }

    // MARK: Public
    func refresh() {
        if isRefreshing.value  {
            return
        }
        isRefreshing.value = true
        venues.value.removeAll()
        getVenues()
    }
}
