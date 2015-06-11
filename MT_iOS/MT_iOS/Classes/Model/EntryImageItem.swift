//
//  EntryImageItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryImageItem: EntryAssetItem {
    override init() {
        super.init()
        
        type = "image"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func asHtml()-> String {
        return super.asHtml()
    }

    override func value()-> String {
        return super.value()
    }
    
    override func dispValue()-> String {
        return url
    }
}
