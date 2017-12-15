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
    var venue: Venue!
    var venueDetailService: Observable<Venue>!
    private var disposeBag = DisposeBag()

    init(venueId: String) {
        if let venue = Venue.fetch(by: venueId) {
            self.venue = venue
        }
        venueDetailService = API.getDetailVanue(id: venueId)
    }

    func getPhotoUrls(size: CGSize) -> Observable<[String]> {
        return Observable.create({ observer -> Disposable in
            self.venueDetailService.subscribe({ [weak self] event in
                guard let this = self, let venue = event.element else {
                    return //handle error later
                }
                this.venue = venue
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
        guard let venue = self.venue else { return }
        guard Venue.fetch(by: venue.id) != nil else {
            venue.isFavorite = !venue.isFavorite
            DatabaseManager.shared.addObject(venue)
            return
        }
        DatabaseManager.shared.write().subscribe({ (event) in
            switch event {
            case .completed:
                venue.isFavorite = !venue.isFavorite
            default: break
            }
        }).dispose()
    }
}
