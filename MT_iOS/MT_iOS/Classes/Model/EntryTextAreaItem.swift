//
//  EntryTextAreaItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryTextAreaItem: BaseEntryItem {
    var text = ""
    var assets = [Asset]()

    override init() {
        super.init()
        
        type = "textarea"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.text, forKey: "text")
        aCoder.encodeObject(self.assets, forKey: "assets")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.text = aDecoder.decodeObjectForKey("text") as! String
        if let object = aDecoder.decodeObjectForKey("assets") as? [Asset] {
            self.assets = object
        }
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
