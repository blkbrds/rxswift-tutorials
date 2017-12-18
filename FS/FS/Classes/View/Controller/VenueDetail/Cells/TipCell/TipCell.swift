//
//  TipCell.swift
//  FS
//
//  Created by Hoa Nguyen on 12/12/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit

final class TipCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!

    var viewModel: TipViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            subtitleLabel.text = viewModel?.subtitle
            createdAtLabel.text = viewModel?.timestamp
            thumbImageView.image = nil
        }
    }
}
