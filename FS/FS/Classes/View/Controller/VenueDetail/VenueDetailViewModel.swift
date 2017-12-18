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
import RxDataSources

enum SectionItem {
    case information(viewModel: InformationViewModel)
    case tips(viewModel: TipViewModel)
}

enum DetailVenueSection {
    case information(title: String, items: [SectionItem])
    case tips(title: String, items: [SectionItem])
}

extension DetailVenueSection: SectionModelType {
    typealias Item = SectionItem

    init(original: DetailVenueSection, items: [Item]) {
        switch original {
        case let .information(viewModel):
            self = .information(title: viewModel.title, items: viewModel.items)
        case let .tips(viewModel):
            self = .tips(title: viewModel.title, items: viewModel.items)
        }
    }
    
    var items: [SectionItem] {
        switch  self {
        case .information(title: _, items: let items):
            return items.map {$0}
        case .tips(title: _, items: let items):
            return items.map {$0}
        }
    }
}

final class VenueDetailViewModel {
    // MARK: Public properties
    var urlStrings: Variable<[String]> = Variable([])
    var dataSource: Variable<[DetailVenueSection]> = Variable([])
    var isFavorite: Variable<Bool> = Variable(false)
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
        RealmObservable.propertyChanges(from: self.venue).asObservable()
            .map({ (property) -> Bool? in
                if property.name == "isFavorite" {
                    return property.newValue as? Bool
                }
                return property.oldValue as? Bool
            })
            .unwrap()
            .bind(to: isFavorite)
            .disposed(by: disposeBag)
    }
    
    func getDetail() {
        API.getDetailVanue(id: venue.id)
            .subscribe { (event) in
                switch event {
                case .next(let venue):
                    self.venue = venue
                    let urlStrings: [String] = self.venue.photos.map { $0.path() }
                    self.urlStrings.value = urlStrings
                    let tipViewModels: [SectionItem] = self.venue.tips.map({ tip -> SectionItem in
                        let createdAt = dateTimeFormatter.string(from: tip.createdAt)
                        return SectionItem.tips(viewModel: TipViewModel(
                            title: tip.user?.fullName ?? "",
                            subtitle: tip.text, thumbImage: "",
                            timestamp: createdAt
                        ))
                    })
                    self.dataSource.value = [
                        DetailVenueSection.information(
                            title: "Information",
                            items: [
                                SectionItem.information(viewModel: InformationViewModel(title: "Name", content: self.venue.name)),
                                SectionItem.information(viewModel: InformationViewModel(title: "Address", content:  self.venue.fullAddress)),
                                SectionItem.information(viewModel: InformationViewModel(title: "Categories", content: self.venue.category)),
                                SectionItem.information(viewModel: InformationViewModel(title: "Rating", content: String(self.venue.rating))),
                            ]
                        ),
                        DetailVenueSection.tips(title: "Tips", items: tipViewModels)
                    ]
                    DatabaseManager.shared.addObject(self.venue)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite() {
        guard Venue.fetch(by: venue.id) != nil else {
            venue.isFavorite = !venue.isFavorite
            DatabaseManager.shared.addObject(venue)
            return
        }
        DatabaseManager.shared.write().subscribe({ (event) in
            switch event {
            case .completed:
                self.venue.isFavorite = !self.venue.isFavorite
            default: break
            }
        }).dispose()
    }
}
