//
//  VenueCellViewModel.swift
//  FS
//
//  Created by Linh Vo D. on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift

final class VenueCellViewModel {

    private var venue: Venue
    let disposeBag = DisposeBag()
    var name: BehaviorSubject<String>
    var address: BehaviorSubject<String>
    var rating: BehaviorSubject<String>
    var image: BehaviorSubject<UIImage?>

    var photoURL: URL? {
        return URL(string: venue.thumbnail?.path() ?? "")
    }

    var venueId: String {
        get {
            return venue.id
        }
    }

    init(venue: Venue = Venue()) {
        self.venue = venue
        name = BehaviorSubject<String>(value: venue.name)
        address = BehaviorSubject<String>(value: venue.fullAddress)
        rating = BehaviorSubject<String>(value: String(describing: venue.rating))
        image = BehaviorSubject<UIImage?>(value: #imageLiteral(resourceName: "ic-github"))

        guard let url = photoURL else { return }
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .subscribe(onNext: { [weak self] (data) in
                guard let this = self else { return }
                DispatchQueue.main.async {
                    this.image.onNext(UIImage(data: data))
                }
            })
            .disposed(by: disposeBag)
    }
}
