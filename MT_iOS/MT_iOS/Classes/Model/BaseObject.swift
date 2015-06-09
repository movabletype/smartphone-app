//
//  BaseObject.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseObject: NSObject {
    var id: String = ""
    
    init(json: JSON) {
        super.init()
        
        id = json["id"].stringValue
    }
}
