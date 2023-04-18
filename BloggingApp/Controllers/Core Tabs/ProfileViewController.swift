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
        
    }


}
