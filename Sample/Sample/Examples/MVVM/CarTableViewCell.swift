//
//  CarTableViewCell.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import MVVM

final class CarTableViewCell: UITableViewCell, MVVM.View {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var viewModel: CarViewModel? {
        didSet {
            updateView()
        }
    }

    func updateView() {
        guard let viewModel = viewModel else { return }

        viewModel.titleText
            .bind(to: titleLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.horsepowerText
            .bind(to: powerLabel.rx.text)
            .addDisposableTo(disposeBag)

        guard let url = viewModel.photoURL else { return }
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .subscribe(onNext: { [weak self] (data) in
                guard let this = self else { return }
                DispatchQueue.main.async {
                    this.photoImageView.image = UIImage(data: data)
                }
            })
            .addDisposableTo(disposeBag)
    }
}
