//
//  FavoriteViewModel.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import MVVM
import RealmSwift

final class FavoriteViewModel: ViewModel {
    var venues: Variable<[Venue]> = Variable([])
    let bag = DisposeBag()
    var results: Results<Venue>!

    init() {
        fetchFavoriteVenues()
    }

    func fetchFavoriteVenues() {
        let pre = NSPredicate(format: "isFavorite = true")
        results = DatabaseManager.shared.objects(Venue.self, filter: pre)

        RealmObservable
            .changeset(from: results)
            .subscribe { (event) in
                switch event {
                case .next(let element):
                    print("Delete")
                    self.venues.value = element.0
                default: break
                }
            }.disposed(by: bag)
    }

    func venue(at indexPath: IndexPath) -> Venue {
        guard indexPath.row < venues.value.count else { return Venue() }
        return venues.value[indexPath.row]
    }

    func viewModelForItem(at indexPath: IndexPath) -> VenueCellViewModel {
        guard indexPath.row >= 0 && indexPath.row < venues.value.count else { return VenueCellViewModel() }
        return VenueCellViewModel(venue: venues.value[indexPath.row])
    }

    func removeFavorite(at indexPath: IndexPath) {
        guard indexPath.row < results.count else { return }
        let venue = venues.value[indexPath.row]
        DatabaseManager.shared.write().subscribe { (event) in
            switch event {
            case .completed:
                venue.isFavorite = false
            default: break
            }
        }.dispose()
    }
}
