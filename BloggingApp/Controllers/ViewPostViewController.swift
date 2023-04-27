//
//  PostViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import UIKit

class ViewPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var post: BlogPost
    private var isOwnedBuCurrentUser: Bool
    
    init(post: BlogPost, isOwnedBuCurrentUser: Bool = false) {
        self.post = post
        self.isOwnedBuCurrentUser = isOwnedBuCurrentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        if !isOwnedBuCurrentUser {
            IAPManager.shared.logPostViewed()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier,
                                                           for: indexPath) as?  PostHeaderTableViewCell else {
                fatalError()
            }
            cell.configure(with: .init(imageUrl: post.headerImageURL))
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.text
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        switch index {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension //150
        case 2:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}
