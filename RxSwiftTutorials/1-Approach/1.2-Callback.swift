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
//      - there's only one case in definition
//      - the refer's process only, no referenced subject is needed
//    Callback (completion block) is created for this.

private func test() {
    let dev = Developer()
    dev.start(.implement(taskId: "123"), completion: { result in
        switch result {
        case .merged:       dev.start(.drinkBeer, completion: nil)
        case .rejected:     dev.start(.report, completion: nil)
        }
    })
}

//------------------------------------------------------------

import Foundation

private enum TaskResult {
    case merged
    case rejected
}

private class Developer {
    func start(_ task: Task, completion: ((TaskResult) -> Void)?) {
        
    }
}

//------------------------------------------------------------

private enum Task {
    case implement(taskId: String)
    case report
    case drinkBeer
}
