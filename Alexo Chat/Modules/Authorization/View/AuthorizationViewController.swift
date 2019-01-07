//
//  AuthorizationViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 07/01/2019.
//  Copyright © 2019 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit
import KRProgressHUD

class AuthorizationViewController: BaseViewController {

    var presenter: AuthorizationPresenterProtocol!

    private var loginTextField: UITextField = UITextField()
    private var passwordTextField: UITextField = UITextField()

    private var submit_Button: UIButton = IKUIBuilder.make.roundButtonWith(title: "Login", mainColor: UIColor.appMainColor())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()

    }

    private func createUI() {

        self.loginTextField.text = "test@test.com"
        self.passwordTextField.text = "password"
        
        loginTextField.placeholder = "Email"
        loginTextField.layer.borderWidth = 1.0
        loginTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        loginTextField.layer.cornerRadius = loginTextField.layer.frame.height / 4

        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        passwordTextField.layer.cornerRadius = passwordTextField.layer.frame.height / 4

        
        self.submit_Button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        
        let container = IKUIBuilder.make.stackView(orientation: .vertical, distribution: .equalSpacing, spacing: 8)

        self.view.addSubview(container)

        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-64)
        }

        container.addArrangedSubview(loginTextField)
        container.addArrangedSubview(passwordTextField)
        container.addArrangedSubview(submit_Button)

    }
}

// MARK: - Private
extension AuthorizationViewController {
    @objc func tapButton(_ sender: UIButton) {
        guard let login = loginTextField.text, !login.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        self.presenter.registerUser(email: login, password: password, nickname: login)
    }
}

extension AuthorizationViewController: AuthorizationViewProtocol {
    func showLoader() {
        self.showLoading(message: "Authorization...")
    }
    
    func hideLoader() {
        self.hideLoading()
    }
}
