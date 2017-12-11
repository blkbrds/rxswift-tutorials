//
//  API.User.swift
//  FS
//
//  Created by Su Nguyen on 12/6/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import RxSwift
import FSOAuth
import ObjectMapper

extension API.User {
    static let urlScheme: String = "rxswiftapp"
    static let callbackString: String = urlScheme + "://authorized"
    static var profilePath: String { return "users/self" }

    static func login() {
        FSOAuth.authorizeUser(usingClientId: API.clientId,
                              nativeURICallbackString: callbackString,
                              universalURICallbackString: "",
                              allowShowingAppStore: true)
    }

    static func getAccessToken() -> Completable {
        let completable = Completable.create { (observer) -> Disposable in
            FSOAuth.requestAccessToken(forCode: Helper.accessCode, clientId: API.clientId, callbackURIString: callbackString, clientSecret: API.clientSecret) { (accessToken, isSuccess, errorCode) in
                if let accessToken = accessToken, isSuccess {
                    Helper.accessToken = accessToken
                    Helper.isLogedIn = true
                    observer(.completed)
                } else {
                    observer(.error(RxError.unknown))
                }
            }
            return Disposables.create()
        }
        return completable
    }

    static func getProfile() -> Single<User> {
        let observable = Single<User>.create { (observer) -> Disposable in
            let path = profilePath + "?oauth_token=\(Helper.accessToken)&v=20171207"
            _ = API.request(path: path).subscribe({ (value) in
                guard let json = value.element,
                    let userJson = json["user"] as? JSObject,
                    let user = Mapper<User>().map(JSON: userJson) else {
                    observer(.error(RxError.noElements))
                        return
                }
                observer(.success(user))
            })
            return Disposables.create()
        }
        return observable
    }
}
