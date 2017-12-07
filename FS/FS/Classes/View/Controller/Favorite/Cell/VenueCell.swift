//
//  VenueCell.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/4/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

final class VenueCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    static let height: CGFloat = 187

    var viewModel = VenueCellViewModel() {
        didSet {
            updateView()
        }
    }

    // MARK: - Life circle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
        configUI()
    }

    // MARK: - Public method
    private func configUI() {
        containerView.corner = 10
        containerView.border(color: .black, width: 1)
        containerView.shadow(color: .black, offset: .zero, opacity: 1.0, radius: 3.0)
    }

    private func updateView() {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        ratingLabel.text = viewModel.rating
    }
}
