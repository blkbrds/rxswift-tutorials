//
//  2.4-Subjects.swift
//  RxSwiftTutorials
//
//  Created by Linh Vo D. on 11/29/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift
import UIKit

final class Subjects {

    init() {
    }

    // ---PublishSubject---
    func publishSubject() {
        let subject = PublishSubject<String>()
        subject.onNext("Is anyone listening?")

        let subscriptionOne = subject
            .subscribe(onNext: { string in
                print("1)", string)
            })
        subject.on(.next("1"))
        subject.onNext("2")

        let subscriptionTwo = subject
            .subscribe { event in
                print("2)", event.element ?? event)
        }

        subject.onNext("3")
        subscriptionOne.dispose()
        subject.onNext("4")
        subscriptionTwo.dispose()
    }

    // ---BehaviorSubject---
    func behaviorSubject() {
        let disposeBag = DisposeBag()
        let subject = BehaviorSubject(value: "Initial value")

        subject.onNext("1")
        subject.subscribe {
                print("1)", $0)
            }
            .disposed(by: disposeBag)

        subject.onNext("2")
        subject.subscribe {
                print("2)", $0)
            }
            .disposed(by: disposeBag)
        subject.onNext("3")
    }

    // ---ReplaySubject---
    func replaySubject() {
        let disposeBag = DisposeBag()
        let subject = ReplaySubject<String>.create(bufferSize: 2)

        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")

        subject
            .subscribe {
                print("1)", $0)
            }
            .disposed(by: disposeBag)

        subject
            .subscribe {
                print("2)", $0)
            }
            .disposed(by: disposeBag)

        subject.onNext("4")
        subject.dispose()
    }

    // ---Variables---
    func variables() {
        let disposeBag = DisposeBag()
        let variable = Variable("Initial value")

        variable.value = "New initial value"
        variable.asObservable()
            .subscribe {
                print("1)", $0)
            }
            .disposed(by: disposeBag)

        variable.value = "1"
        variable.asObservable()
            .subscribe {
                print("2)", $0)
            }
            .disposed(by: disposeBag)

        variable.value = "2"
    }
}
