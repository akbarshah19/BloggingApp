//
//  PostHeaderTableViewCell.swift
//  BloggingApp
//
//  Created by Akbarshah Jumanazarov on 4/24/23.
//

import UIKit

class PostHeaderTableViewCellViewModel {
    let imageUrl: URL?
    var imageData: Data?
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "PostHeaderTableViewCell"

    private let postImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configure(with viewModel: PostHeaderTableViewCellViewModel) {
        if let data = viewModel .imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
