//
//  API.Venue.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

extension API {
    // Just example
    class func getVenues(params: JSObject) -> Observable<[Venue]> {
        var path = "venues/explore?client_secret=OMEDU0AA2GUBQSATQLRIHDSYYGC5JD0IPGU5II4IPDHWAYMO&limit=10&ll=16.054407,108.202167&client_id=ESKZ0I0VLGKYSV3KMT5FTDBS45E4HFNRYX4QFZJWMDAT3K1K&v=20170503&venuePhotos=1"
        for param in params {
            path += "&\(param.key)=\(String(describing: param.value))"
        }
        let ob = Observable<[Venue]>.create { (observer) -> Disposable in
            _ = API.request(path: path).subscribe({ (json) in
                var venues: [Venue] = []
                guard let groups = json.element?["groups"] as? JSArray else {
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
                observer.onCompleted()
                DatabaseManager.shared.addObjects(venues)
            })
            return Disposables.create()
        }
        return ob
    }
}
