//
//  MultiUploader.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/08.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class MultiUploader: NSObject {
    private var items = [UploadItem]()
    private var queue = [UploadItem]()
    
    var blogID = ""
    var uploadPath = ""

    func addItem(item: UploadItem) {
        item.blogID = self.blogID
        item.uploadPath = self.uploadPath
        items.append(item)
    }
    
    func addAsset(asset: PHAsset, width: CGFloat, quality: CGFloat) {
        let item = UploadItemAsset(asset: asset)
        item.width = width
        item.quality = quality
        self.addItem(item)
    }
    
    func addJpeg(path: String, width: CGFloat, quality: CGFloat) {
        let item = UploadItemImageFile(path: path)
        item.width = width
        item.quality = quality
        self.addItem(item)
    }
    
    func count()->Int {
        return items.count
    }
    
    func queueCount()->Int {
        return queue.count
    }
    
    func clear() {
        items.removeAll()
    }
    
    private func progress()->Float {
        let progress: Float = Float(self.items.count - self.queue.count) / Float(self.items.count)
        return progress
    }
    
    private func processed()->Int {
        return self.items.count - self.queue.count
    }
    
    private func upload(success: (Int->Void)?, failure: (Int->Void)?) {
        func successFinish() {
            if let closure = success {
                closure(self.processed())
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        func failureFinish() {
            if let closure = failure {
                closure(self.processed())
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }

        let status = String(format: NSLocalizedString("Upload images(%d/%d)", comment: "Upload images(%d/%d)"), arguments: [self.processed(), self.items.count])
        SVProgressHUD.showProgress(self.progress(), status: status)

        if let item = self.queue.first {
            item.setup({
                let success: ((JSON!)-> Void) = {
                    (result: JSON!)-> Void in
                    self.queue.removeFirst()
                    if self.queue.count == 0 {
                        let status = String(format: NSLocalizedString("Upload images(%d/%d)", comment: "Upload images(%d/%d)"), arguments: [self.processed(), self.items.count])
                        SVProgressHUD.showProgress(1.0, status: status)
                        successFinish()
                    } else {
                        self.upload(success, failure: failure)
                    }
                }
                let failure: (JSON!-> Void) = {
                    (error: JSON!)-> Void in
                    SVProgressHUD.showErrorWithStatus(error.description)
                    failureFinish()
                }

                item.upload(success, failure: failure)
            })
        } else {
            SVProgressHUD.dismiss()
            successFinish()
            return
        }
    }
    
    func start(success: (Int->Void)?, failure: (Int->Void)?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.queue = self.items
        self.upload(success, failure: failure)
    }

    func restart(success: (Int->Void)?, failure: (Int->Void)?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.upload(success, failure: failure)
    }
}
