//
//  EntryTextItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryTextItem: BaseEntryItem {
    var text = ""
    
    override init() {
        super.init()
        
        type = "text"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.text, forKey: "text")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.text = aDecoder.decodeObjectForKey("text") as! String
    }
    
    override func value()-> String {
        return text
    }
    
    override func dispValue()-> String {
        return self.value()
    }

    func placeholder()-> String {
        return String(format: NSLocalizedString("Input %@...", comment: "Input %@..."), arguments: [self.label])
    }
    
    override func clear() {
        text = ""
    }
}
