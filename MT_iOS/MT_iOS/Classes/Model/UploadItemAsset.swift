//
//  UploadItemAsset.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/08.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class UploadItemAsset: UploadItemImage {
    private(set) var asset: PHAsset!
    
    init(asset: PHAsset) {
        super.init()
        self.asset = asset
    }
    
    override func setup(completion: (() -> Void)) {
        let manager = PHImageManager.defaultManager()
        manager.requestImageDataForAsset(self.asset, options: nil,
            resultHandler: {(imageData: NSData?, dataUTI: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) in
                if let data = imageData {
                    if let image = UIImage(data: data) {
                        let jpeg = Utils.convertJpegData(image, width: self.width, quality: self.quality)
                        self.data = jpeg
                        completion()
                    }
                } else {
                    completion()
                }
            }
        )
    }

}
