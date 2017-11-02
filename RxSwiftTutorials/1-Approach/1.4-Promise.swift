//
//  Promise.swift
//  RxSwiftTutorials
//
//  Created by Dao Nguyen V. on 9/25/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

//------------------------------------------------------------
//
//    Promise - the golden path keeper & nested callback avoiding

private func test() {
    let dev = Developer()
    // via regular way
    dev.start(.implement(taskId: "123"), completion: { result in
        switch result {
        case .merged:
            dev.start(.drinkBeer, completion: nil)
        case .rejected:
            dev.start(.report, completion: nil)
        }
    })
    // via promise
    dev.start(.implement(taskId: "123"))
        .then { _ in dev.start(.drinkBeer) }
        .catch { _ in dev.start(.report) }
}

//------------------------------------------------------------

import Foundation
import PromiseKit

private enum TaskResult {
    case merged
    case rejected // converted to error in promise
}

private class Developer {
    // via regular way
    func start(_ task: Task, completion: ((TaskResult) -> Void)?) {
        completion?(.merged) // or
        completion?(.rejected)
    }

    // via promise
    @discardableResult
    func start(_ task: Task) -> Promise<TaskResult> {
        return Promise { fulfill, reject in
            fulfill(.merged) // or
            reject(Issue.bug)
        }
    }
}

//------------------------------------------------------------

private enum Task {
    case implement(taskId: String)
    case report
    case drinkBeer
}

private enum Issue: Error {
    case bug
    case feature
}

private typealias YesNo = Bool
private let Yes = true
private let No = false
