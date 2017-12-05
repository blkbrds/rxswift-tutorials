//
//  ViewModel.swift
//  RxSwiftTutorialsTests
//
//  Created by Mylo Ho on 12/4/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import Foundation
import RxSwift

final class ViewModel {
    let disposeBag = DisposeBag()

    // State of API
    var state: Variable<State> = Variable(.loaded(0))

    private var service: NumberService

    init(service: NumberService) {
        self.service = service
    }

    // Action method to search followers
    func fetch() -> Observable<Int> {
        state.value = .loading
        let observable = service.fetch()
        observable.subscribe(onNext: { (number) in
            self.state.value = .loaded(number)
        }, onError: { (error) in
            self.state.value = .error(error)
        }).disposed(by: disposeBag)
        return observable
    }
}

enum State {
    case loading
    case loaded(Int)
    case error(Error)
}

extension State: Equatable {
    static func == (lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .error(err1), let .error(err2)):
            return err1.localizedDescription == err2.localizedDescription
        case (let .loaded(num1), let .loaded(num2)):
            return num1 == num2
        default:
            return false
        }
    }
}
