//
//  BaseObject.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseObject: NSObject, NSCoding {
    var id: String = ""
    
    init(json: JSON) {
        super.init()
        
        id = json["id"].stringValue
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey("id") as! String
    }
}
