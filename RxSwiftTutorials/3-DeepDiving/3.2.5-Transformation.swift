//
//  3.2.5-Transformation.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/27/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class Transformation {

    let disposeBag = DisposeBag()

    init() {
        window()
    }

    private func buffer() {
        _ = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
            .map { Int($0) }
            .buffer(timeSpan: 1, count: 10, scheduler: MainScheduler.instance)
            .subscribe({ (value) in
                print(value)
            })
    }

    private func map() {
        let observable = Observable<Int>.of(1, 2, 3)
        observable.map { $0 * 10 }
            .subscribe(onNext: { value in
                print(value)
            }).dispose()
    }

    private func flatMap() {
        struct Player {
            var score: Variable<Int>
        }

        let 👦🏻 = Player(score: Variable<Int>(80))
        let player = Variable(👦🏻)
        player.asObservable()
            .flatMap { $0.score.asObservable() }
            .subscribe(onNext: { print("score: \($0)") })
            .disposed(by: disposeBag)
        player.asObservable()
            .flatMap({ $0.score.asObservable().map({ $0 * 10 })})
            .subscribe(onNext: { print("score: \($0)") })
            .disposed(by: disposeBag)
    }

    private func groupBy() {
        struct Message {
            var id: Int
            var msgContent: String
            var date: String
            var isRead: Bool
        }

        let messages = [
            Message(id: 1001, msgContent: "TextContent1", date: "2017-01-01", isRead: true),
            Message(id: 1002, msgContent: "TextContent2", date: "2017-01-01", isRead: false),
            Message(id: 1003, msgContent: "TextContent3", date: "2017-01-01", isRead: true),
            Message(id: 1004, msgContent: "TextContent4", date: "2017-01-01", isRead: false),
            Message(id: 1005, msgContent: "TextContent5", date: "2017-01-01", isRead: false),
            Message(id: 1006, msgContent: "TextContent6", date: "2017-01-01", isRead: true)
        ]

        let source = Observable.from(messages)

        let group = source.groupBy { $0.isRead }
        group
            .map({ (item) -> Observable<Message> in
                if item.key {
                    return item.asObservable()
                }
                return Observable<Message>.of()
            })
            .flatMap({ $0.asObservable() })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }

    private func scan() {
        let observable = Observable<Int>.of(1, 2, 3, 4, 5)
        observable
            .scan(0) { (seed, value) -> Int in
                return seed + value
            }
            .toArray()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }

    private func window() {
        _ = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
            .map { Int($0) }
            .window(timeSpan: 1, count: 10, scheduler: MainScheduler.instance)
            .flatMap({ $0 })
            .subscribe({ (value) in
                print(value)
            })
    }
}
