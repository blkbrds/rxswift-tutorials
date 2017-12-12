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

    func toggleFavorite() {
        DatabaseManager.shared.write().subscribe({ (event) in
            switch event {
            case .completed:
                guard let venue = self.venue else { return }
                venue.isFavorite = !venue.isFavorite
            default: break
            }
        }).dispose()
    }
}
