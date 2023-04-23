//
//  ViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var user: User?
    let currentEmail: String
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
        fetchProfileData()
    }
    
    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/2))
        headerView.backgroundColor = .systemBlue
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(x: (headerView.width - (headerView.width/4))/2,
                                    y: (headerView.height - (headerView.width/4))/2.5,
                                    width: headerView.width/4,
                                    height: headerView.width/4)
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom + 10, width: headerView.width - 40, height: 30))
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 20, weight: .regular)
        headerView.addSubview(emailLabel)
        
        if let name = name {
            title = name
        }
        
        if let ref = profilePhotoRef {
            //Fetch photo
            StorageManager.shared.dowloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(profilePhotoRef: user.profilePictuerRef, name: user.name)
            }
        }
    }
    
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSignOut))
    }
    
    @objc func didTapProfilePhoto() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"), myEmail == currentEmail else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //TableView
    private var posts: [BlogPost] = []
    private func fetchPosts() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world!"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController()
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
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

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}
