//
//  UploadItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/08.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class UploadItem: NSObject {
    internal(set) var data: NSData! = nil
    var blogID = ""
    var uploadPath = ""
    var uploaded = false
    
    func setup(completion: (() -> Void)) {
        completion()
    }
    
    func clear() {
        self.data = nil
    }
    
    func filename()->String {
        return ""
    }
    
    func upload(progress progress: ((Int64!, Int64!, Int64!) -> Void)? = nil, success: (JSON! -> Void)!, failure: (JSON! -> Void)!) {
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                api.uploadAssetForSite(self.blogID, assetData:  self.data, fileName: self.filename(), options: ["path":self.uploadPath, "autoRenameIfExists":"true"], progress: progress, success: success, failure: failure)
            },
            failure: failure
        )
    }
}
