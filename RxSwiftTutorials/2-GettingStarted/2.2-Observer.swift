//
//  2.2-Observer.swift
//  RxSwiftTutorials
//
//  Created by Mylo Ho on 11/13/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import RxSwift
import RxCocoa

func pureRxSwift() {
    // Khởi tạo một Observable
    let observable = Observable.from(["🐶", "🐱", "🐭", "🐹"])

    // Thực hiện subscribe Observable
    let disposable = observable.subscribe(
        // Nơi nhận dữ liệu của Observer được gửi đi từ Observable
        onNext: { data in
            print(data)
        },
        // Nơi nhận error và Observable được giải phóng
        onError: { error in
            print(error)
        },
        // Nhận được sự kiện khi Observable hoàn thành life-cycle và Observable được giải phóng
        onCompleted: {
            print("Completed")
        })
    disposable.dispose()
}

func iOSWithRx() {
    var textField: UITextField!
    
    // Khởi tạo observable
    let observable = textField.rx.text.orEmpty

    // Thực hiện subscribe Observable
    observable.subscribe(onNext: { (text) in
        // Mỗi lần text của textField thay đổi, thì sẽ in ra giá trị mới của textField
        print(text)
    }).dispose()
}

