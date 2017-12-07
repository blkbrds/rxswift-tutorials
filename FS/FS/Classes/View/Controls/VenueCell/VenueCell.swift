//
//  VenueCell.swift
//  FS
//
//  Created by Linh Vo D. on 12/7/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift
import SwiftUtils

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
    var viewModel = VenueCellViewModel() {
        didSet {
            updateView()
        }
    }

    let disposeBag = DisposeBag()

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
        configUI()
    }

    // MARK: - Private
    private func configUI() {
        containerView.corner = 10
        containerView.border(color: .black, width: 1)
        containerView.shadow(color: .black, offset: .zero, opacity: 1.0, radius: 3.0)
        ratingLabel.corner = 10
    }

    private func updateView() {
        viewModel.name.bind(to: nameLabel.rx.text).addDisposableTo(disposeBag)
        viewModel.address.bind(to: addressLabel.rx.text).addDisposableTo(disposeBag)
        viewModel.rating.bind(to: ratingLabel.rx.text).addDisposableTo(disposeBag)

        guard let url = viewModel.photoURL else { return }
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .subscribe(onNext: { [weak self] (data) in
                guard let this = self else { return }
                DispatchQueue.main.async {
                    this.thumbnailImageView.image = UIImage(data: data)
                }
            })
            .addDisposableTo(disposeBag)
    }
}
