//
//  ProfileViewModel.swift
//  FS
//
//  Created by Su Nguyen T. on 12/6/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import MVVM
import RxSwift

final class ProfileViewModel: ViewModel {
    var isLogedIn: Observable<Bool> = Observable<Bool>.of()
    var accessCodeObservable: Observable<Bool> = Observable<Bool>.of()
    var error = PublishSubject<Error>()
    var name = PublishSubject<String>()
    var email = PublishSubject<String>()
    var address = PublishSubject<String>()
    var gender = PublishSubject<String>()
    var avatarURL = PublishSubject<URL?>()

    private var userObservable: Single<User> = Single<User>.never() {
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
        accessCodeObservable = Helper.accessCodeObservable
        setupObservable()
    }

    private func receivedResponse(user: User) {
        name.onNext(user.name)
        address.onNext(user.address)
        email.onNext(user.email)
        avatarURL.onNext(user.avatar)
        gender.onNext(user.gender)
    }

    private func setupObservable() {
        isLogedIn.subscribe(onNext: { [weak self] isLoged in
            guard let this = self else { return }
            if isLoged {
                this.userObservable = API.User.getProfile()
            } else {
                this.login()
            }
        }).disposed(by: disposeBag)
    }

    private func login() {
        accessCodeObservable.subscribe(onNext: { [weak self] isHas in
            guard let this = self else { return }
            if isHas {
                let observable = API.User.getAccessToken()
                observable.subscribe({ (value) in
                    print(value)
                }).disposed(by: this.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
}
