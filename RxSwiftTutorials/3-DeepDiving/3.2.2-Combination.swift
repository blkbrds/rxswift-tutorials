//
//  3.2.2.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/13/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class Combination {

    init() {
        execute()
    }

    func execute() {
        // change the function that you want to run.
        zip()
    }

    private func merge() {
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

    private func conbineLatest() {
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

    private func trigger() {
        // 1
        let button = PublishSubject<Any>()
        let textField = PublishSubject<String>()

        // 2
        let observable = button.withLatestFrom(textField)
        let disposable = observable.subscribe(onNext: { (value) in
            print(value)
        })

        // 3
        textField.onNext("Rx")
        textField.onNext("RxSw")
        button.onNext("tap")
        textField.onNext("RxSwift")
        button.onNext("tap")
        button.onNext("tap")

        disposable.dispose()
    }

    private func amb() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        // 1

        let observable = left.amb(right)
        let disposable = observable.subscribe(onNext: { value in
            print(value)
        })

        // 2
        left.onNext("London")
        right.onNext("Copenhagen")
        left.onNext("Lisbon")
        left.onNext("Madrid")
        right.onNext("Vienna")
        right.onNext("Ha Noi")
        right.onNext("HCM")
        disposable.dispose()
    }

    private func switchLatest() {
        // 1
        let one = PublishSubject<String>()
        let two = PublishSubject<String>()
        let three = PublishSubject<String>()
        let source = PublishSubject<Observable<String>>()

        // 2
        let observable = source.switchLatest()
        let disposable = observable.subscribe(onNext: { value in
            print(value)
        })

        // 3
        source.onNext(one)
        one.onNext("Some text from sequence one")
        two.onNext("Some text from sequence two")
        source.onNext(two)
        two.onNext("More text from sequence two")
        one.onNext("and also from sequence one")
        source.onNext(three)
        two.onNext("Why don't you see me?")
        one.onNext("I'm alone, help me")
        three.onNext("Hey it's three. I win.")
        source.onNext(one)
        one.onNext("Nope. It's me, one!")

        disposable.dispose()
    }

    private func zip() {
        // 1
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()

        // 2
        let observable = Observable.zip(first, second, resultSelector: { (lastFirst, lastSecond) in
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
}
