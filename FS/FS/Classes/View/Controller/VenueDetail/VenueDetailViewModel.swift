//
//  VenueDetailViewModel.swift
//  FS
//
//  Created by at-thinhuv on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift

class VenueDetailViewModel {
    var venue: Observable<Venue>?
    init(venueId: String) {
        getDetail()
    }

    private func getDetail() {

    }

}
