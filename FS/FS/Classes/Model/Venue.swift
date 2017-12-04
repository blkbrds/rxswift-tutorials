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
    required init?(map: Map) {

    }

    var id = ""
    var name = ""

    func mapping(map: Map) {
        name <- map["name"]
    }
}
