//
//  Tip.swift
//  FS
//
//  Created by Hoa Nguyen on 12/14/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import ObjectMapper
import RealmSwift

let dateTimeFormatter = { () -> DateFormatter in
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
    return formatter
}()

final class Tip: Mappable {
	var id = ""
    var createdAt = Date()
    var text = ""
    var photoPrefix = ""
    var photoSuffix = ""
    var user: User?
    var createAtString: String {
        return dateTimeFormatter.string(from: createdAt)
    }

    required convenience init?(map: Map) {
        self.init()
        guard let _ = map.JSON["id"] as? String else { return nil }
    }

    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- (map["createdAt"], DateTransform())
        text <- map["text"]
        photoPrefix <- map["photo.photo.prefix"]
        photoSuffix <- map["user.photo.suffix"]
        user <- map["user"]
    }
}
