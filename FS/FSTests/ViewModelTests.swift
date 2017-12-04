//
//  ViewModelTests.swift
//  FSTests
//
//  Created by Mylo Ho on 12/4/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class ViewModelTests: XCTestCase {

    let disposeBag = DisposeBag()

    func testStateWhenFetch() {
        let scheduler = TestScheduler(initialClock: 0)

        let observer = scheduler.createObserver(State.self)

        let observable = scheduler.createColdObservable([
            next(100, 999)
        ])

        let service = MockNumberService(observable: observable)
        let viewModel = ViewModel(service: service)

        scheduler.scheduleAt(100) {
            viewModel.state.asObservable()
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }

        scheduler.scheduleAt(200) {
            viewModel.fetch()
        }

        scheduler.start()

        let expectedEvents = [
            next(100, State.loaded(0)),
            next(200, State.loading),
            next(300, State.loaded(999))
        ]
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
