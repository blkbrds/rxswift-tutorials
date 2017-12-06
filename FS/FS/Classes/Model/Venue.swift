//
//  Venue.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import ObjectMapper
import RealmSwift
import Realm

final class Venue: Object, Mappable {
    dynamic var id: String!
    dynamic var name: String = ""
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var isFavorite = false
    dynamic var rating: Double = 0.0
    dynamic var ratingColor: String = ""
    dynamic var category: String = ""
    dynamic var likes: String = ""
    dynamic var phone: String = ""
    private dynamic var address: String = ""
    private dynamic var city: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }

    var fullAddress: String {
        if city.isEmpty {
            return address
        }
        return address + ", " + city
    }

    var thumbnail: Photo?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["venue.id"]
        name <- map["venue.name"]
        latitude <- map["venue.location.lat"]
        longitude <- map["venue.location.lng"]
        city <- map["venue.location.city"]
        address <- map["venue.location.address"]
        rating <- map["venue.rating"]
        ratingColor <- map["venue.ratingColor"]
        category <- map["venue.categories.0.name"]
        likes <- map["venue.likes.summary"]
        phone <- map["venue.contact.phone"]
        thumbnail <- map["venue.photos.groups.0.items.0"]
    }
}
