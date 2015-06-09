//
//  BlogInfoView.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/21.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlogInfoView: UIView {

    @IBOutlet weak var BlogNameLabel: UILabel!
    @IBOutlet weak var BlogPrefsButton: UIButton!
    @IBOutlet weak var BlogURLButton: UIButton!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var _blog: Blog?
    var blog: Blog? {
        set {
            self._blog = newValue
            
            if let blog = self._blog {
                BlogNameLabel.text = blog.name
                BlogURLButton.setTitle(blog.url, forState: UIControlState.Normal)
            } else {
                BlogNameLabel.text = ""
                BlogURLButton.setTitle("", forState: UIControlState.Normal)
            }
        }
        get {
            return self._blog
        }
    }
    
    @IBAction func BlogPrefsButtonPushed(sender: AnyObject) {
    }
    
    @IBAction func BlogURLButtonPushed(sender: AnyObject) {
    }
}
