//
//  Venue.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import ObjectMapper
import RealmSwift

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
    dynamic var thumbnail: Photo?
    private dynamic var address: String = ""
    private dynamic var city: String = ""

    var fullAddress: String {
        if city.isEmpty {
            return address
        }
        return address + ", " + city
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
        guard let _ = map.JSON["id"] as? String else { return nil }
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        latitude <- map["location.lat"]
        longitude <- map["location.lng"]
        city <- map["location.city"]
        address <- map["location.address"]
        rating <- map["rating"]
        ratingColor <- map["ratingColor"]
        category <- map["categories.0.name"]
        likes <- map["likes.summary"]
        phone <- map["contact.phone"]
        thumbnail <- map["photos.groups.0.items.0"]
        if let venue = Venue.fetch(by: self.id) {
            self.isFavorite = venue.isFavorite
        }
    }
}

extension Venue {
    static func fetch(by id: String) -> Venue? {
        let pre = NSPredicate(format: "id = %@", id)
        return DatabaseManager.shared.object(Venue.self, filter: pre)
    }
}
