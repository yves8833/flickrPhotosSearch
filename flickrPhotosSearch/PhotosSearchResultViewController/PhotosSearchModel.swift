//
//  Model.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class PhotosSearchModel: Decodable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photos: [PhotoModel]
    var state: String
    
    enum CodingKeys: String, CodingKey {
        case photos
        case state = "stat"
    }
    
    enum DataKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photos = "photo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        state = try container.decode(String.self, forKey: .state)
        
        let result = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .photos)

        page = try result.decode(Int.self, forKey: .page)
        pages = try result.decode(Int.self, forKey: .pages)
        perpage = try result.decode(Int.self, forKey: .perpage)
        total = try result.decode(String.self, forKey: .total)
        photos = try result.decode([PhotoModel].self, forKey: .photos)
    }
}

class PhotoModel: Decodable {
    var title: String
    var url: String
    var id: String
    
    enum CodingKeys: CodingKey {
        case title
        case id
        case secret
        case server
        case farm
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        id = try container.decode(String.self, forKey: .id)
        
        let secret: String = try container.decode(String.self, forKey: .secret)
        let server: String = try container.decode(String.self, forKey: .server)
        let farm: Int = try container.decode(Int.self, forKey: .farm)
        
        url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
}
