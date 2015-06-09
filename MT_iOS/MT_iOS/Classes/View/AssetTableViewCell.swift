//
//  AssetTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class AssetTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var labelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var _asset: Asset?
    var asset: Asset? {
        set {
            self._asset = newValue
            
            if let item = self._asset {
                self.labelLabel.text = item.dispName()
                self.thumbImageView.sd_setImageWithURL(NSURL(string: item.url))
            } else {
                self.labelLabel.text = ""
                self.thumbImageView.image = nil
            }
        }
        get {
            return self._asset
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

