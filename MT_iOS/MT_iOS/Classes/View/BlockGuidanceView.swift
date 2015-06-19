//
//  BlockGuidanceView.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlockGuidanceView: UIView {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.baseView.layer.cornerRadius = 8.0
        self.baseView.clipsToBounds = true
        
        self.infoLabel.text = NSLocalizedString("Tap camera icon or text icon in the bottom left corner for make a content block.", comment: "Tap camera icon or text icon in the bottom left corner for make a content block.")
    }
    
    @IBAction func closeButtonPushed(sender: AnyObject) {
    }
}
