//
//  InformationViewModel.swift
//  FS
//
//  Created by Hoa Nguyen on 12/18/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct InformationSection {
    var title: String
    var items: [Item]
}

extension InformationSection: SectionModelType {
    typealias Item = InformationViewModel
    
    init(original: InformationSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct InformationViewModel {
    var title: String
    var content: String
}
