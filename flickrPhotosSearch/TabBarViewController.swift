//
//  TabBarViewController.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var searchName: String!
    var photosNumber: String!
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.navigationItem.title = item.tag == 0 ? "搜尋結果 " + searchName : "我的最愛"
    }
    
    convenience init(With searchName: String) {
        self.init()
        self.searchName = searchName
        self.navigationItem.title = "搜尋結果 " + searchName
    }
}
