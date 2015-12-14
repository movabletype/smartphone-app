//
//  EntrySegmentedItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryStatusItem: BaseEntryItem {
    var selected = NOTSELECTED

    override init() {
        super.init()
        
        type = "status"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(self.selected, forKey: "selected")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.selected = aDecoder.decodeIntegerForKey("selected")
    }


    override func value()-> String {
        if selected == NOTSELECTED {
            return ""
        }
        return Entry.Status(rawValue: selected)!.text()
    }
    
    override func dispValue()-> String {
        return self.value()
    }
    
    override func makeParams()-> [String : AnyObject] {
        var status = self.value()
        if status.isEmpty {
            status = Entry.Status.Draft.text()
        }
        return [self.id:self.value()]
    }
    
    override func clear() {
        selected = NOTSELECTED
    }
}
