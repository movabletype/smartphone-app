//
//  BaseEntryItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BaseEntryItem: NSObject {
    var id = ""
    var type = ""
    var label = ""
    var isCustomField = false
    var visibled = true
    var disabled = false
    
    func value()-> String {
        return ""
    }

    func dispValue()-> String {
        return self.value()
    }
    
    func makeParams()-> [String:AnyObject] {
        return [self.id:self.value()]
    }
}
