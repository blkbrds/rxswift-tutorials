//
//  RxSwiftTutorialsTests.swift
//  RxSwiftTutorialsTests
//
//  Created by Mylo Ho on 12/4/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class RxSwiftTutorialsTests: XCTestCase {
    
    let disposeBag = DisposeBag()

    func testMapObservable() {

        // 1. Khởi tạo TestScheduler với initial virtual time 0
        let scheduler = TestScheduler(initialClock: 0)

        // 2. Khởi tạo TestableObservable với type Int
        // và định nghĩa `virtual time` cùng với `value`
        let observable = scheduler.createHotObservable([
            next(150, 1),  // (virtual time, value)
            next(210, 0),
            next(240, 4),
            completed(300)
            ])

        // 3. Khởi tạo TestableObserver
        let observer = scheduler.createObserver(Int.self)

        // 4. Sẽ thực hiện subcribe `Observable` tại thời điểm 200 (virtual time)
        scheduler.scheduleAt(200) {
            observable.map { $0 * 2 }
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }

        // 5. Start `scheduler`
        scheduler.start()

        // Events mong muốn
        let expectedEvents = [
            next(210, 0 * 2),
            next(240, 4 * 2),
            completed(300)
        ]

        // 6-1. So sánh events mà observer nhận được và events mong muốn
        XCTAssertEqual(observer.events, expectedEvents)

        // Thời gian subcribed và unsubcribed mong muốn
        let expectedSubscriptions = [
            Subscription(200, 300)
        ]

        // 6-2. So sánh virtual times khi `observable` subscribed và unsubscribed
        XCTAssertEqual(observable.subscriptions, expectedSubscriptions)
    }
    
}
