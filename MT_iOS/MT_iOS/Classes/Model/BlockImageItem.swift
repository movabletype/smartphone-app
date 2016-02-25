//
//  BlockImageItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlockImageItem: EntryImageItem {
    var width = 0
    var height = 0
    var align = Blog.ImageAlign.None

    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(self.width, forKey: "width")
        aCoder.encodeInteger(self.height, forKey: "height")
        aCoder.encodeInteger(self.align.rawValue, forKey: "align")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.width = aDecoder.decodeIntegerForKey("width")
        self.height = aDecoder.decodeIntegerForKey("height")
        self.align = Blog.ImageAlign(rawValue: aDecoder.decodeIntegerForKey("align"))!
    }

    func imageHTML(align: Blog.ImageAlign)-> String {
        var wrapStyle = "class=\"mt-image-\(align.value().lowercaseString)\" "
        switch align {
        case .Left:
            wrapStyle += "style=\"float: left; margin: 0 20px 20px 0;\""
        case .Right:
            wrapStyle += "style=\"float: right; margin: 0 0 20px 20px;\""
        case .Center:
            wrapStyle += "style=\"text-align: center; display: block; margin: 0 auto 20px;\""
        default:
            wrapStyle += "style=\"\""
        }
        
        let url = NSURL(fileURLWithPath: imageFilename)
        //TODO:画像が読み込めない
        let html = "<img alt=\"\(label)\" src=\"\(url.absoluteString)\" \(wrapStyle) />"
        
        return html
    }
    
    override func asHtml()-> String {
        if asset != nil {
            return asset!.imageHTML(align)
        }
        if !imageFilename.isEmpty {
            return self.imageHTML(align)
        }
        return ""
    }
    
    override func value()-> String {
        if url.isEmpty && imageFilename.isEmpty {
            return ""
        }
        
        let html = self.asHtml()
        
        return html
    }
}
