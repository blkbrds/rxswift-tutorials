//
//  OperatorObjectMapper.swift
//  FS
//
//  Created by Hoa Nguyen on 12/18/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

infix operator <-

func <- <T: Mappable>(left: List<T>, right: Map) {
    var temp: [T]?
    if right.mappingType == .toJSON {
        temp = Array(left)
    }
    temp <- right
    if let objects = temp, right.mappingType == .fromJSON {
        left.append(objectsIn: objects)
    }
}
