//
//  ViewController.swift
//  RxSwiftTutorials
//
//  Created by Dao Nguyen V. on 9/25/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                let a = element + "a"
                observer.on(.next(a))
                observer.on(.completed)
                return Disposables.create()
            }
        }

        myJust("abc").do(onNext: { (str) in
            print("do ----->" + str)
        }).subscribe(onNext: { (str) in
            print("subscribe ------>" + str)
        }).dispose()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

