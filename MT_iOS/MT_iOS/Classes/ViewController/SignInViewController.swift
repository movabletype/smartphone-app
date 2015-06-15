//
//  SignInViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/29.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet weak var gearImage: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame = self.view.bounds
        let startColor = Color.loginBgStart.CGColor
        let endColor = Color.loginBgEnd.CGColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = (M_PI / 180) * 360
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = Float.infinity
        self.gearImage.layer.addAnimation(rotationAnimation, forKey: "rotateAnimation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
