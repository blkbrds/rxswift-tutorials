//
//  VenueCell.swift
//  FS
//
//  Created by Linh Vo D. on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift

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
    var viewModel = VenueCellViewModel() {
        didSet {
            updateView()
        }
    }

    var bag = DisposeBag()

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        updateView()
        configUI()
    }

    // MARK: - Private
    private func configUI() {
        ratingLabel.layer.cornerRadius = 100
    }

    private func updateView() {
        viewModel.name.bind(to: nameLabel.rx.text).disposed(by: bag)
        viewModel.address.bind(to: addressLabel.rx.text).disposed(by: bag)
        viewModel.rating.bind(to: ratingLabel.rx.text).disposed(by: bag)
        viewModel.image.bind(to: thumbnailImageView.rx.image).disposed(by: bag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
