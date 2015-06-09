//
//  EntryURLItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryURLItem: BaseEntryItem {
    var url = ""
    
    override init() {
        super.init()
        
        type = "url"
    }
    
    override func value()-> String {
        return url
    }
    
    override func dispValue()-> String {
        return self.value()
    }
}
