//
//  BlockTextItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlockTextItem: BaseBlockItem {
    var text = ""
    
    override func value()-> String {
        return text
    }
    
    override func dispValue()-> String {
        return self.value()
    }
}
