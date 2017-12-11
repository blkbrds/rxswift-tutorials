//
//  AppDelegate.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import SVProgressHUD
import FSOAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        SVProgressHUD.setDefaultMaskType(.black)
        let tabbarController = TabbarController()
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == API.User.urlScheme {
            var errorCode: FSOAuthErrorCode = .none
            if let accessCode = FSOAuth.accessCode(forFSOAuthURL: url, error: &errorCode),
                errorCode == .none {
                Helper.accessCode = accessCode
            }
        }
        return true
    }
}

func showHUD() {
    DispatchQueue.main.async {
        SVProgressHUD.show()
    }
}

func dismissHUD() {
    DispatchQueue.main.async {
        SVProgressHUD.dismiss()
    }
}
