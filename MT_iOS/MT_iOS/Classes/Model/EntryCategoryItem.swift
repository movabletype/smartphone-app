//
//  EntryCategoryItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryCategoryItem: BaseEntryItem {
    var selected = [Category]()
    
    override init() {
        super.init()
        
        type = "category"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.selected, forKey: "selected")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.selected = aDecoder.decodeObjectForKey("selected") as! [Category]
    }

    override func value()-> String {
        var array = [String]()
        for item in selected {
            array.append(item.label)
        }
        return array.joinWithSeparator(",")
    }
    
    override func dispValue()-> String {
        return self.value()
    }
    
    override func makeParams()-> [String : AnyObject] {
        var categories = [[String: String]]()
        for item in selected {
            categories.append(["id":item.id])
        }
        return ["categories":categories]
    }
    
    override func clear() {
        selected.removeAll(keepCapacity: false)
    }
}
