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
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.filename, forKey: "filename")
        aCoder.encodeInteger(self.fileSize, forKey: "fileSize")
        aCoder.encodeInteger(self.width, forKey: "width")
        aCoder.encodeInteger(self.height, forKey: "height")
        aCoder.encodeObject(self.createdByName, forKey: "createdByName")
        aCoder.encodeObject(self.createdDate, forKey: "createdDate")
        aCoder.encodeObject(self.blogID, forKey: "blogID")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.label = aDecoder.decodeObjectForKey("label") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
        self.filename = aDecoder.decodeObjectForKey("filename") as! String
        self.fileSize = aDecoder.decodeIntegerForKey("fileSize")
        self.width = aDecoder.decodeIntegerForKey("width")
        self.height = aDecoder.decodeIntegerForKey("height")
        self.createdByName = aDecoder.decodeObjectForKey("createdByName") as! String
        self.createdDate = aDecoder.decodeObjectForKey("createdDate") as? NSDate
        self.blogID = aDecoder.decodeObjectForKey("blogID") as! String
    }
    
    func dispName()-> String {
        if !self.label.isEmpty {
            return self.label
        }
        
        return self.filename
    }
}