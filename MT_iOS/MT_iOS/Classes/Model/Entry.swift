//
//  Entry.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/22.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Entry: BaseEntry {
    var categories = [Category]()
    
    override init(json: JSON) {
        super.init(json: json)

        categories.removeAll(keepCapacity: false)
        for item in json["categories"].arrayValue {
            let category = Category(json: item)
            categories.append(category)
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.categories, forKey: "categories")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.categories = aDecoder.decodeObjectForKey("categories") as! [Category]
    }

}
