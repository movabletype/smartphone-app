//
//  UIBarButtonItemExtention.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/03.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func imageInsetsLeft() {
        self.imageInsets = UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0);
    }

    func imageInsetsRight() {
        self.imageInsets = UIEdgeInsetsMake(0.0, -10.0, 0.0, 10.0);
    }

    convenience init(image: UIImage?, left: Bool, target: AnyObject?, action: Selector) {
        self.init(image: image, style: UIBarButtonItemStyle.Plain, target: target, action: action)
        left ? imageInsetsLeft() : imageInsetsRight()
    }
}
