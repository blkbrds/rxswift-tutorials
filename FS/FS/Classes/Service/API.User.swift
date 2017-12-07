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

    static func getAccessToken() -> Observable<Void> {
        let observable = Observable<Void>.create { (observer) -> Disposable in
            FSOAuth.requestAccessToken(forCode: Helper.accessCode, clientId: API.clientId, callbackURIString: callbackString, clientSecret: API.clientSecret) { (accessToken, isSuccess, errorCode) in
                if let accessToken = accessToken, isSuccess {
                    Helper.accessToken = accessToken
                    Helper.isLogedIn = true
                    observer.onCompleted()
                } else {
                    observer.onError(RxError.unknown)
                }
            }
            return Disposables.create()
        }
        return observable
    }

    static func getProfile() -> Observable<User> {
        let observable = Observable<User>.create { (observer) -> Disposable in
            let path = profilePath + "?oauth_token=\(Helper.accessToken)&v=20171207"
            _ = API.request(path: path).subscribe({ (value) in
                guard let json = value.element,
                    let userJson = json["user"] as? JSObject,
                    let user = Mapper<User>().map(JSON: userJson) else {
                    observer.onError(RxError.noElements)
                        return
                }
                observer.onNext(user)
                observer.onCompleted()
            })
            return Disposables.create()
        }
        return observable
    }
}

final class Helper {
    static let logInObservable = BehaviorSubject<Bool>(value: isLogedIn)
    private static var isLogedInKey: String { return "isLogedInKey" }
    static var isLogedIn: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: isLogedInKey)
            UserDefaults.standard.synchronize()
            logInObservable.onNext(newValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: isLogedInKey)
        }
    }

    private static var accessTokenKey: String { return "accessTokenKey" }
    static var accessToken: String {
        set {
            UserDefaults.standard.set(newValue, forKey: accessTokenKey)
            UserDefaults.standard.synchronize()
        }
        get {
            if let token = UserDefaults.standard.string(forKey: accessTokenKey) {
                 return token
            }
            return ""
        }
    }

    static let accessCodeObservable = BehaviorSubject<Bool>(value: false)
    private static var accessCodeKey: String { return "accessCodeKey" }
    static var accessCode: String {
        set {
            UserDefaults.standard.set(newValue, forKey: accessCodeKey)
            UserDefaults.standard.synchronize()
            accessCodeObservable.onNext(true)
        }
        get {
            if let code = UserDefaults.standard.string(forKey: accessCodeKey) {
                return code
            }
            return ""
        }
    }
}
