//
//  CustomField.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomField: BaseObject {
    var value: String = ""
    var basename: String = ""
    var descriptionText: String = ""
    var systemObject: String = ""
    var defaultValue: String = ""
    var type: String = ""
    var tag: String = ""
    var required: Bool = false
    var name: String = ""
    var options: String = ""
    
    override init(json: JSON) {
        super.init(json: json)
        
        value = json["value"].stringValue
        basename = json["basename"].stringValue
        descriptionText = json["description"].stringValue
        systemObject = json["systemObject"].stringValue
        defaultValue = json["default"].stringValue
        type = json["type"].stringValue
        tag = json["tag"].stringValue
        required = (json["required"].stringValue == "true")
        name = json["name"].stringValue
        options = json["options"].stringValue
    }

    func isSupportedType()-> Bool {
        let supportedType = [
            "text",
            "textarea",
            "checkbox",
            "url",
            "datetime",
            "select",
            "radio",
            "embed",
            "image",
        ]
        
        return contains(supportedType, self.type)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.value, forKey: "value")
        aCoder.encodeObject(self.basename, forKey: "basename")
        aCoder.encodeObject(self.descriptionText, forKey: "descriptionText")
        aCoder.encodeObject(self.systemObject, forKey: "systemObject")
        aCoder.encodeObject(self.defaultValue, forKey: "defaultValue")
        aCoder.encodeObject(self.type, forKey: "type")
        aCoder.encodeObject(self.tag, forKey: "tag")
        aCoder.encodeBool(self.required, forKey: "required")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.options, forKey: "options")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.value = aDecoder.decodeObjectForKey("value") as! String
        self.basename = aDecoder.decodeObjectForKey("basename") as! String
        self.descriptionText = aDecoder.decodeObjectForKey("descriptionText") as! String
        self.systemObject = aDecoder.decodeObjectForKey("systemObject") as! String
        self.defaultValue = aDecoder.decodeObjectForKey("defaultValue") as! String
        self.type = aDecoder.decodeObjectForKey("type") as! String
        self.tag = aDecoder.decodeObjectForKey("tag") as! String
        self.required = aDecoder.decodeBoolForKey("required")
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.options = aDecoder.decodeObjectForKey("options") as! String
    }

}
