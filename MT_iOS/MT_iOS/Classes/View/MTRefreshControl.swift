//
//  MTRefreshControl.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/18.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class MTRefreshControl: UIRefreshControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init() {
        super.init()
        
        let gearImage = UIImageView(image: UIImage(named: "mt_gear"))
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = (M_PI / 180) * 360
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = Float.infinity
        gearImage.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")
        self.addSubview(gearImage)
        
        gearImage.center = center
        
        self.tintColor = UIColor.clearColor()
        self.backgroundColor = Color.navBar
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
}
