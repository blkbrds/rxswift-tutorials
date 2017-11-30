//
//  HomeViewController.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        API.getVenues(params: [:]).subscribe { (event) in
            print(event)
            }
            .disposed(by: disposeBag)
    }
}
