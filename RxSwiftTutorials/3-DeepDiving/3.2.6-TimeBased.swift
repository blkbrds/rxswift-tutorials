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

    // ---Timeout Operator---
    func timeout() {
        let dueTime: RxTimeInterval = 3
        // Khởi tạo 1 PublicSubject
        let publishSubject = PublishSubject<Int>()

        // Áp dụng Timeout vào publicSubject với dueTime = 3. Nghĩa là Sau khi subscribe, trong vòng 3s mà không có event nào phát đi kể từ lần cuối phát  event hay subscribe thì sẽ trả về timeout error và ngắt observable.
        _ = publishSubject.timeout(dueTime, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("Element: ", $0)
            }, onError: {
                print("Timout error")
                print($0)
            })

        // Khởi tạo 1 observable timer interval, timer này có nhiệm vụ cứ mỗi giây phát ra 1 event.
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            // Nếu event nhận được từ timer có element <= 5 thì publishSubject sẽ phát đi event.
            if let e = $0.element, e <= 5 {
                publishSubject.onNext(e)
            }
        })
    }

    // ---Delay Operator---
    func delay() {
        let dueTime: RxTimeInterval = 3
        // Khởi tạo 1 PublicSubject
        let publicSubject = PublishSubject<String>()

        // Áp dụng delay vào publishSubject với dueTime = 3. Nghĩa là sau khi subscribe, nếu publishSubject phát ra event thì sau 3s subsribe mới nhận được event.
        _ = publicSubject.delay(dueTime, scheduler: MainScheduler.instance).subscribe({
            print($0)
        })

        publicSubject.onNext("Sau 3s mới nhận được nhé!")
    }

    // ---Window Operator---
    func window() {
        let bufferTimeSpan: RxTimeInterval = 3
        let bufferMaxCount = 2
        // Khởi tạo 1 PublicSubject
        let publicSubject = PublishSubject<Int>()

        // Áp dụng window vào publishSubject với bufferTimeSpan = 3 và bufferMaxCount = 2. Nghĩa là sau mỗi 3s sẽ tách ra 1 observable con chứa những event được phát ra trong khoảng 3s đó từ observable mẹ (Tối đa là 2 event).
        _ = publicSubject.window(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
            if let element = $0.element {
                print("New Observable")
                _ = element.subscribe({
                    print($0)
                })
            }
        })

        // Khởi tạo 1 observable timer interval, timer này có nhiệm vụ cứ mỗi giây phát ra 1 event.
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            // Nếu event nhận được từ timer có element < 6 thì publishSubject sẽ phát đi event.
            if let e = $0.element, e < 6 {
                publicSubject.onNext(e)
            }
        })
    }

    // ---Replay Operator---
    func replay() {
        let replayedElements = 3
        // Khởi tạo 1 PublicSubject
        let publicSubject = PublishSubject<Int>()

        // Áp dụng replay vào publishSubject với replayedElements = 3. Nghĩa là sau khi subscribe sẽ nhận lại được tối đa 3 event trước đó nếu có.
        let replayObservable = publicSubject.replay(replayedElements)
        _ = replayObservable.connect()

        // publicSubject phát đi 5 events.
        for i in 0...4 {
            publicSubject.onNext(i)
        }

        _ = replayObservable.subscribe({
            print("replay: ", $0)
        })
    }

    // ---Buffer Operator---
    func buffer() {
        let bufferTimeSpan: RxTimeInterval = 3
        let bufferMaxCount = 3
        // Khởi tạo 1 PublicSubject
        let publicSubject = PublishSubject<Int>()

        // Áp dụng buffer vào publishSubject với timeSpan = 3 và count = 3. Nghĩa là sau khi subscribe sẽ nhận được tập hợp những event được phát đi trong khoảng 3 giây và tối đa là 3 event.
        _ = publicSubject.buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({ (event) in
            print("Event nhận được sau khi buffer: ", event)
        })

        // Khởi tạo 1 observable timer interval, timer này có nhiệm vụ cứ mỗi giây phát ra 1 event.
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        _ = timer.subscribe({
            // Nếu event nhận được từ timer có element < 6 thì publishSubject sẽ phát đi event.
            if let e = $0.element, e < 6 {
                publicSubject.onNext(e)
            }
        })
    }
}
