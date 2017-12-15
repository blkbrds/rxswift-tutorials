//
//  SearchCell.swift
//  FS
//
//  Created by Mylo Ho on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift

final class SearchCell: UITableViewCell {
    private(set) var bag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
