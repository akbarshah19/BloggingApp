//
//  SignUpViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let headerView = SignInHeaderView()
    
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        textField.autocapitalizationType = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()

    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 20, width: view.width, height: view.height/5)
        nameField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom + 10, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom + 10, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignUp() {
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            return
        }
        
        AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
            if success {
                let newUser = User(name: name, email: email, profilePictuerURL: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                print("Failed to create account.")
            }
        }
    }
}
