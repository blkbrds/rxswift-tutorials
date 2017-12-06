//
//  Venue.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import ObjectMapper

class Venue: Mappable {

    var id = ""
    var name = ""
    var favorite: Bool = false
    
    required init?(map: Map) {
        guard let id: String = map["id"].value() else { return nil }
        self.id = id
    }

    func mapping(map: Map) {
        name <- map["name"]
    }
}
