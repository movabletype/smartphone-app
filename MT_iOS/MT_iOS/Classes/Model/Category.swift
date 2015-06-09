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
}
