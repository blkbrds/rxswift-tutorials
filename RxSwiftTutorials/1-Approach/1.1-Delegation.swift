//
//  Delegation.swift
//  RxSwiftTutorials
//
//  Created by Dao Nguyen V. on 9/25/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

//------------------------------------------------------------

private func test() {
    let dev = Developer()
    dev.leader = Leader()
    dev.start() // How can developer refer leader for decision making?
}

//------------------------------------------------------------

import Foundation

private class Leader: DeveloperDelegation {
    func dev(_ dev: Developer, shouldStart task: Task) -> YesNo {
        switch task.id {
        case "123": return Yes
        default: return No
        }
    }

    func dev(_ dev: Developer, complete task: Task, result: TaskResult) {
        switch result {
        case .merged: dev.drinkBeer()
        case .rejected: dev.report()
        }
    }
}

private protocol DeveloperDelegation {
    func dev(_ dev: Developer, shouldStart task: Task) -> YesNo
    func dev(_ dev: Developer, complete task: Task, result: TaskResult)
}

private class Developer {
    var leader: DeveloperDelegation!
    let tasks: [Task] = [Task(id: "123"), Task(id: "456")]

    func start() {
        for task in tasks {
            guard leader.dev(self, shouldStart: task) else { continue }
            let result = start(task)
            leader.dev(self, complete: task, result: result)
        }
        stop()
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

private enum Issue: Error {
    case bug
    case feature
}

private typealias YesNo = Bool
private let Yes = true
private let No = false
