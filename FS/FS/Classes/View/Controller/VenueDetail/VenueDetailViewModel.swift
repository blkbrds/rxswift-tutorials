//
//  VenueDetailViewModel.swift
//  FS
//
//  Created by at-thinhuv on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift

final class VenueDetailViewModel {
    var venue: Venue?

    init(venueId: String) {
        venue = Venue.fetch(by: venueId)
    }

    init(venue: Venue) {
        if let _venue = Venue.fetch(by: venue.id) {
            self.venue = _venue
        } else {
            self.venue = venue
        }
    }

    func toggleFavorite() {
        guard let venue = self.venue else { return }
        guard Venue.fetch(by: venue.id) != nil else {
            venue.isFavorite = !venue.isFavorite
            DataProvider.shared.add(venue)
            return
        }
        DataProvider.shared.write().subscribe({ (event) in
            switch event {
            case .completed:
                venue.isFavorite = !venue.isFavorite
            default: break
            }
        }).dispose()
    }
}
