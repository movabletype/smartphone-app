//
//  EntryBlocksItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/10.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryBlocksItem: EntryTextAreaItem {
    var blocks = [BaseEntryItem]()
   
    override init() {
        super.init()
        
        type = "blocks"
    }
}
