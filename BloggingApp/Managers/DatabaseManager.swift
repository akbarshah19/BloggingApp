//
//  DatabaseManager.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insert(with blogPost: BlogPost, email: String, comlpetion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String: Any] = [
            "id": blogPost.identifier,
            "title": blogPost.title,
            "body": blogPost.text,
            "date_created": blogPost.timeStamp,
            "header": blogPost.headerImageURL?.absoluteString ?? ""
        ]
        
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogPost.identifier)
            .setData(data) { error in
                comlpetion(error == nil)
            }
    }
    
    public func getAllPosts(comlpetion: @escaping ([BlogPost]) -> Void) {
        
    }
    
    public func getPosts(for email: String, comlpetion: @escaping ([BlogPost]) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({$0.data()}),
                      error == nil else {
                    return
                }
                
                let posts: [BlogPost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary ["created"] as? TimeInterval,
                          let imageUrlString = dictionary["headerImageUrl"] as? String else {
                              print("Invalid post fetch conversion.")
                              return nil
                    }
                    
                    let post = BlogPost(identifier: id,
                                        title: title,
                                        timeStamp: created,
                                        headerImageURL: URL(string: imageUrlString ),
                                        text: body
                    )
                    return post
                })
                comlpetion(posts)
            }
    }

    public func insert(user: User, comlpetion: @escaping (Bool) -> Void) {
        let documentID = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "name": user.name
        ]
        
        database
            .collection("users")
            .document(documentID)
            .setData(data) { error in
                comlpetion(error == nil)
            }
    }
    
    public func getUser(email: String, completion: @escaping (User?) -> Void) {
        let documentID = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(documentID)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String], error == nil,
                let name = data["name"]  else {
                    return
                }
                
                let ref = data["profile_photo"]
                let user = User(name: name, email: email, profilePictuerRef: ref)
                completion(user)
            }
    }
    
    public func updateProfilePhoto(email: String, completion: @escaping (Bool) -> Void) {
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        let photoRef = "profile_picture/\(path)/photo.png"
        let dbRef = database
            .collection("users")
            .document(path)
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            
            data["profile_photo"] = photoRef
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
}
