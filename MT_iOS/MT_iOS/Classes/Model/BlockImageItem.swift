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

    override func asHtml()-> String {
        var dimmensions = "width=\(self.asset!.width) height=\(self.asset!.height)"
        
        var wrapStyle = "class=\"mt-image-\(align.label().lowercaseString)\" "
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
        
        label = self.asset!.label
        
        let html = "<img alt=\"\(label)\" src=\"\(url)\" \(dimmensions) \(wrapStyle) />"

        return html
    }
    
    override func value()-> String {
        if url.isEmpty {
            return ""
        }
        
        var html = self.asHtml()
        
        return html
    }
}
