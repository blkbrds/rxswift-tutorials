//
//  BaseViewController.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/7/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    #if TRACE_RESOURCES
    private let startResourceCount = Resources.total
    #endif

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        #if TRACE_RESOURCES
            print("Number of start resources: \(Resources.total)")
        #endif
    }

    deinit {
        #if TRACE_RESOURCES
            print("View controller disposed with \(Resources.total) resources")
            let numberOfResourcesThatShouldRemain = startResourceCount
            let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(100)
            DispatchQueue.main.asyncAfter (deadline: when) {
                assert(Resources.total <= numberOfResourcesThatShouldRemain, "Resources weren't cleaned properly, \(Resources.total) remained, \(numberOfResourcesThatShouldRemain) expected")
            }
        #endif
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "RxSwift-Demo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
