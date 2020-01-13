//
//  CustomButton.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled ? UIColor.systemBlue : UIColor.lightGray
        }
    }

}

//class CollectionButton: UIButton {
//    var isSe: Bool {
//        didSet {
//            self.set
//        }
//    }
//}
