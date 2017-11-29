//
//  API.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias JSObject = [String: Any]

let apiEndpoint = "https://api.foursquare.com/v2/"

class API {
    class func request(path: String) -> Observable<JSObject> {
        guard let url = URL(string: apiEndpoint + path) else { return .empty() }
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
