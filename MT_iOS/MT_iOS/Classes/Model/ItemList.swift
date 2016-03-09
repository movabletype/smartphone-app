//
//  ItemList.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemList: NSObject {
    var items = [BaseObject]()
    var working: Bool = false
    var refresh: Bool = false
    var sortEnabled: Bool = true
    var totalCount: Int = 0
    var searchText = ""
    
    func toModel(json: JSON)->BaseObject {
        //Implemants subclass
        return BaseObject(json: json)
    }
    
    func isExists(model: BaseObject)->Bool {
        for item in self.items {
            if (item as BaseObject).id == model.id {
                return true
            }
        }
        return false
    }
    
    func deleteObject(model: BaseObject)->Bool {
        let index = existsIndex(model)
        
        if index > NOTFOUND {
            self.items.removeAtIndex(index)
            return true
        }
        
        return false
    }

    
    func existsIndex(model: BaseObject)->Int {
        var i = 0
        for item in self.items {
            if (item as BaseObject).id == model.id {
                return i
            }
            i++
        }
        return NOTFOUND
    }
    
    func objectWithID(id: String)-> BaseObject? {
        for item in self.items {
            if (item as BaseObject).id == id {
                return item
            }
        }
        return nil
    }
    
//    func sortByCreatedAt() {
//        self.items.sort {
//            (a: AnyObject?, b: AnyObject?) -> Bool in
//            return (a as BaseObject).createdAt.compare((b as BaseObject).createdAt) == NSComparisonResult.OrderedDescending
//        }
//    }
    
    subscript(index: Int)-> BaseObject {
        get {
            assert(items.count > index, "index out of range")
            return items[index]
        }
        set(item) {
            assert(0 > index || items.count >= index, "index out of range")
            items.insert(item, atIndex: index)
        }
    }
    
    var count: Int {
        return self.items.count
    }
    
    func isFinished()-> Bool {
        if self.items.count == 0 && self.totalCount > 0 {
            return true
        }
        return self.totalCount <= self.items.count
    }
    
    func parseItems(jsonItems: [JSON]!) {
        for jsonItem in jsonItems {
            let item: BaseObject = self.toModel(jsonItem)
            if !item.id.isEmpty {
                let index = self.existsIndex(item)
                if index < 0 {
                    self.items.append(item)
                } else {
                    self.items[index] = item
                }
            }
        }
    }
    
    func postProcess() {
        refresh = false
        working = false
    }
    
    func fetch(offset: Int, success: ((items:[JSON]!, total:Int!) -> Void)!, failure: (JSON! -> Void)!) {
        //Implemants subclass
    }
    
    func refresh(success: ((items:[JSON]!, total:Int!) -> Void)!, failure: (JSON! -> Void)!) {
        refresh = true
        self.fetch(0, success: success, failure: failure)
    }
    
    func more(success: ((items:[JSON]!, total:Int!) -> Void)!, failure: (JSON! -> Void)!) {
        refresh = false
        self.fetch(self.items.count, success: success, failure: failure)
    }
}
