//
//  LoginViewController.swift
//  RxSwift-Demo
//
//  Created by HaiPNT on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVM

class LoginViewController: BaseViewController, MVVM.View {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var validationNameLabel: UILabel!
    @IBOutlet private weak var validationPasswordLabel: UILabel!
    @IBOutlet private weak var showPasswordSwitch: UISwitch!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Title
        title = "Login"
        validationNameLabel.text = "Username has to be at least \(Validation.minimumUserNameLength) characters"
        validationPasswordLabel.text = "Password has to be at least \(Validation.minimumPasswordLength) characters"
    }

    func updateView() {
        setupModelView()
        setupObservable()
    }

    private func setupObservable() {
        viewModel.validatedUserName
            .bind(to: validationNameLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.validatedUserName
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.validatedPassword
            .bind(to: validationPasswordLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.loginEnabled
            .bind { [weak self] valid in
                guard let this = self else { return }
                this.loginButton.isEnabled = valid
                this.loginButton.alpha = valid ? 1 : 0.5
            }
            .disposed(by: disposeBag)

        showPasswordSwitch.rx.isOn
            .subscribe(onNext: { [weak self] (isOn) in
                guard let this = self else { return }
                this.passwordTextField.isSecureTextEntry = !isOn
            })
            .disposed(by: disposeBag)

        viewModel.loginObservable
            .bind { [weak self] user, error in
                // TODO: - add logic for login
                guard let this = self else { return }
                if let error = error {
                    this.showAlert(message: error.localizedDescription)
                } else {
                    // call login
                    this.showAlert(message: user.name)
                }
            }
            .disposed(by: disposeBag)
    }

    private func setupModelView() {
        viewModel = LoginViewModel(input: (userName: usernameTextField.rx.text.orEmpty,
                                           pw: passwordTextField.rx.text.orEmpty,
                                           loginTap: loginButton.rx.tap.asObservable()))
    }
}
