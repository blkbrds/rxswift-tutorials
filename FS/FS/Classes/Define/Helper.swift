//
//  Helper.swift
//  FS
//
//  Created by NTs on 12/11/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import RxSwift

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

    static let canLogIn = BehaviorSubject<Bool>(value: false)
    private static var accessCodeKey: String { return "accessCodeKey" }
    static var accessCode: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: accessCodeKey)
            UserDefaults.standard.synchronize()
            canLogIn.onNext(newValue != nil)
        }
        get {
            if let code = UserDefaults.standard.string(forKey: accessCodeKey) {
                return code
            }
            return ""
        }
    }
}
