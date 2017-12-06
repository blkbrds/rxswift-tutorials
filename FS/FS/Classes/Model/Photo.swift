//
//  Photo.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/4/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Photo: Object, StaticMappable {
    dynamic var id: String!
    dynamic var prefix: String = ""
    dynamic var suffix: String = ""
    dynamic var width: Int = 0
    dynamic var height: Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
        if map.JSON["id"] == nil {
            return nil
        }
    }

    func mapping(map: Map) {
        id <- map["id"]
        prefix <- map["prefix"]
        suffix <- map["suffix"]
        width <- map["width"]
        height <- map["height"]
    }

    static func objectForMapping(map: Map) -> BaseMappable? {
        return DatabaseManager.shared.realm.object(ofType: self, forPrimaryKey: map)
    }

    func path(width: Int = 100, height: Int = 100) -> String {
        let path = prefix + "\(width)" + "x" + "\(height)" + suffix
        return path
    }
}
