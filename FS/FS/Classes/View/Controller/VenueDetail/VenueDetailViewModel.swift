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
        venue = getVenue(by: venueId)
    }

    private func getVenue(by id: String) -> Venue? {
        let pre = NSPredicate(format: "id = %@", id)
        return DatabaseManager.shared.object(Venue.self, filter: pre)
    }

    func toggleFavorite() {
        DatabaseManager.shared.updateObject {
            guard let venue = venue else { return }
            venue.isFavorite = !venue.isFavorite
        }
    }
}
