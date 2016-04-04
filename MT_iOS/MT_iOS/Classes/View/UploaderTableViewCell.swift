//
//  UploaderTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/09.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class UploaderTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var checkMark: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progress = 0.0
        self.checkMark.alpha = 0.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var progress: Float {
        get {
            return progressView.progress
        }
        set {
            progressView.progress = newValue
        }
    }

    var uploaded: Bool {
        get {
            return self.checkMark.alpha == 1.0
        }
        set {
            self.checkMark.alpha = newValue ? 1.0 : 0.0
        }
    }
}
