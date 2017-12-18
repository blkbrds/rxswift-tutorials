//
//  PagingHeaderViewModel.swift
//  FS
//
//  Created by Hoa Nguyen on 12/12/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift

final class PageViewModel {
    var imageUrls: Variable<[String]>?

    init(imageUrls: [String]) {
        self.imageUrls?.value = imageUrls
    }
}
