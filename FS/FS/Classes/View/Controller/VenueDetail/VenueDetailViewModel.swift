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
            DataProvider.shared.add(self.venue)
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
    
    func toggleFavorite() -> Single<Bool> {
        DataProvider.shared.propertyChanges(from: self.venue)
            .asObservable()
            .take(1)
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        let single = Single<Bool>.create { [weak self](observer) -> Disposable in
            guard let `self` = self else {
                return Disposables.create()
            }

            DataProvider.shared.write()
                .subscribe({ (event) in
                    switch event {
                    case .success(_):
                        self.venue.isFavorited = !self.venue.isFavorited
                        observer(.success(self.venue.isFavorited))
                    default: break
                    }
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
        return single
    }
}
