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
    
    public func insert(with blogPost: BlogPost, user: User, comlpetion: @escaping (Bool) -> Void) {
        
    }
    
    public func getAllPosts(comlpetion: @escaping ([BlogPost]) -> Void) {
        
    }
    
    public func getPosts(for user: User, comlpetion: @escaping ([BlogPost]) -> Void) {
        
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
}
