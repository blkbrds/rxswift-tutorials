//
//  VenueDetailViewModel.swift
//  FS
//
//  Created by at-thinhuv on 12/5/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

final class VenueDetailViewModel {
    var venueDetailService: Observable<Venue>!
    private var disposeBag = DisposeBag()

    init(venueId: String) {
        venueDetailService = API.getDetailVanue(id: venueId)
    }

    func getPhotoUrls(size: CGSize) -> Observable<[String]> {
        return Observable.create({ observer -> Disposable in
            self.venueDetailService.subscribe({ event in
                guard let venue = event.element else {
                    return //handle error later
                }
                let width = Int(size.width)
                let height = Int(size.height)
                let size = "\(width)x\(height)"
                let urls: [String] = venue.photos.map { "\($0.prefix)\(size)\($0.suffix)" }
                observer.onNext(urls)
                observer.onCompleted()
            })
        })
    }

    func toggleFavorite() {
        DatabaseManager.shared.write().subscribe({ (event) in
            switch event {
            case .completed: break
            //                self.venue.value.isFavorite = !self.venue.value.isFavorite
            default: break
            }
        }).dispose()
    }
}
