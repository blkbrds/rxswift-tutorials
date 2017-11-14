//
//  3.2.2.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/13/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class Combination {
    func merge() {
        // 1
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()

        // 2
        let source = Observable.of(left, right)
        let observable = source.merge()
        let disposable = observable.subscribe(onNext: { (value) in
            print(value)
        })

        // 3
        print("> Sending a value to Left")
        left.onNext("1")
        print("> Sending a value to Right")
        right.onNext("4")
        print("> Sending another value to Right")
        right.onNext("5")
        print("> Sending another value to Left")
        left.onNext("2")
        print("> Sending another value to Right")
        right.onNext("6")
        print("> Sending another value to Left")
        left.onNext("3")

        disposable.dispose()
    }

    func conbineLatest() {
        // 1
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()

        // 2
        let observable = Observable.combineLatest(first, second, resultSelector: { (lastFirst, lastSecond) in
            print(lastFirst + " - " + lastSecond)
        })
        let disposable = observable.subscribe()

        // 3
        print("> Sending a value to First")
        first.onNext("Hello,")
        print("> Sending a value to Second")
        second.onNext("world")
        print("> Sending another value to Second")
        second.onNext("RxSwift")
        print("> Sending another value to First")
        first.onNext("Have a good day,")

        disposable.dispose()
    }

    func trigger() {

    }
}
