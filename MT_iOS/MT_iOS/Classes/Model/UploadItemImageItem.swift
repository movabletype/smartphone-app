//
//  UploadItemImageItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/26.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class UploadItemImageItem: UploadItem {
    private(set) var imageItem: EntryImageItem!
    
    init(imageItem: EntryImageItem) {
        super.init()
        self.imageItem = imageItem
    }

    override func setup(completion: (() -> Void)) {
        if let jpeg = NSData(contentsOfFile: imageItem.imageFilename) {
            self.data = jpeg
            completion()
        } else {
            completion()
        }
    }
    
    override func thumbnail(size: CGSize, completion: (UIImage->Void)) {
        if let image = UIImage(contentsOfFile: imageItem.imageFilename) {
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
        self._filename = imageItem.uploadFilename
        
        return self._filename
    }
    
    override func upload(progress progress: ((Int64!, Int64!, Int64!) -> Void)? = nil, success: (JSON! -> Void)!, failure: (JSON! -> Void)!) {
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        let uploadSuccess: ((JSON!)-> Void) = {
            (result: JSON!)-> Void in
            LOG("\(result)")
            
            let asset = Asset(json: result)
            self.imageItem.clear()
            self.imageItem.asset = asset
            success(result)
        }
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                let filename = self.makeFilename()
                api.uploadAssetForSite(self.blogID, assetData:  self.data, fileName: filename, options: ["path":self.imageItem.uploadPath, "autoRenameIfExists":"true"], progress: progress, success: uploadSuccess, failure: failure)
            },
            failure: failure
        )
    }
}
