//
//  API.Search.swift
//  FS
//
//  Created by Mylo Ho on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper

extension API {
    class func search(with keyword: String) -> Observable<[Venue]> {
        let path = "venues/suggestcompletion"
        let params: JSObject = [
            "query": keyword,
            "ll": "16.06778, 108.22083",
            "client_secret": "OMEDU0AA2GUBQSATQLRIHDSYYGC5JD0IPGU5II4IPDHWAYMO",
            "client_id": "ESKZ0I0VLGKYSV3KMT5FTDBS45E4HFNRYX4QFZJWMDAT3K1K",
            "v": 20170503
        ]
        return Observable<[Venue]>.create({ (observer) -> Disposable in
            _ = RxAlamofire.json(.get, apiEndpoint + path, parameters: params).subscribe(onNext: { (data) in
                guard let json = data as? JSObject,
                    let response = json["response"] as? JSObject,
                    let miniVenues = response["minivenues"] as? [JSObject],
                    let venues = Mapper<Venue>().mapArray(JSONArray: miniVenues) else {
                    observer.onError(RxError.unknown)
                    observer.onCompleted()
                    return
                }
                print(venues)
                observer.onNext(venues)
            }, onError: { (error) in
                observer.onError(error)
                observer.onCompleted()
            }, onCompleted: {
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}
