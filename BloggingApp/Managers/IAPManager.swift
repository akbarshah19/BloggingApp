//
//  IAPManager.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import Foundation

final class IAPManager {
    static let shared = IAPManager()
    static let formatter = ISO8601DateFormatter()
    private var postEligibleViewDate: Date? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else {
                return nil
            }
            return IAPManager.formatter.date(from: string)
        }
        set {
            guard let date = newValue  else {
                return
            }
            let string = IAPManager.formatter.string(from: date)
            UserDefaults.standard.set(string, forKey: "postEligibleViewDate")
        }
    }
    
    private init() {}
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }
    
    func subscribe() {}
    func restorePurchases() {}
    
    var canViewPost: Bool {
//        if isPremium() {
//            return true
//        }
        
        guard let date = postEligibleViewDate else {
            return true
        }
        UserDefaults.standard.set(0, forKey: "post_views")
        return Date() >= date
    }
    
    public func logPostViewed() {
        let total = UserDefaults.standard.integer(forKey: "post_views")
        UserDefaults.standard.set(total + 1, forKey: "post_views")

        if total == 2 {
            let hour: TimeInterval = 60 * 60
            postEligibleViewDate = Date().addingTimeInterval(hour * 24)
        }
    }
}
