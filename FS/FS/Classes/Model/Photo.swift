//
//  Photo.swift
//  FS
//
//  Created by Linh Vo D. on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Photo: Object, Mappable {
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

    func path(ratioWith: Int = 2, ratioHeight: Int = 2) -> String {
        let path = prefix + "\(width / ratioWith)" + "x" + "\(height / ratioHeight)" + suffix
        return path
    }
}
