//
//  Services.swift
//  RxSwiftTutorialsTests
//
//  Created by Mylo Ho on 12/4/17.
//  Copyright © 2017 Asian Tech Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import RxCocoa

class NumberService {
    func fetch() -> Observable<Int> {
        let path = "http://numbersapi.com/42?json"
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

typealias JSObject = [String: Any]

class API {
    class func request(path: String) -> Observable<JSObject> {
        guard let url = URL(string: path) else { return .empty() }
        return Observable<JSObject>.create({ (observer) -> Disposable in
            _ = URLSession.shared.rx.json(url: url)
                .observeOn(MainScheduler.instance)
                .map{ js -> JSObject in
                    guard let json = js as? JSObject else {
                        observer.onError(RxError.unknown)
                        observer.onCompleted()
                        return [:]
                    }
                    return json
                }
                .subscribe(onNext: { (json) in
                    observer.onNext(json)
                    observer.onCompleted()
                })
            return Disposables.create()
        })
    }
}
