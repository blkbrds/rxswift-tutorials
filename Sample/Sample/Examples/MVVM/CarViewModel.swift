//
//  CarViewModel.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import MVVM
import RxSwift
import RxCocoa
class CarViewModel: ViewModel {
    static let horsepowerPerKilowatt = 1.341

    private var car: Car

    // properties of the CarViewModel will be able to observe and react to changes.
    var modelText: BehaviorSubject<String>
    var makeText: BehaviorSubject<String>
    var horsepowerText: BehaviorSubject<String>
    var titleText: BehaviorSubject<String>
    var photoURL: URL? {
        return URL(string: car.photoURL)
    }

    let disposeBag = DisposeBag()

    init(car: Car) {
        self.car = car
        /* --- when init with none RxSwift ---
         modelText = car.model
         makeText = car.make
         titleText = "\(car.make) \(car.model)"
         photoURL = URL(string: car.photoURL)
         let horsepower = Int(round(Double(car.kilowatts) * CarViewModel.horsepowerPerKilowatt))
         horsepowerText = "\(horsepower) HP"
        */

        // being initialized with the current value and registering for changes so the car variable updates respectively.
        modelText = BehaviorSubject<String>(value: car.model)
        makeText = BehaviorSubject<String>(value: car.make)

        modelText
            .subscribe(onNext: { (model) in car.model = model })
            .addDisposableTo(disposeBag)

        makeText
            .subscribe(onNext: { (make) in car.make = make })
            .addDisposableTo(disposeBag)

        // combine whatever changes the makeText and titleText receive, combine them into one string and assign them to titleText
        titleText = BehaviorSubject<String>(value: "\(car.make) \(car.model)")
        Observable.combineLatest(modelText, makeText) { (model, make) -> String in
            return "\(make) \(model)"
        }.bind(to: titleText).addDisposableTo(disposeBag)

        // uses a feature called map() to calculate horsepower from kilowatts. It tries to parse a number
        // from whatever string the kilowattText subject holds and binds the calculated and decorated horsepower string to horsepowerText
        horsepowerText = BehaviorSubject(value: "0")
        let kilowattText = BehaviorSubject(value: car.kilowatts)
        kilowattText
            .map { (kilowatts) -> String in
                let horsepower = Int(round(Double(car.kilowatts) * CarViewModel.horsepowerPerKilowatt))
                return "\(horsepower) HP"
            }
            .bind(to: horsepowerText).addDisposableTo(disposeBag)
    }
}
