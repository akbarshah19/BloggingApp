//
//  HapticsManager.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/28/23.
//

import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
