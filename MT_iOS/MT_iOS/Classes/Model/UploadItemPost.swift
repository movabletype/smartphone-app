//
//  UploadItemPost.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/26.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class UploadItemPost: UploadItem {
    private(set) var itemList: EntryItemList!
    
    init(itemList: EntryItemList) {
        super.init()
        self.itemList = itemList
    }
    
    override func setup(completion: (() -> Void)) {
        completion()
    }
    
    override func thumbnail(size: CGSize, completion: (UIImage->Void)) {
        if let image = UIImage(named: "upload_entry") {
            let widthRatio = size.width / image.size.width
            let heightRatio = size.height / image.size.height
            let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
            let resizedSize = CGSize(width: (image.size.width * ratio), height: (image.size.height * ratio))
            UIGraphicsBeginImageContext(resizedSize)
            image.drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(resizedImage)
        }
    }
    
    override func makeFilename()->String {
        if itemList.object is Entry {
            self._filename = NSLocalizedString("Entry", comment: "Entry")
        } else {
            self._filename = NSLocalizedString("Page", comment: "Page")
        }
        
        return self._filename
    }
    
    override func upload(progress progress: ((Int64!, Int64!, Int64!) -> Void)? = nil, success: (JSON! -> Void)!, failure: (JSON! -> Void)!) {
        let json = itemList.makeParams(false)

        let create = itemList.object.id.isEmpty
        let isEntry = itemList.object is Entry
        
        let blogID = itemList.blog.id
        let id = itemList.object.id
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                progress?(5, 5, 10)
                let params = ["no_text_filter":"1"]
                if create {
                    if isEntry {
                        api.createEntry(siteID: blogID, entry: json, options: params, success: success, failure: failure)
                    } else {
                        api.createPage(siteID: blogID, page: json, options: params, success: success, failure: failure)
                    }
                } else {
                    if isEntry {
                        api.updateEntry(siteID: blogID, entryID: id, entry: json, options: params, success: success, failure: failure)
                    } else {
                        api.updatePage(siteID: blogID, pageID: id, page: json, options: params, success: success, failure: failure)
                    }
                }
            },
            failure: failure
        )
    }
}
