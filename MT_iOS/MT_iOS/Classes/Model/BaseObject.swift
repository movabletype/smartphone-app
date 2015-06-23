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
    var assets = [Asset]()
    
    init(json: JSON) {
        super.init()
        
        id = json["id"].stringValue
        
        assets.removeAll(keepCapacity: false)
        for item in json["assets"].arrayValue {
            let asset = Asset(json: item)
            assets.append(asset)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.assets, forKey: "assets")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey("id") as! String
        if let object: AnyObject = aDecoder.decodeObjectForKey("assets") {
            self.assets = object as! [Asset]
        }
    }
}
