//
//  1.5-Reactive.swift
//  RxSwiftTutorials
//
//  Created by Deploy on 11/2/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import Foundation
import RxSwift

private class Developer {
    let bags = DisposeBag()
    let tasks: [Task] = [.implement(taskId: "123"), .implement(taskId: "456")]

    private func start() {
        let obj = Observable.from(tasks)
        obj.subscribe(
            onNext: { event in
                //
            }, onError: { error in
                //
            }, onCompleted: {
                //
            }, onDisposed: {
                //
            }
        ).disposed(by: bags)
    }
    
    func report() { }
    func drinkBeer() { }
}

private enum Task {
    case implement(taskId: String)
    case report
    case drinkBeer
}
