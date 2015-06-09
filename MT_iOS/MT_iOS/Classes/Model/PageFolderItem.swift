//
//  PageFolderItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class PageFolderItem: BaseEntryItem {
    var selected = [Folder]()
    
    override init() {
        super.init()
        
        type = "folder"
    }
    
    override func value()-> String {
        var array = [String]()
        for item in selected {
            array.append(item.label)
        }
        return join(",", array)
    }
    
    override func dispValue()-> String {
        return self.value()
    }
    
    override func makeParams()-> [String : AnyObject] {
        var folders = [[String: String]]()
        for item in selected {
            folders.append(["id":item.id])
        }
        return ["folders":folders]
    }
}
