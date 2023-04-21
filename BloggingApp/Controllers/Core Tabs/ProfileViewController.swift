//
//  ViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSignOut))
    }
    
    @objc func didTapSignOut() {
        AuthManager.shared.signOut { [weak self] success in
            if success {
                let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
                    DispatchQueue.main.async {
                        let signUpVC = SignInViewController()
                        signUpVC.navigationItem.largeTitleDisplayMode = .always
                        let nav = UINavigationController(rootViewController: signUpVC)
                        nav.navigationBar.prefersLargeTitles = true
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true)
                    }
                }
                alert.addAction(cancel)
                alert.addAction(signOut)
                self?.present(alert, animated: true)
            }
        }
    }


}
