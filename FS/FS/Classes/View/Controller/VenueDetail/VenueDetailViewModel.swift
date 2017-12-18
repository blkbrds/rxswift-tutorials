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
    // MARK: Public properties
    var urlStrings: Variable<[String]> = Variable([])
    
    // MARK: Private properties
    private var disposeBag = DisposeBag()
    private var venue = Venue()
    
    init(venueId: String) {
        if let venue = Venue.fetch(by: venueId) {
            self.venue = venue
        } else {
            self.venue.id = venueId
        }
        getDetail()
    }
    
    func getDetail() {
        API.getDetailVanue(id: venue.id)
            .subscribe { (event) in
                switch event {
                case .next(let venue):
                    self.venue = venue
                    let urlStrings: [String] = self.venue.photos.map { $0.path() }
                    self.urlStrings.value = urlStrings
                    DataProvider.shared.add(self.venue)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite() {
        guard Venue.fetch(by: venue.id) != nil else {
            venue.isFavorite = !venue.isFavorite
            DataProvider.shared.add(venue)
            return
        }
        DataProvider.shared.write().subscribe({ (event) in
            switch event {
            case .completed:
                self.venue.isFavorite = !self.venue.isFavorite
            default: break
            }
        }).disposed(by: disposeBag)
        
        DataProvider.shared.propertyChanges(from: self.venue)
        .asObservable()
            .subscribe { (event) in
                print(event)
        }
        .disposed(by: disposeBag)
    }
}
