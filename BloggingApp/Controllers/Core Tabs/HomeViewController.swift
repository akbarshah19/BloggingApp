//
//  ViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return table
    }()
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)),
                                for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(x: view.width - 60 - 16, y: view.height - 60 - 16 - view.safeAreaInsets.bottom, width: 60, height: 60)
        tableView.frame = view.bounds
    }
    
    @objc func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    private var posts: [BlogPost] = []
    private func fetchAllPosts() {
        print("Fetching home feed...")
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier,
                                                       for: indexPath) as? PostPreviewTableViewCell else {
            fatalError("Error dequeueing cell.")
        }
        cell.configure(with: .init(title: post.text, imageUrl: post.headerImageURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

