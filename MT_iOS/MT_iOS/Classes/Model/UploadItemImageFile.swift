//
//  UploadItemImageFile.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/08.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class UploadItemImageFile: UploadItemImage {
    private(set) var path: String!

    init(path: String) {
        super.init()
        self.path = path
    }

    override func setup(completion: (() -> Void)) {
        if let image = UIImage(contentsOfFile: self.path) {
            let jpeg = Utils.convertJpegData(image, width: self.width, quality: self.quality)
            self.data = jpeg
            completion()
        } else {
            completion()
        }
    }
    
    override func thumbnail(size: CGSize, completion: (UIImage->Void)) {
        if let image = UIImage(contentsOfFile: path) {
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
        let fileManager = NSFileManager.defaultManager()
        do {
            let attributes = try fileManager.attributesOfFileSystemForPath(path)
            if let date = attributes[NSFileCreationDate] as? NSDate {
                return Utils.makeJPEGFilename(date)
            }
        } catch _ {
        }
        
        return Utils.makeJPEGFilename(NSDate())
    }
}
