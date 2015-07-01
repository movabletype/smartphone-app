//
//  BaseEntryItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BaseEntryItem: NSObject, NSCoding {
    var id = ""
    var type = ""
    var label = ""
    var descriptionText = ""
    var isCustomField = false
    var visibled = true
    var disabled = false
    var required = false
    var isDirty = false
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.type, forKey: "type")
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.descriptionText, forKey: "descriptionText")
        aCoder.encodeBool(self.isCustomField, forKey: "isCustomField")
        aCoder.encodeBool(self.visibled, forKey: "visibled")
        aCoder.encodeBool(self.disabled, forKey: "disabled")
        aCoder.encodeBool(self.required, forKey: "required")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as! String
        self.type = aDecoder.decodeObjectForKey("type") as! String
        self.label = aDecoder.decodeObjectForKey("label") as! String
        if let object = aDecoder.decodeObjectForKey("descriptionText") as? String {
            self.descriptionText = object
        }
        self.isCustomField = aDecoder.decodeBoolForKey("isCustomField")
        self.visibled = aDecoder.decodeBoolForKey("visibled")
        self.disabled = aDecoder.decodeBoolForKey("disabled")
        self.required = aDecoder.decodeBoolForKey("required")
    }

    func value()-> String {
        return ""
    }

    func dispValue()-> String {
        return self.value()
    }
    
    func makeParams()-> [String:AnyObject] {
        return [self.id:self.value()]
    }
    
    func clear() {
        
    }
}
