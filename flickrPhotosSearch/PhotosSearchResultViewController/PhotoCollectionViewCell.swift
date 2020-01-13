//
//  PhotosSearchCollectionViewCell.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/12.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PhotosSearchCollectionViewCell: PhotoCollectionViewCell {
    lazy var collectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(systemName: "heart"), for: .normal)
        button.setImage(UIImage.init(systemName: "heart.fill"), for: .selected)
        
        button.addTarget(self, action: #selector(clickAction) , for: .touchUpInside)
        
        return button
    }()
    
    var selectAction: (() -> Void)?
    var rejectAction: (() -> Void)?
    
    @objc func clickAction() {
        guard let selectAction = selectAction, let rejectAction = rejectAction else {
            return
        }
        collectionButton.isSelected = !collectionButton.isSelected
        collectionButton.isSelected ? selectAction() : rejectAction()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(collectionButton)
        
        NSLayoutConstraint.activate([
            collectionButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            collectionButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            collectionButton.heightAnchor.constraint(equalToConstant: 20),
            collectionButton.widthAnchor.constraint(equalTo: collectionButton.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
