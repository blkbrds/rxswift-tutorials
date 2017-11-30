//
//  3.2.4-Mathematical.swift
//  RxSwiftTutorials
//
//  Created by Linh Vo D. on 11/29/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift

final class Mathematical {

    init() {}

    // ---Concat Operator---
    func concat() {
        // Reference 3.2.2-Combination
    }

    // ---ToArray Operator---
    func toArray() {
        let disposeBag = DisposeBag()
        // Chuyển một chuỗi có thể quan sát được thành một mảng tập hợp.
        Observable.of(1, 2, 3, 5)
            .toArray()
            .subscribe({ print("1235 em có đánh rơi nhịp nào không?", $0) })
            .disposed(by: disposeBag)
    }

    // ---Reduce Operator---
    func reduce() {
        let disposeBag = DisposeBag()
        // Tính toán dựa trên giá trị ban đầu và các toán tử +, -, *, /, … chuyển đổi thành một observable đơn.
        Observable.of(1, 2, 3, 4, 5)
            .reduce(1, accumulator: +)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
