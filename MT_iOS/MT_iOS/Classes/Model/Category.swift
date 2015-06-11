//
//  Category.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Category: BaseObject {
    var label: String = ""
    var basename: String = ""
    var parent: String = ""
    
    var level = 0
    
    override init(json: JSON) {
        super.init(json: json)
        
        label = json["label"].stringValue
        basename = json["basename"].stringValue
        parent = json["parent"].stringValue
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.basename, forKey: "basename")
        aCoder.encodeObject(self.parent, forKey: "parent")
        aCoder.encodeInteger(self.level, forKey: "level")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.label = aDecoder.decodeObjectForKey("label") as! String
        self.basename = aDecoder.decodeObjectForKey("basename") as! String
        self.parent = aDecoder.decodeObjectForKey("parent") as! String
        self.level = aDecoder.decodeIntegerForKey("level")
    }

}
