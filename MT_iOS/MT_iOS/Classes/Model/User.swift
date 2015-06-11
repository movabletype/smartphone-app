//
//  User.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/27.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: BaseObject {
    var displayName: String = ""
    var userpicUrl: String = ""
    
    override init(json: JSON) {
        super.init(json: json)
        
        displayName = json["displayName"].stringValue
        userpicUrl = json["userpicUrl"].stringValue
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.displayName, forKey: "displayName")
        aCoder.encodeObject(self.userpicUrl, forKey: "userpicUrl")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.displayName = aDecoder.decodeObjectForKey("displayName") as! String
        self.userpicUrl = aDecoder.decodeObjectForKey("userpicUrl") as! String
    }

}
