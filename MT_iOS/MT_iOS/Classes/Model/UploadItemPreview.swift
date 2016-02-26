//
//  UploadItemPreview.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/26.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class UploadItemPreview: UploadItemPost {
    override func upload(progress progress: ((Int64!, Int64!, Int64!) -> Void)? = nil, success: (JSON! -> Void)!, failure: (JSON! -> Void)!) {
        let json = itemList.makeParams(false)
        
        let isEntry = itemList.object is Entry
        
        let blogID = itemList.blog.id
        var id: String? = nil
        if !itemList.object.id.isEmpty {
            id = itemList.object.id
        }
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                if isEntry {
                    api.previewEntry(siteID: blogID, entryID: id, entry: json, success: success, failure: failure)
                } else {
                    api.previewPage(siteID: blogID, pageID: id, entry: json, success: success, failure: failure)
                }
            },
            failure: failure
        )
    }
}
