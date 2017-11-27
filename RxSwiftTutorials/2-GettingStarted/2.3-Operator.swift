//
//  2.3-Operator.swift
//  RxSwiftTutorials
//
//  Created by Quang Phu C. M. on 11/22/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class Car: Equatable {
    var trademark: String
    var color: UIColor

    init(trademark: String, color: UIColor) {
        self.trademark = trademark
        self.color = color
    }

    public static func ==(lhs: Car, rhs: Car) -> Bool {
        return lhs.trademark == rhs.trademark && lhs.color == rhs.color
    }
}

final class Operator {
    var cars: [Car] = {
        return [Car(trademark: "Audi", color: .red),
                Car(trademark: "Honda", color: .green),
                Car(trademark: "BWM", color: .yellow),
                Car(trademark: "Audi", color: .black),
                Car(trademark: "Toyota", color: .white)]
    }()

    func filter() {
        let car = Car(trademark: "Toyota", color: .white)
        let observable = Observable.from(cars)
        let filterObservable = observable.filter { $0 == car }

        _ = filterObservable.subscribe(onNext: { (car) in
            // Do something
            print(car.trademark)
        })
    }
}
