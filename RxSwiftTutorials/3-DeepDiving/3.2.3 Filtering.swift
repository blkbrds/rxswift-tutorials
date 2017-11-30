//
//  3.2.3 Filtering.swift
//  RxSwiftTutorials
//
//  Created by Quang Phu C. M. on 11/30/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class Filtering {
    init() {
        ignoreElemens()
    }

    func execute() {
        ignoreElemens()
        elementAt(n: 3)

        skip(n: 2)
        skipWhile()
        skipUntil()

        take(n: 4)
        takeUntil()

        distinctUntilChanged()
    }
}

// MARK: - Ignoring operators
extension Filtering {
    func ignoreElemens() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()

        // Subscribe tất cả các events được phát ra từ strike nhưng bỏ qua tất cả các sự kiện .next

        strikes
            .ignoreElements()
            .subscribe { _ in
                print("You're out!")
            }
            .disposed(by: disposeBag)

        strikes.onNext("X")
        strikes.onNext("Y")
        strikes.onNext("Z")
        strikes.onCompleted()
    }

    func elementAt(n: Int) {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        // Cho phép nhận item được phát ra tại lần phát thứ n
        strikes
            .elementAt(n)
            .subscribe(onNext: { item in
                print(item)
            })
            .disposed(by: disposeBag)

        strikes.onNext("A")
        strikes.onNext("B")
        strikes.onNext("C")
    }
}

// MARK: - Skipping operators
extension Filtering {
    func skip(n: Int) {
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C", "D", "E", "F")
            // Bỏ qua các items được phát từ lần phát thứ 1 đến 3.
            .skip(3)
            .subscribe(onNext: {
                print($0) })
            .disposed(by: disposeBag)
    }

    func skipWhile() {
        let disposeBag = DisposeBag()
        Observable.of(2, 2, 3, 4, 4)
            // Sẽ bỏ qua những items chia hết cho 2 cho đến khi nó gặp 1 item không thoả mãn.
            .skipWhile { integer in
                integer % 2 == 0
            }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    func skipUntil() {
        let disposeBag = DisposeBag()
        // subject sẽ phát ra các items
        // trigger được dùng như là 1 cái cò để báo dừng việc bỏ qua các items đó
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()

        subject
            .skipUntil(trigger)
            .subscribe(onNext: {
                print($0) })
            .disposed(by: disposeBag)

        // Đầu tiên subject sẽ phát đi 2 items. Nhưng không có gì được in ra. Vì chúng đang được skip.
        subject.onNext("A")
        subject.onNext("B")

        /*  Khi trigger phát đi 1 item thì việc bỏ qua những item phát ra bởi
        subject sẽ được ngăn chặn. Có nghĩa là từ thời điểm đó mọi sự kiện
        được phát ra từ subject được thông qua.
         */
        trigger.onNext("X")

        subject.onNext("C")
    }
}

// MARK: - Taking operators
extension Filtering {
    func take(n: Int) {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
            // Nhận các items từ lần phát thứ 1 đến thứ n
            .take(n)
            .subscribe(onNext: {
                print($0) })
            .disposed(by: disposeBag)
    }

    func takeUntil() {
        let disposeBag = DisposeBag()
        // subject sẽ phát ra các items
        // trigger được dùng như là 1 cái cò để báo dừng việc nhận
        // các items được phát ra từ subject
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()

        subject
            .takeUntil(trigger)
            .subscribe(onNext: {
                print($0) })
            .disposed(by: disposeBag)

        subject.onNext("1")
        subject.onNext("2")
        trigger.onNext("Stop")
        subject.onNext("3")
        subject.onNext("4")
    }
}

// MARK: - Distinct operators
extension Filtering {
    func distinctUntilChanged() {
        let disposeBag = DisposeBag()
        Observable.of("A", "A", "B", "B", "A")
            // Nó sẽ bỏ qua các items bị duplicate nằm liền kề nhau. Ở đây `A` tại index 1 và `B` tại index 3
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0) })
            .disposed(by: disposeBag)
    }
}
