//
//  GalleryImageViewController.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/22/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryImageViewController: BaseViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservable()
    }

    private func setupObservable() {
        segmentedControl.rx.selectedSegmentIndex
            // Check index < segmentedControl.numberOfSegments
            .filter({ [weak self] (index) -> Bool in
                guard let this = self else { return false }
                return index < this.segmentedControl.numberOfSegments
            })
            .subscribe(onNext: { [weak self] (index) in
                guard let this = self else { return }
                this.imageView.contentMode = UIViewContentMode(rawValue: index) ?? .scaleToFill
            })
        .disposed(by: disposeBag)
    }
}
