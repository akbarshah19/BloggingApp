//
//  SignInHeaderView.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/21/23.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "lamp.desk")
        imageview.contentMode = .scaleAspectFit
        imageview.tintColor = .white
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = 10
        imageview.backgroundColor = .systemPink
        return imageview
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Explore millions of articles!"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = width/4
        imageView.frame = CGRect(x: CGFloat((width - size)/2), y: 10, width: size, height: size)
        label.frame = CGRect(x: 20, y: imageView.bottom + 10, width: width - 40, height: height - size - 30)
    }
}
