//
//  TipViewModel.swift
//  FS
//
//  Created by Hoa Nguyen on 12/18/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxDataSources

struct TipSection {
    var title: String
    var items: [Item]
}

extension TipSection: SectionModelType {
    typealias Item = TipViewModel
    
    init(original: TipSection, items: [Item]) {
        self = original
        self.items = items
    }
}


struct TipViewModel {
    var title: String
    var subtitle: String
    var thumbImage: String
    var timestamp: String
}
