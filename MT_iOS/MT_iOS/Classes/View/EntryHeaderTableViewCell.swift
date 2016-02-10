//
//  EntryHeaderTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/04.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryHeaderTableViewCell: UITableViewCell {
    let requireIcon = UIImageView(image: UIImage(named: "ico_require"))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.addSubview(requireIcon)
        require = false
    }
    
    var _require: Bool = false
    var require: Bool {
        set {
            _require = newValue
            requireIcon.hidden = !_require
        }
        get {
            return _require
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.sizeToFit()
        var rect = textLabel!.frame
        rect.size.height = self.contentView.frame.height
        textLabel!.frame = rect
        
        rect = requireIcon.frame
        rect.origin.x = self.textLabel!.frame.origin.x + self.textLabel!.frame.width + 8.0
        rect.origin.y = 8.0
        requireIcon.frame = rect
    }
    
}
