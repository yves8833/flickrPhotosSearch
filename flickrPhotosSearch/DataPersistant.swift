//
//  DataPersistant.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/13.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import Foundation

let PhotoKey = "Photo"
let PhotoIDsKey = "PhotoIDs"

class DataPersistant {
    
    static func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    static func addPhoto(With id: String, photo: Dictionary<String, String>) {
        var photos = self.photos()
        photos[id] = photo
        self.userDefaults().set(photos, forKey: PhotoKey)
        self.userDefaults().synchronize()
    }
    
    static func removePhoto(With id: String) {
        var photos = self.photos()
        photos.removeValue(forKey: id)
        self.userDefaults().set(photos, forKey: PhotoKey)
        self.userDefaults().synchronize()
    }
    
    static func photos() -> Dictionary<String, Any> {
        return self.userDefaults().dictionary(forKey: PhotoKey) ?? Dictionary<String, Any>()
    }
    
    static func addPhotoId(With photoID: String) {
        var photoIDs = self.photoIDs()
        guard !photoIDs.contains(photoID) else {
            return
        }
        photoIDs.append(photoID)
        self.userDefaults().set(photoIDs, forKey: PhotoIDsKey)
        self.userDefaults().synchronize()
    }
    
    static func removePhotoId(With photoID: String) {
        var photoIDs = self.photoIDs()
        if let index = photoIDs.firstIndex(where: { photoID == $0 }) {
            photoIDs.remove(at: index)
            self.userDefaults().set(photoIDs, forKey: PhotoIDsKey)
            self.userDefaults().synchronize()
        }
    }
    
    static func photoIDs() -> [String] {
        return (self.userDefaults().array(forKey: PhotoIDsKey) as? [String]) ?? [String]()
    }
}
