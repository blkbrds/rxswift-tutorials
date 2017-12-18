//
//  InformationCell.swift
//  FS
//
//  Created by Hoa Nguyen on 12/12/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift

final class InformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!

    var viewModel: InformationViewModel? {
        didSet {
            self.titleLabel.text = viewModel?.title
            self.contentLabel.text = viewModel?.content
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
