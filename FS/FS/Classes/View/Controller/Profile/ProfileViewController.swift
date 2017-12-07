//
//  ProfileViewController.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import SwiftUtils
import SDWebImage

final class ProfileViewController: ViewController {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sexLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var logoutButton: UIButton!

    var viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        avatarImageView.corner = avatarImageView.bounds.height / 2
        logoutButton.corner = logoutButton.bounds.height / 2
        loginButton.corner = loginButton.bounds.height / 2
        viewModel.isLogedIn.bind(to: loginView.rx.isHidden).disposed(by: disposeBag)
        viewModel.userObservable.subscribe(onNext: { [weak self] user in
            guard let this = self else { return }
            this.nameLabel.text = user.name
            this.sexLabel.text = user.gender
            this.emailLabel.text = user.email
            this.addressLabel.text = user.address
            this.avatarImageView.sd_setImage(with: user.avatar)
        }).disposed(by: disposeBag)
    }

    // MARK: Action
    @IBAction private func loginButtonTouchedUpInside(_ sender: Any) {
        API.User.login()
    }

    @IBAction func logoutButtonTouchedUpInside(_ sender: UIButton) {
        Helper.accessCode = ""
        Helper.accessToken = ""
        Helper.isLogedIn = false
    }
}
