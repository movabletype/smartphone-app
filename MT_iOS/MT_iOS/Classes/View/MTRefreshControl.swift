//
//  MTRefreshControl.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/18.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class MTRefreshControl: UIRefreshControl {
    var tophImage = UIImageView(frame: CGRectMake(0.0, 0.0, 64.0, 40.0))
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init() {
        super.init()
        
        var images = [UIImage]()
        for (var i=1;i<5;i++) {
            let image = UIImage(named: "animation_\(i)")
            images.append(image!)
        }
        tophImage.animationImages = images
        tophImage.animationDuration = 0.5
        tophImage.animationRepeatCount = 0
        
        self.addSubview(tophImage)
        
        tophImage.center = center
        
        self.tintColor = UIColor.clearColor()
        self.backgroundColor = Color.white

        tophImage.startAnimating()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
