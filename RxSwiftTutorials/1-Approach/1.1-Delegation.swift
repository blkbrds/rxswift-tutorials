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
    func me(_ me: Developer, shouldStart task: Task) -> YesNo {
        switch task {
        case .implement(_): return Yes
        case .report:       return Yes
        case .drinkBeer:    return No
        }
    }
}

private protocol DeveloperDelegation {
    func me(_ me: Developer, shouldStart task: Task) -> YesNo
}

private class Developer {
    var leader: DeveloperDelegation!
    var tasks: [Task] = [.implement(taskId: "123"), .implement(taskId: "456"), .report, .drinkBeer]
    
    func start() {
        for task in tasks {
            guard leader.me(self, shouldStart: task) else { continue }
            start(task)
        }
        stop()
    }
    
    func start(_ task: Task) { }
    
    func stop() { }
}

//------------------------------------------------------------

private enum Issue: Error {
    case bug
    case feature
}

private enum Task {
    case implement(taskId: String)
    case report
    case drinkBeer
}

private typealias YesNo = Bool
private let Yes = true
private let No = false
