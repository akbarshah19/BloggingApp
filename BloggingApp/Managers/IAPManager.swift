//
//  IAPManager.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/17/23.
//

import Foundation

final class IAPManager {
    static let shared = IAPManager()
    private var postEligibleViewDate: Date?
    
    private init() {}
    
    func isPremium() -> Bool {
        return false
    }
    
    func subscribe() {}
    func restorePurchases() {}
    
    var canViewPost: Bool {
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
