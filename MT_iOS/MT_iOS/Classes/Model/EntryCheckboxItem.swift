//
//  EntrycCheckboxItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryCheckboxItem: BaseEntryItem {
    var checked = false
    
    override init() {
        super.init()
        
        type = "checkbox"
    }
    
    override func value()-> String {
        return checked ? "true" : "false"
    }
    
    override func dispValue()-> String {
        return self.value()
    }
    
    override func clear() {
        checked = false
    }
}
