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
        if !json["meta"]["width"].stringValue.isEmpty {
            width = json["meta"]["width"].stringValue.toInt()!
        }
        if !json["meta"]["height"].stringValue.isEmpty {
            height = json["meta"]["height"].stringValue.toInt()!
        }
        createdByName = json["createdBy"]["displayName"].stringValue
        let dateString = json["createdDate"].stringValue
        if !dateString.isEmpty {
            createdDate = Utils.dateFromISO8601String(dateString)
        }
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
    
    func imageHTML(align: Blog.ImageAlign)-> String {
        var dimmensions = "width=\(self.width) height=\(self.height)"
        
        var wrapStyle = "class=\"mt-image-\(align.value().lowercaseString)\" "
        switch align {
        case .Left:
            wrapStyle += "style=\"float: left; margin: 0 20px 20px 0;\""
        case .Right:
            wrapStyle += "style=\"float: right; margin: 0 0 20px 20px;\""
        case .Center:
            wrapStyle += "style=\"text-align: center; display: block; margin: 0 auto 20px;\""
        default:
            wrapStyle += "style=\"\""
        }
        
        let html = "<img alt=\"\(label)\" src=\"\(url)\" \(dimmensions) \(wrapStyle) />"
        
        return html
    }
}