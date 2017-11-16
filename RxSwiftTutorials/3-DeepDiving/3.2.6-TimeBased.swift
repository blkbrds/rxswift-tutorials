//
//  3.2.6-TimeBased.swift
//  RxSwiftTutorials
//
//  Created by Linh Vo D. on 11/16/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class TimeBased {

    init() {
    }

    func replay() {
        let replayedElements = 3
        let replaySubject = ReplaySubject<Int>.create(bufferSize: replayedElements)

        _ = replaySubject.subscribe({
            print($0)
        })

        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            if let e = $0.element {
                replaySubject.onNext(e)
            }
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            replaySubject.subscribe({
                print("replay:", $0)
            }).dispose()
        }
    }

    func buffer() {
        let bufferTimeSpan: RxTimeInterval = 3
        let bufferMaxCount = 5
        let publicSubject = PublishSubject<Int>()

        _ = publicSubject.buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
            print($0)
        })

        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            if let e = $0.element {
                publicSubject.onNext(e)
            }
        })
    }

    func window() {
        let bufferTimeSpan: RxTimeInterval = 3
        let bufferMaxCount = 5
        let publicSubject = PublishSubject<Int>()

        _ = publicSubject.window(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
            print($0)
        })

        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            if let e = $0.element {
                publicSubject.onNext(e)
            }
        })
    }

    func delay() {
        let delayInSeconds: RxTimeInterval = 3
        let publicSubject = PublishSubject<Int>()

        _ = publicSubject.delay(delayInSeconds, scheduler: MainScheduler.instance).subscribe({
            print($0)
        })

        _ = publicSubject.subscribe({
            print($0)
        })

        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            if let e = $0.element {
                publicSubject.onNext(e)
            }
        })
    }

    func timeout() {
        let dueTime: RxTimeInterval = 3
        let publicSubject = PublishSubject<Int>()

        _ = publicSubject.timeout(dueTime, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            }, onError: {
                print("error")
                print($0)
            })

        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            if let e = $0.element, e <= 10 {
                publicSubject.onNext(e)
            }
        })
    }
}
