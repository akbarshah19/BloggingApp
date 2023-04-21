//
//  PayWallDescriptionView.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/21/23.
//

import UIKit

class PayWallDescriptionView: UIView {
    
    private let descriptorLabel: UILabel = {
        let label = UILabel()
        label.text = "Join BloggingApp Premium to read unlimited articles and browse thousands of posts!"
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$4.99 / month"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(priceLabel)
        addSubview(descriptorLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptorLabel.frame = CGRect(x: 20, y: 0, width: width - 40, height: height/2)
        priceLabel.frame = CGRect(x: 20, y: height/2, width: width - 40, height: height/2)
    }
}
