//
//  FlickrPhotosSearchResultViewController.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class PhotosSearchViewController: UIViewController {
    
    let PhotosSearchCollectionViewCellReuseIdentifier = "PhotosSearchCollectionViewCell"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (view.frame.size.width / 2 - 15), height: (view.frame.size.width / 1.7))
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosSearchCollectionViewCell.self, forCellWithReuseIdentifier: PhotosSearchCollectionViewCellReuseIdentifier)
        view.addSubview(collectionView)
        
        return collectionView
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return activityIndicatorView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
           
        ])
        
        return label
    }()
    
    lazy var viewModel: PhotosSearchViewModel = {
        let viewModel = PhotosSearchViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
    
    var currentPhotos: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.searchFlickrPhotos(With: searchName, photosNumber: photosNumber)
        layoutInitialView()
    }
    
    var searchName: String!
    var photosNumber: String!
    
    convenience init(With searchName: String, photosNumber: String) {
        self.init()
        self.searchName = searchName
        self.photosNumber = photosNumber
    }
    
}

// MARK: Private Method
extension PhotosSearchViewController {
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

// MARK: FlickrPhotosSearchDelegate
extension PhotosSearchViewController: FlickrPhotosSearchDelegate {
    func update(With status: FlickrPhotosSearchStatus) {
        switch status {
        case .loading:
            loadingIndicatorView.startAnimating()
            errorLabel.isHidden = true
            collectionView.isHidden = true
            break
        case .success:
            loadingIndicatorView.stopAnimating()
            collectionView.reloadData()
            collectionView.isHidden = false
            errorLabel.isHidden = true
            break
        case .loadMoreSuccess:
            guard let photosCount = viewModel.photos?.count else { break }
            let indexPaths = Array(self.currentPhotos...photosCount - 1).map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: indexPaths)
            break
        case .failure:
            loadingIndicatorView.stopAnimating()
            errorLabel.text = "目前無資料"
            errorLabel.isHidden = false
            collectionView.isHidden = true
            break
        case .loadMoreFailure:
            let alert = UIAlertController.init(title: "Alert", message: "加載失敗", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension PhotosSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosSearchCollectionViewCellReuseIdentifier, for: indexPath) as! PhotosSearchCollectionViewCell
        guard let photos = viewModel.photos else { return cell }
        
        if let photoIDs = UserDefaults.standard.array(forKey: "photoIDs") {
            cell.collectionButton.isSelected = photoIDs.contains { (id) -> Bool in
                return photos[indexPath.row].id == id as! String
            }
        }
        
        let collectionPhoto = ["title": photos[indexPath.row].title, "imageUrl": photos[indexPath.row].url]
    
        cell.selectAction = {
            if var collectionPhotos = UserDefaults.standard.dictionary(forKey: "photo"), var photoIDs = UserDefaults.standard.array(forKey: "photoIDs") {
                photoIDs.append(photos[indexPath.row].id)
                collectionPhotos[photos[indexPath.row].id] = collectionPhoto
                
                UserDefaults.standard.set(photoIDs, forKey: "photoIDs")
                UserDefaults.standard.set(collectionPhotos, forKey: "photo")
            } else {
                UserDefaults.standard.set([photos[indexPath.row].id], forKey: "photoIDs")
                let collectionPhotos = [photos[indexPath.row].id: collectionPhoto]
                UserDefaults.standard.set(collectionPhotos, forKey: "photo")
            }
        }
        
        cell.rejectAction = {
            if var collectionPhotos = UserDefaults.standard.dictionary(forKey: "photo"), var photoIDs = UserDefaults.standard.array(forKey: "photoIDs") {
                collectionPhotos.removeValue(forKey: photos[indexPath.row].id)
                photoIDs = photoIDs.filter { (id) -> Bool in
                    return photos[indexPath.row].id != id as! String
                }
                UserDefaults.standard.set(photoIDs, forKey: "photoIDs")
                UserDefaults.standard.set(collectionPhotos, forKey: "photo")
            }
        }
        
        cell.titleLabel.text = photos[indexPath.row].title
        self.viewModel.downloadImage(from: URL(string: photos[indexPath.row].url)!, completedHandler: { (image) in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async() {
                cell.imageView.image = image
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photosCount = viewModel.photos?.count, indexPath.row == photosCount - 1, viewModel.status != .loadMoreLoading {
            self.currentPhotos = photosCount
            viewModel.loadMoreIfNeeded()
        }
    }
    
}
