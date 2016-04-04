//
//  EntryTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/22.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    private var _object: BaseEntry?
    var object: BaseEntry? {
        set {
            self._object = newValue
        
            if let item = self._object {
                self.titleLabel.text = item.title
                self.titleLabel.sizeToFit()
                
                _ = NSDateFormatter()
                
                if let date = item.date {
                    self.timeLabel.text = Utils.fullDateTimeFromDate(date)
                } else {
                    self.timeLabel.text = ""
                }
                
                self.statusIcon.hidden = false
                if item.status == Entry.Status.Publish.text() {
                    self.statusIcon.image = UIImage(named: "ico_on")
                } else if item.status == Entry.Status.Draft.text() {
                    self.statusIcon.image = UIImage(named: "ico_draft")
                } else if item.status == Entry.Status.Future.text() {
                    self.statusIcon.image = UIImage(named: "ico_timer")
                } else if item.status == Entry.Status.Unpublish.text() {
                    self.statusIcon.image = UIImage(named: "ico_unpublush")
                } else {
                    self.statusIcon.hidden = true
                }
            } else {
                self.titleLabel.text = ""
                self.timeLabel.text = ""
                
                self.statusIcon.hidden = true
            }
        }
        get {
            return self._object
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
