//
//  3.2.5-Transformation.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/27/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class Transformation {

    init() {
        abc()
    }

    func abc() {
        let observable = Observable.of(1,2,3)
        let ob1 = observable.scan(1) { (a, value) -> Int in
            return a + value
        }
        ob1.subscribe(onNext: { value in
            print(value)
        }).dispose()
    }
}
