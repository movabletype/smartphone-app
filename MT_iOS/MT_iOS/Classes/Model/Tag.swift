//
//  Tag.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tag: BaseObject {
    var name: String = ""
    
    override init(json: JSON) {
        super.init(json: json)
        
        name = json.stringValue
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.name, forKey: "name")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.name = aDecoder.decodeObjectForKey("name") as! String
    }

}
