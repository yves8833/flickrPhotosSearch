//
//  FavoriteViewModel.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/13.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class FavoriteViewModel: NSObject {
    
    var photos: Dictionary<String, Any>? {
        guard let photos = UserDefaults.standard.dictionary(forKey: "photo") else { return nil }
        return photos
    }
    
    var photoIDs: [String]? {
        guard let photoIDs = UserDefaults.standard.array(forKey: "photoIDs") as? [String] else { return nil }
        return photoIDs
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
    
}
