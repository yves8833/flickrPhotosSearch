//
//  FavoriteViewController.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let PhotoCollectionViewCellReuseIdentifier = "PhotoCollectionViewCell"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (view.frame.size.width / 2 - 15), height: (view.frame.size.width / 1.7))
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCellReuseIdentifier)
        view.addSubview(collectionView)
        
        return collectionView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "目前沒有收藏"
        
        self.view.addSubview(label)
        
        return label
    }()
    
    var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        layoutInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.isHidden = viewModel.photoIDs.count == 0
        errorLabel.isHidden = !(viewModel.photoIDs.count == 0)
        
        collectionView.reloadData()
    }
    
}

// MARK: Private Method
extension FavoriteViewController {
    func layoutInitialView() {
        
        self.view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCellReuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        guard
            let photo = viewModel.photos[viewModel.photoIDs[indexPath.row]] as? Dictionary<String, String>,
            let title = photo["title"],
            let imageUrl = photo["imageUrl"]
            else { return cell }
        
        cell.titleLabel.text = title
        self.viewModel.downloadImage(from: URL(string: imageUrl)!, completedHandler: { (image) in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async() {
                cell.imageView.image = image
            }
        })
        
        return cell
    }
    
}
