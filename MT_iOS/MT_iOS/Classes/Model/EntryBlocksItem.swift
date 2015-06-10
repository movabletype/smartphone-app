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
    
    override func dispValue()-> String {
        if blocks.count == 0 {
            return ""
        }
        
        if isImageCell() {
            let block = blocks[0] as! BlockImageItem
            return block.url
        } else {
            let block = blocks[0] as! BlockTextItem
            return block.text
        }
    }
    
    func isImageCell()-> Bool {
        if blocks.count == 0 {
            return false
        }
        
        let block = blocks[0]
        
        if block is BlockImageItem {
            return true
        }
        
        return false
    }
}
