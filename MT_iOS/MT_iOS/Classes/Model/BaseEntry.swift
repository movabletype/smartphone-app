//
//  BaseEntry.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/22.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseEntry: BaseObject {
    enum Status: Int {
        case Publish = 0,
        Draft,
        Future
        
        func text()-> String {
            switch(self) {
            case .Publish:
                return "Publish"
            case .Draft:
                return "Draft"
            case .Future:
                return "Future"
            }
        }

        func label()-> String {
            switch(self) {
            case .Publish:
                return NSLocalizedString("Publish", comment: "Publish")
            case .Draft:
                return NSLocalizedString("Draft", comment: "Draft")
            case .Future:
                return NSLocalizedString("Future", comment: "Future")
            }
        }
    }

    enum EditMode: Int {
        case PlainText = 0,
        RichText
        
        func text()-> String {
            switch(self) {
            case .PlainText:
                return "PlainText"
            case .RichText:
                return "RichText"
            }
        }
        
        func label()-> String {
            switch(self) {
            case .PlainText:
                return NSLocalizedString("PlainText", comment: "PlainText")
            case .RichText:
                return NSLocalizedString("RichText", comment: "RichText")
            }
        }
    }
    
    var title = ""
    var date: NSDate?
    var unpublishedDate: NSDate?
    var status = ""
    var blogID = ""
    var body = ""
    var more = ""
    var excerpt = ""
    var keywords = ""
    var tags = [Tag]()
    var author: Author!
    var customFields = [CustomField]()
    var permalink = ""
    var basename = ""
    
    var editMode: EditMode = .RichText
    
    override init(json: JSON) {
        super.init(json: json)
        
        title = json["title"].stringValue
        let dateString = json["date"].stringValue
        date = Utils.dateFromISO8601String(dateString)
        let unpublishedDateString = json["unpublishedDate"].stringValue
        unpublishedDate = Utils.dateFromISO8601String(unpublishedDateString)
        status = json["status"].stringValue
        blogID = json["blog"]["id"].stringValue
        body = json["body"].stringValue
        more = json["more"].stringValue
        excerpt = json["excerpt"].stringValue
        keywords = json["keywords"].stringValue
        basename = json["basename"].stringValue
        
        tags.removeAll(keepCapacity: false)
        for item in json["tags"].arrayValue {
            let tag = Tag(json: item)
            tags.append(tag)
        }
        
        customFields.removeAll(keepCapacity: false)
        for item in json["customFields"].arrayValue {
            let customField = CustomField(json: item)
            customFields.append(customField)
        }
        
        author = Author(json: json["author"])

        permalink = json["permalink"].stringValue

    }
    
    func tagsString()-> String {
        var array = [String]()
        for tag in tags {
            array.append(tag.name)
        }
        
        return join(",", array)
    }
    
    func setTagsFromString(string: String) {
        tags.removeAll(keepCapacity: false)
        let list = split(string) { $0 == "," }
        for item in list {
            tags.append(Tag(json: JSON(item)))
        }
    }
    
    func customFieldWithBasename(basename: String)-> CustomField? {
        for field in customFields {
            if field.basename == basename {
                return field
            }
        }
        
        return nil
    }
}
