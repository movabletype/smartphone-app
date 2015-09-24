//
//  EntryTimeItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryTimeItem: BaseEntryItem {
    var time: NSDate?
    
    override init() {
        super.init()
        
        type = "time"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.time, forKey: "time")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.time = aDecoder.decodeObjectForKey("time") as? NSDate
    }
    
    override func value()-> String {
        if let date = self.time {
            return Utils.dateTimeTextFromDate(date)
        }
        
        return ""
    }
    
    override func dispValue()-> String {
        if let date = self.time {
            return Utils.timeStringFromDate(date)
        }
        
        return ""
    }
    
    override func makeParams()-> [String : AnyObject] {
        if let _ = self.time {
            return [self.id:self.value()]
        }
        return [self.id:""]
    }
    
    override func clear() {
        time = nil
    }
}
