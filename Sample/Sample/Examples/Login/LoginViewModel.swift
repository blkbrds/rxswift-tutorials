//
//  LoginViewModel.swift
//  RxSwift-Demo
//
//  Created by HaiPNT on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import MVVM
import RxSwift
import RxCocoa

class User {
    var name: String = ""
    var password: String?

    init(name: String, password: String? = nil) {
        self.name = name
        self.password = password
    }
}

struct Validation {
    static let minimumPasswordLength = 5
    static let minimumUserNameLength = 5
}

class LoginViewModel: MVVM.ViewModel {

    typealias LoginViewModelParams = (userName: ControlProperty<String>, pw: ControlProperty<String>, loginTap: Observable<Void>)

    let validatedUserName: Observable<Bool>
    let validatedPassword: Observable<Bool>
    let loginEnabled: Observable<Bool>
    let loginObservable: Observable<(User, Error?)>

    init(input: LoginViewModelParams) {

        validatedUserName = input.userName
            .map { $0.characters.count >= Validation.minimumUserNameLength }
            .shareReplay(1)

        validatedPassword = input.pw
            .map { $0.characters.count >= Validation.minimumPasswordLength }
            .shareReplay(1)

        loginEnabled = Observable.combineLatest(validatedUserName, validatedPassword) { $0 && $1 }

        let userAndPassword = Observable.combineLatest(input.userName, input.pw) { ($0, $1) }

        loginObservable = input.loginTap.withLatestFrom(userAndPassword).flatMapLatest { (username, password) in
            return Observable.create { observer in
                observer.onNext((User(name: username, password: password), nil))
                return Disposables.create()
            }
        }
    }
}
