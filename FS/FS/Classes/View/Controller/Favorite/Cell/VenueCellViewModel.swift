//
//  VenueCellViewModel.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/4/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift

final class VenueCellViewModel {
    private var venue: Venue

    var name: String {
        return venue.name
    }

    var address: String {
        return venue.fullAddress
    }

    var rating: String {
        return String(format: "%f", venue.rating)
    }

    var photoURL: URL? {
        return URL(string: venue.thumbnail?.path() ?? "")
    }

    init(venue: Venue = Venue()) {
        self.venue = venue
    }
}
