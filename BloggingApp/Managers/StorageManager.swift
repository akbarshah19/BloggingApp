//
//  StorageManager.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        guard let pngData = image?.pngData() else {
            return
        }
        container.reference(withPath: "profile_picture/\(path)/photo.png").putData(pngData) { metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    public func dowloadUrlForProfilePicture(path: String, completion: @escaping (URL?) -> Void) {
        container.reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func uploadBlogHeaderImage(blogPost: BlogPost, image: UIImage?, completion: @escaping (URL?) -> Void) {
        
    }
    
    public func downloadUrlForPostHeader(blogPost: BlogPost, completion: @escaping (URL?) -> Void) {
        
    }
}
