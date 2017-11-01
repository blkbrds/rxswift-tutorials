//
//  Functional.swift
//  RxSwiftTutorials
//
//  Created by Dao Nguyen V. on 9/25/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

//------------------------------------------------------------
//    Riding game scheduler
//------------------------------------------------------------

import UIKit

extension Array where Element == Ride {
    // imperative programming with insertion sort
    func _sortedNames() -> [String] {
        var names = [String]()
        for ride in self {
            names.append(ride.name)
        }
        for (i, name) in names.enumerated() {
            for j in stride(from: i, to: -1, by: -1) {
                if name.localizedCompare(names[j]) == .orderedAscending {
                    names.remove(at: i)
                    names.insert(name, at: j)
                }
            }
        }
        return names
    }

    // functional programming - what's order rule? that's all
    func sortedNames() -> [String] {
        return map { ride in ride.name }
            .sorted { s1, s2 in s1.localizedCompare(s2) == .orderedAscending }
    }
}

enum RideCategory: String {
    case family
    case kids
    case thrill
    case scary
    case relaxing
    case water
}

typealias Minutes = Double
struct Ride {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes
}

let parkRides: [Ride] = [
    Ride(name: "Raging Rapids", categories: [.family, .thrill, .water], waitTime: 45.0),
    Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
    Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
    Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
    Ride(name: "Thunder Coaster", categories: [.family, .thrill], waitTime: 60.0),
    Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
    Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
    Ride(name: "Mountain Railroad", categories: [.family, .relaxing], waitTime: 0.0)
]
