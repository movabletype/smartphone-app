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
}
