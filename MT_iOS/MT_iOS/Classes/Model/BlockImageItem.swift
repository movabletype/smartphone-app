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

    override func asHtml()-> String {
        if asset != nil {
            return asset!.imageHTML(align)
        }
        return ""
    }
    
    override func value()-> String {
        if url.isEmpty {
            return ""
        }
        
        let html = self.asHtml()
        
        return html
    }
}
