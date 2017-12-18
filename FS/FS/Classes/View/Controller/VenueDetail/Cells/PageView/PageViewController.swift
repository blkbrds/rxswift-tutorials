//
//  PagingHeaderCell.swift
//  FS
//
//  Created by Hoa Nguyen on 12/12/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PageViewController: UIPageViewController {
    var viewModel: PageViewModel?
    var disposeBag = DisposeBag()

    convenience init(viewModel: PageViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}

