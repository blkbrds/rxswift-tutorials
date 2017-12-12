//
//  ProfileViewModel.swift
//  FS
//
//  Created by Su Nguyen T. on 12/6/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import MVVM
import RxSwift
import FSOAuth

final class ProfileViewModel: ViewModel {
    var isLogedIn: Observable<Bool>
    var canLogIn: Observable<Bool>
    var error = PublishSubject<Error>()
    var name = BehaviorSubject<String>(value: "")
    var email = BehaviorSubject<String>(value: "")
    var address = BehaviorSubject<String>(value: "")
    var gender = BehaviorSubject<String>(value: "")
    var avatarURL = BehaviorSubject<URL?>(value: nil)

    private var userObservable = Single<User>.never() {
        didSet {
            userObservable
                .observeOn(MainScheduler.instance)
                .subscribe({ [weak self] event in
                    guard let this = self else { return }
                    switch event {
                    case .success(let user): this.receivedResponse(user: user)
                    case .error(let error): this.error.onNext(error)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    private let disposeBag = DisposeBag()

    init() {
        isLogedIn = Helper.logInObservable
        canLogIn = Helper.canLogIn
        setupObservable()
    }

    func clearData() {
        name.onNext("")
        address.onNext("")
        email.onNext("")
        avatarURL.onNext(nil)
        gender.onNext("")
    }

    private func receivedResponse(user: User) {
        name.onNext(user.name)
        address.onNext(user.address)
        email.onNext(user.email)
        avatarURL.onNext(user.avatar)
        gender.onNext(user.gender)
    }

    private func setupObservable() {
        isLogedIn.filter({ $0 })
            .subscribe(onNext: { _ in
                self.userObservable = API.User.getProfile()
        }).disposed(by: disposeBag)

        canLogIn.filter({ $0 })
            .subscribe(onNext: { _ in
            API.User.getAccessToken()
                .observeOn(MainScheduler.instance)
                .subscribe({ (event) in
                    switch event {
                    case .error(let error): self.error.onNext(error)
                    default: break
                    }
                }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
