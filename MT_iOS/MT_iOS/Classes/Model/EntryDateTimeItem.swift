//
//  EntryDateTimeItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryDateTimeItem: BaseEntryItem {
    var datetime: NSDate?
    
    override init() {
        super.init()
        
        type = "datetime"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.datetime, forKey: "datetime")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.datetime = aDecoder.decodeObjectForKey("datetime") as? NSDate
    }

    override func value()-> String {
        if let date = self.datetime {
            return Utils.dateTimeTextFromDate(date)
        }
        
        return ""
    }
    
    override func dispValue()-> String {
        if let date = self.datetime {
            return Utils.dateTimeFromDate(date)
        }
        
        return ""
    }
    
    override func makeParams()-> [String : AnyObject] {
        if let dt = self.datetime {
            return [self.id:self.value()]
        }
        return [self.id:""]
    }
    
    override func clear() {
        datetime = nil
    }

}
