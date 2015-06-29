//
//  PageFolderItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class PageFolderItem: BaseEntryItem {
    var selected = [Folder]()
    
    override init() {
        super.init()
        
        type = "folder"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.selected, forKey: "selected")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selected = aDecoder.decodeObjectForKey("selected") as! [Folder]
    }

    
    override func value()-> String {
        var array = [String]()
        for item in selected {
            array.append(item.label)
        }
        return join(",", array)
    }
    
    override func dispValue()-> String {
        return self.value()
    }
    
    override func makeParams()-> [String : AnyObject] {
        var folder = [String: String]()
        if let item = selected.first {
            folder["id"] = item.id
        }
        return ["folder":folder]
    }
    
    override func clear() {
        selected.removeAll(keepCapacity: false)
    }
}
