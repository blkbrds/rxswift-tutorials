//
//  VenueDetailViewController.swift
//  FS
//
//  Created by at-thinhuv on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class VenueDetailViewController: ViewController {
    var viewModel: VenueDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
        view.addSubview(button)
        button.backgroundColor = .red
        button.setTitle("Favorite", for: .normal)
        button.rx.tap.subscribe { (_) in

        }
        .disposed(by: disposeBag)
        viewModel?.venue?
            .map { $0.favorite }
            .bind(to: button.rx.title())
            .disposed(by: disposeBag)
    }
}
