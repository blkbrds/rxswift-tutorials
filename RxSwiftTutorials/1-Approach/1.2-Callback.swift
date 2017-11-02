//
//  Callback.swift
//  RxSwiftTutorials
//
//  Created by Dao Nguyen V. on 9/25/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

//------------------------------------------------------------
//
//    The delegation is clear enough.
//    But, sometime:
//      - There's only one case in definition
//      - The refer's process only, no referenced subject is needed
//    Callback (completion block) is created for this.

private func test() {
    let dev = Developer()
    dev.start(
        shouldStart: { (task) -> Bool in
            switch task.id {
            case "123": return Yes
            default: return No
            }
        },
        completion: { (report) in
            switch report {
            case .allFine:
                dev.drinkBeer()
            case .hasProblems:
                dev.report()
            }
        }
    )
}

//------------------------------------------------------------

import Foundation

private class Developer {
    let tasks: [Task] = [Task(id: "123"), Task(id: "456")]

    func start(shouldStart: (Task) -> Bool, completion: (TodayReport) -> Void) {
        var report = TodayReport.allFine
        for task in tasks {
            let result = start(task)
            if result == .rejected {
                report = .hasProblems
            }
        }
        completion(report)
    }

    func start(_ task: Task) -> TaskResult { return .merged }
    func stop() { }
    func report() { }
    func drinkBeer() { }
}

//------------------------------------------------------------

private class Task {
    let id: String
    init(id: String) {
        self.id = id
    }
}

private enum TaskResult {
    case merged
    case rejected
}

private enum TodayReport {
    case allFine
    case hasProblems
}

private enum Issue: Error {
    case bug
    case feature
}

private typealias YesNo = Bool
private let Yes = true
private let No = false
