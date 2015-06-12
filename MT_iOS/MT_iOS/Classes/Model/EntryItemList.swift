//
//  EntryItemList.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/04.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class EntryItemList: NSObject, NSCoding {
    var items = [BaseEntryItem]()
    var visibledItems = [BaseEntryItem]()
    var blog: Blog!
    var object: BaseEntry!
    
    var filename = ""
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.items, forKey: "items")
        aCoder.encodeObject(self.visibledItems, forKey: "visibledItems")
        aCoder.encodeObject(self.blog, forKey: "blog")
        aCoder.encodeObject(self.object, forKey: "object")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.items = aDecoder.decodeObjectForKey("items") as! [BaseEntryItem]
        self.visibledItems = aDecoder.decodeObjectForKey("visibledItems") as! [BaseEntryItem]
        self.blog = aDecoder.decodeObjectForKey("blog") as! Blog
        self.object = aDecoder.decodeObjectForKey("object") as! BaseEntry
    }
    
    convenience init(blog: Blog, object: BaseEntry) {
        self.init()
        
        self.blog = blog
        self.object = object
        
        var titleItem = EntryTitleItem()
        titleItem.id = "title"
        titleItem.label = NSLocalizedString("Title", comment: "Title")
        titleItem.text = object.title
        
        var categoryItem: BaseEntryItem
        if object is Entry {
            var item = EntryCategoryItem()
            item.id = "category"
            item.label = NSLocalizedString("Category", comment: "Category")
            item.selected = (object as! Entry).categories
            categoryItem = item
        } else {
            var item = PageFolderItem()
            item.id = "folder"
            item.label = NSLocalizedString("Folder", comment: "Folder")
            item.selected = (object as! Page).folders
            categoryItem = item
        }
        
        var statusItem = EntryStatusItem()
        statusItem.id = "status"
        if object.status == Entry.Status.Publish.text() {
            statusItem.selected = Entry.Status.Publish.rawValue
        } else if object.status == Entry.Status.Draft.text() {
            statusItem.selected = Entry.Status.Draft.rawValue
        } else if object.status == Entry.Status.Future.text() {
            statusItem.selected = Entry.Status.Future.rawValue
        }
        
        statusItem.label = NSLocalizedString("Status", comment: "Status")
        
        var bodyItem = EntryTextAreaItem()
        if object.id.isEmpty {
            bodyItem = EntryBlocksItem()
        }
        bodyItem.id = "body"
        bodyItem.label = NSLocalizedString("Body", comment: "Body")
        bodyItem.text = object.body
        
        var moreItem = EntryTextAreaItem()
        if object.id.isEmpty {
            moreItem = EntryBlocksItem()
        }
        moreItem.id = "more"
        moreItem.label = NSLocalizedString("More", comment: "More")
        moreItem.text = object.more
        
        var excerptItem = EntryTextAreaItem()
        if object.id.isEmpty {
            excerptItem = EntryBlocksItem()
        }
        excerptItem.id = "excerpt"
        excerptItem.label = NSLocalizedString("Excerpt", comment: "Excerpt")
        excerptItem.text = object.excerpt
        
        var keywordsItem = EntryTextItem()
        keywordsItem.id = "keywords"
        keywordsItem.label = NSLocalizedString("Keywords", comment: "Keywords")
        keywordsItem.text = object.keywords

        var basenameItem = EntryTextItem()
        basenameItem.id = "basename"
        basenameItem.label = NSLocalizedString("Basename", comment: "Basename")
        basenameItem.text = object.basename

        items = [titleItem, categoryItem, statusItem, bodyItem, moreItem, excerptItem, keywordsItem, basenameItem]

        // CustomFields
        var customFields: [CustomField]
        if object is Entry {
            customFields = blog.customfieldsForEntry
        } else {
            customFields = blog.customfieldsForPage
        }

        for field in customFields {
            if !field.isSupportedType() {
                continue
            }
            
            var customFieldObject = object.customFieldWithBasename(field.basename)
            if customFieldObject == nil {
                customFieldObject = field
            }
            
            var entryItem: BaseEntryItem = BaseEntryItem()
            if field.type == "text" {
                var item = EntryTextItem()
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "textarea" {
                var item = EntryTextAreaItem()
                if object.id.isEmpty {
                    item = EntryBlocksItem()
                }
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "checkbox" {
                var item = EntryCheckboxItem()
                item.checked = (customFieldObject!.value == "true")
                if customFieldObject!.value.isEmpty {
                    item.checked = (customFieldObject!.defaultValue == "true")
                }
                entryItem = item
            } else if field.type == "url" {
                var item = EntryURLItem()
                item.url = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.url = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "datetime" {
                if field.options == "datetime" {
                    var item = EntryDateTimeItem()
                    item.datetime = Utils.dateTimeFromString(customFieldObject!.value)
                    entryItem = item
                } else if field.options == "date" {
                    var item = EntryDateItem()
                    item.date = Utils.dateTimeFromString(customFieldObject!.value)
                    entryItem = item
                } else if field.options == "time" {
                    var item = EntryTimeItem()
                    item.time = Utils.dateTimeFromString(customFieldObject!.value)
                    entryItem = item
                }
            } else if field.type == "select" {
                var item = EntrySelectItem()
                if !customFieldObject!.value.isEmpty {
                    item.selected = customFieldObject!.value
                }
                item.list = split(field.options) { $0 == "," }
                entryItem = item
            } else if field.type == "radio" {
                var item = EntryRadioItem()
                if !customFieldObject!.value.isEmpty {
                    item.selected = customFieldObject!.value
                }
                item.list = split(field.options) { $0 == "," }
                entryItem = item
            } else if field.type == "embed" {
                var item = EntryEmbedItem()
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "image" {
                var item = EntryImageItem()
                item.extractInfoFromHTML(customFieldObject!.value)
                entryItem = item
            }
            
            entryItem.id = field.basename
            entryItem.label = field.name
            entryItem.isCustomField = true
            entryItem.required = field.required
            
            items.append(entryItem)
        }
    
        if let order = self.loadOrderSettings() {
            var orderedItems = [BaseEntryItem]()
            for item in order {
                let id: String = item["id"] as! String
                let isCustomField: Bool = item["isCustomField"] as! Bool
                let visibled: Bool = item["visibled"] as! Bool
                if let entryItem = self.itemWithID(id, isCustomField: isCustomField) {
                    entryItem.visibled = visibled
                    items = items.filter({$0 != entryItem})
                    orderedItems.append(entryItem)
                }
            }
            
            //前回設定保存した時以降に新規追加されたカスタムフィールド対応
            for item in items {
                orderedItems.append(item)
            }
            
            self.items = orderedItems
        }

        self.makeVisibledItems()
    }
    
    subscript(index: Int)-> BaseEntryItem {
        get {
            assert(visibledItems.count > index, "index out of range")
            return visibledItems[index]
        }
    }
    
    var count: Int {
        return self.visibledItems.count
    }
    
    func makeVisibledItems() {
        visibledItems.removeAll(keepCapacity: false)
        for item in items {
            if item.visibled {
                visibledItems.append(item)
            }
        }
        
        self.saveOrderSettings()
    }
    
    func orderSettingKey()-> String {
        if object is Entry {
            return blog.settingKey("entryitem_order_entry")
        } else {
            return blog.settingKey("entryitem_order_page")
        }
    }
    
    func loadOrderSettings()-> [[String:AnyObject]]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let key = self.orderSettingKey()
        if let value: AnyObject = defaults.objectForKey(key) {
            return value as? [Dictionary]
        }
        return nil
    }
    
    func saveOrderSettings() {
        var array = [[String:AnyObject]]()
        for item in items {
            var i = [
                "id": item.id,
                "isCustomField": item.isCustomField,
                "visibled": item.visibled
            ]
            array.append(i as! [String : AnyObject])
        }

        let defaults = NSUserDefaults.standardUserDefaults()
        let key = self.orderSettingKey()
        defaults.setObject(array, forKey:key)
        defaults.synchronize()
    }
    
    func makeParams()->[String: AnyObject] {
        var params = [String: AnyObject]()
        var fields = [AnyObject]()
        for item in items {
            if item.isCustomField {
                let itemParams = item.makeParams()
                var param = [String: AnyObject]()
                for key in itemParams.keys {
                    if !key.isEmpty {
                        param["basename"] = key
                        param["value"] = itemParams[key]
                    }
                }
                fields.append(param)
            } else {
                let itemParams = item.makeParams()
                for key in itemParams.keys {
                    if !key.isEmpty {
                        params[key] = itemParams[key]
                    }
                }
            }
        }
        params["customFields"] = fields
        
        LOG("params:\(params)")
        
        return params
    }
    
    func itemWithID(id: String, isCustomField: Bool)-> BaseEntryItem? {
        for item in items {
            if item.id == id && item.isCustomField == isCustomField {
                return item
            }
        }
        return nil
    }
    
    func dataDir()-> String {
        let path = blog.draftDirPath(object)

        return path
    }
    
    func makeFilename()-> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let filename = dateFormatter.stringFromDate(NSDate())
        
        return filename
    }
    
    class func loadFromFile(path: String, filename: String)-> EntryItemList {
        var list = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! EntryItemList
        list.filename = filename
        
        return list
    }
    
    func saveToFile()-> Bool {
        if self.filename.isEmpty {
            self.filename = makeFilename()
        }
        
        //self.removeDraftData()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var path = paths[0].stringByAppendingPathComponent(self.dataDir())
        
        let fileManager = NSFileManager.defaultManager()
        var err: NSErrorPointer = nil
        fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: err)
        if err == nil {
            path = path.stringByAppendingPathComponent(self.filename)
            return NSKeyedArchiver.archiveRootObject(self, toFile: path)
        }
        
        return false
    }
    
    func removeDraftData()-> Bool {
        if !self.filename.isEmpty {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            var path = paths[0].stringByAppendingPathComponent(self.dataDir())
            path = path.stringByAppendingPathComponent(self.filename)
            
            let fileManager = NSFileManager.defaultManager()
            var err: NSErrorPointer = nil
            fileManager.removeItemAtPath(path, error: err)
            
            return (err == nil)
        }
        
        return true
    }
    
    func requiredCheck()-> BaseEntryItem? {
        for item in items {
            if item.required && item.value().isEmpty {
                return item
            }
        }
        return nil
    }
}
