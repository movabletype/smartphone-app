//
//  EntryItemTableViewCell.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var visibleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var _item: BaseEntryItem?
    var item: BaseEntryItem? {
        set {
            self._item = newValue
            if self._item != nil {
                self.titleLabel.text = self._item!.label
                self.buttonImage(self._item!.visibled)
            } else {
                self.titleLabel.text = ""
                self.buttonImage(false)
            }
        }
        get {
            return self._item
        }
    }
    
    func buttonImage(visibled: Bool) {
        if visibled {
            self.visibleButton.setImage(UIImage(named: "btn_checked"), forState: UIControlState.Normal)
        } else {
            self.visibleButton.setImage(UIImage(named: "btn_unchecked"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func visibleButtonPushed(sender: AnyObject) {
        if let entryItem = self._item {
            entryItem.visibled = !entryItem.visibled
            if !entryItem.isCustomField {
                if entryItem.id == "status" ||
                    entryItem.id == "title" ||
                    entryItem.id == "basename" ||
                    entryItem.id == "body" {
                    entryItem.visibled = true
                }
            } else {
                if entryItem.required {
                    entryItem.visibled = true
                }
            }
            self.buttonImage(self._item!.visibled)
        }
    }
}
