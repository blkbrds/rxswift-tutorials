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
        let path = "venues/explore"
        let params: JSObject = [
            "query": keyword,
            "ll": "16.06778, 108.22083",
            "client_secret": "OMEDU0AA2GUBQSATQLRIHDSYYGC5JD0IPGU5II4IPDHWAYMO",
            "client_id": "ESKZ0I0VLGKYSV3KMT5FTDBS45E4HFNRYX4QFZJWMDAT3K1K",
            "v": 20170503,
            "venuePhotos": 1
        ]
        return Observable<[Venue]>.create({ (observer) -> Disposable in
            _ = RxAlamofire.json(.get, apiEndpoint + path, parameters: params).subscribe(onNext: { (data) in
                var venues: [Venue] = []
                guard let json = data as? JSObject,
                    let response = json["response"] as? JSObject,
                    let groups = response["groups"] as? JSArray else {
                    observer.onError(RxError.noElements)
                    return
                }
                guard let items = groups.first?["items"] as? JSArray else {
                    observer.onError(RxError.noElements)
                    return
                }
                for item in items {
                    if let venueObject = item["venue"] as? JSObject {
                        if let venue = Mapper<Venue>().map(JSON: venueObject) {
                            venues.append(venue)
                        }
                    }
                }
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
