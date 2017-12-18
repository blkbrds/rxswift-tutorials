//
//  Car.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation

class Car {
    var model: String
    var make: String
    var kilowatts: Int
    var photoURL: String

    init(model: String, make: String, kilowatts: Int, photoURL: String) {
        self.model = model
        self.make = make
        self.kilowatts = kilowatts
        self.photoURL = photoURL
    }
}
