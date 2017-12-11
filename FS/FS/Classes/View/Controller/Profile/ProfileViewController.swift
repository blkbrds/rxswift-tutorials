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
import RxSwift
import SVProgressHUD

final class ProfileViewController: ViewController {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sexLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
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
        viewModel.isLogedIn
            .observeOn(MainScheduler.instance)
            .bind(to: loginView.rx.isHidden).disposed(by: disposeBag)
        viewModel.name.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.address.bind(to: addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.gender.bind(to: sexLabel.rx.text).disposed(by: disposeBag)
        viewModel.email.bind(to: emailLabel.rx.text).disposed(by: disposeBag)
        viewModel.avatarURL.bind(onNext: { [weak self] avatar in
            guard let this = self else { return }
            this.avatarImageView.sd_setImage(with: avatar)
        }).disposed(by: disposeBag)
        viewModel.error.subscribe(onNext: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
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
