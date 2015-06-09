//
//  BlockImageItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlockImageItem: BaseBlockItem {
    var asset: Asset?
    var url = ""
    var assetID = ""
    var filename = ""
    var width = 0
    var height = 0
    var wrapStyle = ""

    func asHtml()-> String {
        return "<a href=\"\(url)\">\(filename)</a>"
    }
    
    override func value()-> String {
        var html = self.asHtml()
        var form = "<form mt:asset-id=\"\(self.assetID)\" class=\"mt-enclosure mt-enclosure-image\" style=\"display: inline;\">\(html)</form>"
        
        return form
    }
    
    override func dispValue()-> String {
        return url
    }
}
