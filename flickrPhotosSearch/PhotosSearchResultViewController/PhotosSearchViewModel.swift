//
//  ViewModel.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

enum FlickrPhotosSearchStatus {
    case none
    case loading
    case success
    case failure
    case loadMoreLoading
    case loadMoreSuccess
    case loadMoreFailure
}

protocol FlickrPhotosSearchDelegate {
    func update(With status: FlickrPhotosSearchStatus)
}

class PhotosSearchViewModel: NSObject {
    
    private let APIKey = "cff05f1c0192d522625344f8b9bec113"
    private let flickrUrl = "https://api.flickr.com/services/rest/"
    
    var delegate: FlickrPhotosSearchDelegate?
    var status: FlickrPhotosSearchStatus = .none {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.update(With: self.status)
            }
        }
    }
    
    var model: PhotosSearchModel?
    var photos: [PhotoModel]?
    var searchName: String?
    var photosNumber: String?
    
    private func url(With methodName: String, parameters: Dictionary<String, String>) -> URL? {
        
        var queryItems: [URLQueryItem] = parameters.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        queryItems.append(URLQueryItem(name: "api_key", value: APIKey))
        queryItems.append(URLQueryItem(name: "method", value: methodName))
        queryItems.append(URLQueryItem(name: "format", value: "json"))
        queryItems.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        var urlComponents = URLComponents(string: flickrUrl)!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    func searchFlickrPhotos(With searchName: String, photosNumber: String) {
        self.searchName = searchName
        self.photosNumber = photosNumber
        status = .loading
        let parameters = ["text": searchName, "per_page": photosNumber]
        guard let url = url(With: "flickr.photos.search", parameters: parameters) else {
            self.status = .failure
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, let model = try? JSONDecoder().decode(PhotosSearchModel.self, from: data) else {
                self.status = .failure
                return
            }
            
            self.model = model
            self.photos = model.photos
            self.status = .success
        }
        
        task.resume()
    }
    
    func downloadImage(from url: URL,  completedHandler:(@escaping (_ image: UIImage?) -> Void)) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completedHandler(nil)
                return
            }
            completedHandler(image)
        }
        task.resume()
    }
    
    func loadMoreIfNeeded() {
        guard
            let model = model,
            model.page < model.pages,
            let searchName = self.searchName,
            let photosNumber = self.photosNumber
            else { return }
        self.status = .loadMoreLoading
        let parameters = ["text": searchName, "per_page": photosNumber, "page": String(model.page + 1)]
        guard let url = url(With: "flickr.photos.search", parameters: parameters) else {
            self.status = .loadMoreFailure
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let model = try? JSONDecoder().decode(PhotosSearchModel.self, from: data) else {
                self.status = .loadMoreFailure
                return
            }
            self.model = model
            self.photos?.append(contentsOf: model.photos)
            self.status = .loadMoreSuccess
        }
        
        task.resume()
    }
    
}


