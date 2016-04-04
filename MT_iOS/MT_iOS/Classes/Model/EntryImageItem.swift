//
//  EntryImageItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryImageItem: EntryAssetItem {
    var imageFilename = ""
    var uploadPath = ""
    var uploadFilename = ""
    
    override init() {
        super.init()
        
        type = "image"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.imageFilename, forKey: "imageFilename")
        aCoder.encodeObject(self.uploadPath, forKey: "uploadPath")
        aCoder.encodeObject(self.uploadFilename, forKey: "uploadFilename")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let text = aDecoder.decodeObjectForKey("imageFilename") as? String {
            self.imageFilename = text
        }
        if let text = aDecoder.decodeObjectForKey("uploadPath") as? String {
            self.uploadPath = text
        }
        if let text = aDecoder.decodeObjectForKey("uploadFilename") as? String {
            self.uploadFilename = text
        }
    }

    override func asHtml()-> String {
        return super.asHtml()
    }

    override func value()-> String {
        return super.value()
    }
    
    override func dispValue()-> String {
        if !url.isEmpty {
            return url
        }
        
        return imageFilename
    }
    
    func jpegFilename(blog: Blog)->String {
        let uuid: String = NSUUID().UUIDString
        let filename = uuid + ".jpeg"
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let user = app.currentUser
        var dir = blog.dataDirPath(user)
        dir = dir.stringByReplacingOccurrencesOfString(":", withString: "", options: [], range: nil)
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var path = paths[0].stringByAppendingPathComponent(dir)
        
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch {
        }
        
        path = path.stringByAppendingPathComponent(filename)
        
        return path
    }

    func removeJpegFile() {
        if !self.imageFilename.isEmpty {
            let path = self.imageFilename
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtPath(path)
            } catch {
            }
            self.imageFilename = ""
        }
    }
    
    override func clear() {
        super.clear()
        self.cleanup()
    }
    
    func cleanup() {
        self.removeJpegFile()
    }
}
