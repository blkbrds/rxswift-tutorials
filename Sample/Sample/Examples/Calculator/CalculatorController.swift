//
//  CalculatorController.swift
//  RxSwift
//
//  Created by Huynh Quang Tien on 6/5/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CalculatorController: BaseViewController {
    @IBOutlet private weak var firstNumberField: UITextField!
    @IBOutlet private weak var secondNumberField: UITextField!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var subButton: UIButton!
    @IBOutlet private weak var multiButton: UIButton!
    @IBOutlet private weak var divideButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!

    enum Math: Int {
        case plus = 0
        case sub
        case multi
        case divide
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservable()
    }

    private func setupObservable() {
        // create observable that return type enum Math
        let plus = plusButton.rx.tap.map { Math.plus }
        let sub = subButton.rx.tap.map { Math.sub }
        let multi = multiButton.rx.tap.map { Math.multi }
        let divide = divideButton.rx.tap.map { Math.divide }
        let taps = Observable.of(plus, sub, multi, divide).merge().startWith(Math.plus)

        // Observable for event text change or tap button
        Observable.combineLatest(firstNumberField.rx.text.orEmpty, secondNumberField.rx.text.orEmpty, taps) { (firstValue, secondValue, math) -> Int in
            let first = Int(firstValue) ?? 0
            let second = Int(secondValue) ?? 0
            return self.calculate(first: first, second: second, math: math)
        }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)

        // receive events tap button
        taps.subscribe(onNext: { [weak self] math in
            guard let this = self else { return }
            let selectedColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
            this.plusButton.backgroundColor = (math == .plus ? selectedColor : UIColor.lightGray)
            this.subButton.backgroundColor = (math == .sub ? selectedColor : UIColor.lightGray)
            this.multiButton.backgroundColor = (math == .multi ? selectedColor : UIColor.lightGray)
            this.divideButton.backgroundColor = (math == .divide ? selectedColor : UIColor.lightGray)
        })
            .disposed(by: disposeBag)
    }

    private func calculate(first: Int, second: Int, math: Math) -> Int {
        switch math {
        case .plus: return first + second
        case .sub: return first - second
        case .multi: return first * second
        case .divide: return second > 0 ? (first / second) : 0
        }
    }
}
