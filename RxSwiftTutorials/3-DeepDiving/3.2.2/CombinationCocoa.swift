//
//  CombinationCocoa.swift
//  RxSwiftTutorials
//
//  Created by Su Nguyen T. on 11/21/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CombinationCocoa: UIViewController {
    @IBOutlet private weak var textField1: UITextField!
    @IBOutlet private weak var textField2: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var tapMeButton: UIButton!
    @IBOutlet private weak var finalResultLabel: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let text1 = textField1.rx.text.orEmpty
        let text2 = textField2.rx.text.orEmpty

        // combineLatest
        let observable = Observable<String>.combineLatest(text1, text2) { $0 + " " +  $1 }
        observable.bind { [weak self] (value) in
            guard let this = self else { return }
            this.resultLabel.text = value
            }
            .disposed(by: disposeBag)

        // withLatestFrom
        let tap = tapMeButton.rx.tap.asObservable()
        tap.withLatestFrom(observable)
            .bind { [weak self] (value) in
                guard let this = self else { return }
                this.finalResultLabel.text = value
            }
            .disposed(by: disposeBag)
    }
}
