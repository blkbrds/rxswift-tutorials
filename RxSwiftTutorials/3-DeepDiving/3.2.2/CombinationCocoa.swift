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
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        combineLatest()
    }

    private func combineLatest() {
        let t1 = textField1.rx.text.orEmpty
        let t2 = textField2.rx.text.orEmpty

        let observable = Observable<String>.combineLatest(t1, t2) { $0 + " " + $1 }
        observable
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: disposeBag)
    }
}
