//
//  AppDelegate.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import SVProgressHUD

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
}

func showHUD() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
        SVProgressHUD.show()
    }
}

func dismissHUD() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
        SVProgressHUD.dismiss()
    }
}
