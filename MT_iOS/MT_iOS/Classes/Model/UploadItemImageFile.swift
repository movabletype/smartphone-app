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
}
