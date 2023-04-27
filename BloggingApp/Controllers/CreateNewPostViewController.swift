//
//  CreateNewPostViewController.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import UIKit

class CreateNewPostViewController: UIViewController {
    
    private var selectedHeaderImage: UIImage?
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter title"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let headerImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.image = UIImage(systemName: "photo")
        image.backgroundColor = .tertiarySystemBackground
        return image
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 18)
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureButtons()
        view.addSubview(titleField)
        view.addSubview(headerImageView)
        view.addSubview(textView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width - 20, height: 50)
        headerImageView.frame = CGRect(x: 0, y: titleField.bottom + 5, width: view.width, height: 100)
        textView.frame = CGRect(x: 10,
                                y: headerImageView.bottom + 5,
                                width: view.width - 20,
                                height: view.height - 100 - 50 - view.safeAreaInsets.top)
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapPost() {
        guard let title = titleField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty,
              let body = textView.text, !body.trimmingCharacters(in: .whitespaces).isEmpty,
              let email = UserDefaults.standard.string(forKey: "email"),
              let headerImage = selectedHeaderImage else {
            
            let alert = UIAlertController(title: "Sorry", message: "To post an article fill all the fileds.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let newPostID = UUID().uuidString
        StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postID: newPostID) { success in
            guard success else {
                return
            }
            
            StorageManager.shared.downloadUrlForPostHeader(email: email, postID: newPostID) { url in
                guard let headerURL = url else {
                    print("Failed to upload url for header.")
                    return
                }
                let post = BlogPost(identifier: newPostID,
                                    title: title,
                                    timeStamp: Date().timeIntervalSince1970,
                                    headerImageURL: headerURL,
                                    text: body
                )
                DatabaseManager.shared.insert(with: post, email: email) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                            print("Failed to post new blog aritcle.")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.didTapCancel()
                    }
                }
            }
        }
    }
    
    @objc func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapPost)
        )
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        selectedHeaderImage = image
        headerImageView.image = image
         
    }
}
