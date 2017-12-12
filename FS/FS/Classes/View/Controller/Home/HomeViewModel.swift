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
            .subscribe(onNext: { [weak self] (_) in
                guard let this = self else { return }
                if this.venues.value.count % 10 == 0 {
                    this.getVenues()
                }
            })
            .disposed(by: bag)

        section.asObservable()
            .subscribe(onNext: { [weak self] (section) in
                guard let this = self else { return }
                this.venues.value.removeAll()
                this.getVenues()
            })
            .disposed(by: bag)
    }

    private func getVenues() {
        var params: JSObject = [:]
        params["section"] = section.value.name
        params["offset"] = venues.value.count
        API.getVenues(params: params).withHUD()
            .subscribe { [weak self] (event) in
                guard let this = self else { return }
                if let venues = event.element {
                    this.venues.value.append(contentsOf: venues)
                    this.isLoading.onCompleted()
                } else {
                    if let error = event.error {
                        this.isLoading.onError(error)
                    }
                }
                this.isRefreshing.value = false
                this.isLoadmore.value = false
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

    func venueItem(at indexPath: IndexPath) -> Venue?  {
        if indexPath.row < venues.value.count {
            return venues.value[indexPath.row]
        } else {
            return nil
        }
    }
}

extension HomeViewModel {
    func venue(at indexPath: IndexPath) -> Venue {
        guard indexPath.row < venues.value.count else { return Venue() }
        return venues.value[indexPath.row]
    }

    func viewModelForItem(at indexPath: IndexPath) -> VenueCellViewModel {
        guard indexPath.count < venues.value.count else { return VenueCellViewModel() }
        let venue = venues.value[indexPath.row]
        return VenueCellViewModel(venue: venue)
    }
}
