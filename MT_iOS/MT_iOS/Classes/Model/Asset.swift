//
//  Asset.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Asset: BaseObject {
    var label: String = ""
    var url: String = ""
    var filename: String = ""
    var fileSize: Int = 0
    var width: Int = 0
    var height: Int = 0
    var createdByName: String = ""
    var createdDate: NSDate?
    var blogID: String = ""
    
    override init(json: JSON) {
        super.init(json: json)
        
        label = json["label"].stringValue
        url = json["url"].stringValue
        filename = json["filename"].stringValue
        fileSize = json["meta"]["fileSize"].stringValue.toInt()!
        width = json["meta"]["width"].stringValue.toInt()!
        height = json["meta"]["height"].stringValue.toInt()!
        createdByName = json["createdBy"]["displayName"].stringValue
        createdDate = Utils.dateFromISO8601String(json["createdDate"].stringValue)
        blogID = json["blog"]["id"].stringValue
    }
    
    func dispName()-> String {
        if !self.label.isEmpty {
            return self.label
        }
        
        return self.filename
    }
}