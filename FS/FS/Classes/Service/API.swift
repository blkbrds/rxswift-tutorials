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
typealias JSArray = [JSObject]

let apiEndpoint = "https://api.foursquare.com/v2/"
let bag = DisposeBag()
class API {
    class func request(path: String, showHUD: Bool = true) -> Observable<JSObject> {
        guard let url = URL(string: apiEndpoint + path) else { return .empty() }
        let ob = Observable<JSObject>.create({ (observer) -> Disposable in
            _ = URLSession.shared.rx.json(url: url)
                .observeOn(MainScheduler.instance)
                .map{ js -> JSObject in
                    guard let json = (js as? JSObject)?["response"] as? JSObject else {
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
        if showHUD {
            ob.withHUD().subscribe()
            .disposed(by: bag)
        }
        return ob
    }
}
