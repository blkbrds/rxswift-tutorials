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

final class FavoriteViewModel: ViewModel {
    private let venues: Variable<[Venue]> = {
        FavoriteViewModel.dunmmyData()
        let predicate = NSPredicate(format: "isFavorite = true")
        let data = DatabaseManager.shared.objects(Venue.self, filter: predicate)
        var result: [Venue] = []
        for item in data {
            result.append(item)
        }
        return Variable(result)
    }()

    var dataObservable: Observable<[Venue]> {
        return venues.asObservable()
    }

    func viewModelForItem(at indexPath: IndexPath) -> VenueCellViewModel {
        guard indexPath.row >= 0 && indexPath.row < venues.value.count else { return VenueCellViewModel() }
        return VenueCellViewModel(venue: venues.value[indexPath.row])
    }
}

// MARK: - Dummy data
extension FavoriteViewModel {
    static func dunmmyData() {
        let venue1 = Venue()
        venue1.id = "1"
        venue1.name = "Bún"
        venue1.category = "Ẩm thực"
        venue1.rating = 6.8
        venue1.isFavorite = false

        let venue2 = Venue()
        venue2.id = "2"
        venue2.name = "Trà Sữa"
        venue1.category = "Đồ uống"
        venue2.rating = 7.5
        venue2.isFavorite = true

        let venue3 = Venue()
        venue3.id = "3"
        venue3.name = "Bia tô lão đại"
        venue3.category = "Quán Nhậu"
        venue3.rating = 9.8
        venue3.isFavorite = true

//        DatabaseManager.shared.addObject(venue1)
//        DatabaseManager.shared.addObject(venue2)
//        DatabaseManager.shared.addObject(venue3)
    }
}
