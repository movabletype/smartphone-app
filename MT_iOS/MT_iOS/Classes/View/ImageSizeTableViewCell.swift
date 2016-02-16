//
//  ImageSizeTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/15.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class ImageSizeTableViewCell: UITableViewCell {
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
