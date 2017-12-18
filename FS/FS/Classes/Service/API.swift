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

class API {
    static let clientId = "J1G4TOY3HLH504HI42JQ3ACQTLYGOYZ4ARC2VBG3IE1DLTTX"
    static let clientSecret = "S1HWM5P0CJKJZICFHSHLQ4SVINTWZINKNGCNYXOZRAN1JC3X"
    static let version = "20171207"

    struct User { }

    class func request(path: String) -> Observable<JSObject> {
        guard let url = URL(string: apiEndpoint + path) else { return .empty() }

        return Observable<JSObject>.create({ (observer) -> Disposable in
            _ = URLSession.shared.rx.data(request: URLRequest(url: url))
                .catchError({ (error) -> Observable<Data> in
                    observer.onError(error)
                    return .empty()
                })
                .map { data -> JSObject in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSObject
                        return json ?? [:]
                    } catch {
                        return [:]
                    }
                }
                .observeOn(MainScheduler.instance)
                .map{ js -> JSObject in
                    guard let json = js["response"] as? JSObject else {

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
