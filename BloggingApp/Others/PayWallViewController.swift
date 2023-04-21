//
//  PayWallViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/20/23.
//

import UIKit

class PayWallViewController: UIViewController {
    
    private let headerView = PayWallHeaderView()
    private let heroView = PayWallDescriptionView()
    
    private let buyButton: UIButton =  {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let restoreButton: UIButton =  {
        let button = UIButton()
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let termsView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textColor = .secondaryLabel
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.text = "This is auto-renewable subscription. It will be charged to your iTunes account before each pay period. You can cancel this anytime by going into your Settings>Subscriptions. Restore purchases if previously subscribed."
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BloggingApp Premium"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(termsView)
        view.addSubview(heroView)
        view.addSubview(buyButton)
        view.addSubview(restoreButton)
        setUpCloseButton()
        setUpButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/3.2)
        termsView.frame = CGRect(x: 10, y: view.height - 130, width: view.width - 20, height: 100)
        restoreButton.frame = CGRect(x: 25, y: termsView.top - 60, width: view.width - 50, height: 50)
        buyButton.frame = CGRect(x: 25, y: restoreButton.top - 50, width: view.width - 50, height: 50)
        heroView.frame = CGRect(x: 0,
                                y: headerView.bottom,
                                width: view.width,
                                height: buyButton.top - view.safeAreaInsets.top - headerView.height)
    }
    
    private func setUpButtons() {
        buyButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
    }
    
    @objc func didTapSubscribe() {
        let alert = UIAlertController(title: "An Error Occured!", message: "Something went wrong, try again later.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc func didTapRestore() {
        let alert = UIAlertController(title: "An Error Occured!", message: "Something went wrong, try again later.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(didTapClose)
        )
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
}
