//
//  UploadItemImage.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/08.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class UploadItemImage: UploadItem {
    var width: CGFloat = Blog.ImageSize.Original.size()
    var quality: CGFloat = Blog.ImageQuality.Normal.quality() / 100.0
    
}
