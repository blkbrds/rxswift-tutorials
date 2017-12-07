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
    var userObservable: Observable<User> = Observable<User>.of()
    var accessCodeObservable: Observable<Bool> = Observable<Bool>.of()

    private let disposeBag = DisposeBag()

    init() {
        isLogedIn = Helper.logInObservable
        accessCodeObservable = Helper.accessCodeObservable
        setupObservable()
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
