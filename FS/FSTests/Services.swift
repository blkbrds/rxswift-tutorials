//
//  Services.swift
//  FSTests
//
//  Created by Mylo Ho on 12/4/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

@testable import FS
import Foundation
import RxSwift
import RxTest

class NumberService {
    func fetch() -> Observable<Int> {
        let path = "http://numbersapi.com/random/year?json"
        return Observable<Int>.create({ (observer) -> Disposable in
            _ = API.request(path: path).subscribe({ (json) in
                if let data = json.element {
                    observer.onNext(data["number"] as? Int ?? 0)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}

final class MockNumberService: NumberService {

    let observable: TestableObservable<Int>

    init(observable: TestableObservable<Int>) {
        self.observable = observable
        super.init()
    }

    override func fetch() -> Observable<Int> {
        return observable.asObservable()
    }
}
