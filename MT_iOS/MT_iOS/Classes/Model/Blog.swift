//
//  Blog.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Blog: BaseObject {
    enum ImageSize: Int {
        case Original = 0
        ,XL
        ,L
        ,M
        ,S
        ,XS
        ,_Num
        
        func size()-> CGFloat {
            switch(self) {
            case .Original:
                return 0
            case .XL:
                return 1280.0
            case .L:
                return 1024.0
            case .M:
                return 800.0
            case .S:
                return 640.0
            case .XS:
                return 320.0
            case ._Num:
                return 0
            }
        }
        func pix()-> String {
            switch(self) {
            case .Original:
                return NSLocalizedString("Original Size", comment: "Original Size")
            case .XL:
                return "1280px"
            case .L:
                return "1024px"
            case .M:
                return "800px"
            case .S:
                return "640px"
            case .XS:
                return "320px"
            case ._Num:
                return ""
            }
        }
        func label()-> String {
            switch(self) {
            case .Original:
                return NSLocalizedString("Original", comment: "Original")
            case .XL:
                return NSLocalizedString("X-Large", comment: "X-Large")
            case .L:
                return NSLocalizedString("Large", comment: "Large")
            case .M:
                return NSLocalizedString("Medium", comment: "Medium")
            case .S:
                return NSLocalizedString("Small", comment: "Small")
            case .XS:
                return NSLocalizedString("X-Small", comment: "X-Small")
            case ._Num:
                return ""
            }
        }
    }

    enum ImageQuality: Int {
        case Highest = 0
        ,High
        ,Normal
        ,Low
        ,_Num
        
        func quality()-> CGFloat {
            switch(self) {
            case .Highest:
                return 100.0
            case .High:
                return 80.0
            case .Normal:
                return 50.0
            case .Low:
                return 30.0
            case ._Num:
                return 0.0
            }
        }
        func label()-> String {
            switch(self) {
            case .Highest:
                return NSLocalizedString("Super Fine", comment: "Super Fine")
            case .High:
                return NSLocalizedString("Fine", comment: "Fine")
            case .Normal:
                return NSLocalizedString("Normal", comment: "Normal")
            case .Low:
                return NSLocalizedString("Low", comment: "Low")
            case ._Num:
                return ""
            }
        }
    }
    
    enum ImageAlign: Int {
        case None = 0,
        Left,
        Right,
        Center,
        _Num
        
        func label()-> String {
            switch(self) {
            case .None:
                return NSLocalizedString("None", comment: "None")
            case .Left:
                return NSLocalizedString("Left", comment: "Left")
            case .Right:
                return NSLocalizedString("Right", comment: "Right")
            case .Center:
                return NSLocalizedString("Center", comment: "Center")
            case ._Num:
                return ""
            }
        }
    }
    
    var name: String = ""
    var url: String = ""
    var parentName: String = ""
    var parentID: String = ""
    
    var permissions: [String] = []
    var customfieldsForEntry: [CustomField] = []
    var customfieldsForPage: [CustomField] = []
    
    var uploadDir: String = "/"
    var imageSize: ImageSize = .M
    var imageQuality: ImageQuality = .Normal
    var imageAlign: ImageAlign = .None
    
    var endpoint = ""
   
    override init(json: JSON) {
        super.init(json: json)
        
        name = json["name"].stringValue
        url = json["url"].stringValue
        parentName = json["parent"]["name"].stringValue
        parentID = json["parent"]["id"].stringValue
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.parentName, forKey: "parentName")
        aCoder.encodeObject(self.parentID, forKey: "parentID")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
        if let object: AnyObject = aDecoder.decodeObjectForKey("parentName") {
            self.parentName = object as! String
        }
        if let object: AnyObject = aDecoder.decodeObjectForKey("parentID") {
            self.parentID = object as! String
        }
    }

    func hasPermission(permission: String)-> Bool {
        return contains(permissions, permission)
    }
    
    func canCreateEntry()-> Bool {
        return self.hasPermission("create_post")
    }

    func canUpdateEntry(#user:User, entry: Entry)-> Bool {
        if self.hasPermission("edit_all_posts") {
            return true
        }
        
        if self.hasPermission("publish_post") {
            if entry.author.id == user.id {
                return true
            }
        }
        
        if self.hasPermission("create_post") {
            if entry.author.id == user.id {
                if entry.status == "Draft" {
                    return true
                }
            }
        }

        return false
    }
    
    func canDeleteEntry(#user:User, entry: Entry)-> Bool {
        if self.hasPermission("edit_all_posts") {
            return true
        }
        
        if self.hasPermission("create_post") {
            if entry.author.id == user.id {
                if entry.status == "Draft" {
                    return true
                }
            }
        }
        
        return false
    }
    
    func canPublishEntry()-> Bool {
        return self.hasPermission("publish_post")
    }
    
    func canCreateCategory()-> Bool {
        return self.hasPermission("edit_categories")
    }

    func canCreatePage()-> Bool {
        return self.hasPermission("manage_pages")
    }

    func canUpdatePage()-> Bool {
        return self.hasPermission("manage_pages")
    }

    func canDeletePage()-> Bool {
        return self.hasPermission("manage_pages")
    }

    func canListAsset()-> Bool {
        return self.hasPermission("edit_assets")
    }
    
    func canDeleteAsset()-> Bool {
        return self.hasPermission("edit_assets")
    }
    
    func canListAssetForEntry()-> Bool {
        return self.hasPermission("create_post") || self.hasPermission("edit_all_posts")
    }

    func canListAssetForPage()-> Bool {
        return self.hasPermission("manage_pages")
    }
    
    func canUpload()-> Bool {
        return self.hasPermission("upload")
    }
    
    func settingKey(name: String)-> String {
        return self.endpoint + "_blog\(id)_\(name)"
    }
    
    func dataDirPath()-> String {
        let dir = self.endpoint + "_blog\(id)"
        return dir.stringByReplacingOccurrencesOfString("/", withString: "_", options: nil, range: nil)
    }
    
    func draftDirPath(object: BaseEntry)-> String {
        var path = self.dataDirPath()
        path = path.stringByAppendingPathComponent(object is Entry ? "draft_entry" : "draft_page")
        
        return path
    }
    
    func loadSettings()-> [[String:AnyObject]]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let value: AnyObject = defaults.objectForKey(self.settingKey("blogsettings_uploaddir")) {
            uploadDir = value as! String
        }
        if let value: Int = defaults.objectForKey(self.settingKey("blogsettings_imagesize")) as? Int {
            imageSize = Blog.ImageSize(rawValue: value)!
        }
        if let value: Int = defaults.objectForKey(self.settingKey("blogsettings_imagequality")) as? Int {
            imageQuality = Blog.ImageQuality(rawValue: value)!
        }
        return nil
    }
    
    func saveSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(uploadDir, forKey:self.settingKey("blogsettings_uploaddir"))
        defaults.setInteger(imageSize.rawValue, forKey:self.settingKey("blogsettings_imagesize"))
        defaults.setInteger(imageQuality.rawValue, forKey:self.settingKey("blogsettings_imagequality"))
        defaults.synchronize()
    }
}
