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
    
    required init?(coder aDecoder: NSCoder) {
        self.items = aDecoder.decodeObjectForKey("items") as! [BaseEntryItem]
        self.visibledItems = aDecoder.decodeObjectForKey("visibledItems") as! [BaseEntryItem]
        self.blog = aDecoder.decodeObjectForKey("blog") as! Blog
        self.object = aDecoder.decodeObjectForKey("object") as! BaseEntry
        
        for item in items {
            if item is EntryBlocksItem {
                (item as! EntryBlocksItem).editMode = self.object.editMode
            }
        }
    }
    
    convenience init(blog: Blog, object: BaseEntry) {
        self.init()
        
        self.blog = blog
        self.object = object
        
        let titleItem = EntryTitleItem()
        titleItem.id = "title"
        titleItem.label = NSLocalizedString("Title", comment: "Title")
        titleItem.text = object.title
        
        var categoryItem: BaseEntryItem
        if object is Entry {
            let item = EntryCategoryItem()
            item.id = "category"
            item.label = NSLocalizedString("Category", comment: "Category")
            item.selected = (object as! Entry).categories
            categoryItem = item
        } else {
            let item = PageFolderItem()
            item.id = "folder"
            item.label = NSLocalizedString("Folder", comment: "Folder")
            item.selected = (object as! Page).folders
            categoryItem = item
        }
        
        let statusItem = EntryStatusItem()
        statusItem.id = "status"
        statusItem.unpublished = false
        if object.status == Entry.Status.Publish.text() {
            statusItem.selected = Entry.Status.Publish.rawValue
        } else if object.status == Entry.Status.Draft.text() {
            statusItem.selected = Entry.Status.Draft.rawValue
        } else if object.status == Entry.Status.Future.text() {
            statusItem.selected = Entry.Status.Future.rawValue
        } else if object.status == Entry.Status.Unpublish.text() {
            statusItem.selected = Entry.Status.Unpublish.rawValue
            statusItem.unpublished = true
        }
        
        statusItem.label = NSLocalizedString("Status", comment: "Status")
        
        var bodyItem = EntryTextAreaItem()
        if object.id.isEmpty {
            bodyItem = EntryBlocksItem()
            (bodyItem as! EntryBlocksItem).editMode = object.editMode
        }
        bodyItem.id = "body"
        bodyItem.label = NSLocalizedString("Body", comment: "Body")
        bodyItem.text = object.body
        
        var moreItem = EntryTextAreaItem()
        if object.id.isEmpty {
            moreItem = EntryBlocksItem()
            (bodyItem as! EntryBlocksItem).editMode = object.editMode
        }
        moreItem.id = "more"
        moreItem.label = NSLocalizedString("Extended", comment: "Extended")
        moreItem.text = object.more
        
        let excerptItem = EntryTextItem()
        excerptItem.id = "excerpt"
        excerptItem.label = NSLocalizedString("Excerpt", comment: "Excerpt")
        excerptItem.text = object.excerpt
        
        let keywordsItem = EntryTextItem()
        keywordsItem.id = "keywords"
        keywordsItem.label = NSLocalizedString("Keywords", comment: "Keywords")
        keywordsItem.text = object.keywords

        let basenameItem = EntryTextItem()
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
                let item = EntryTextItem()
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "textarea" {
                let item = EntryTextAreaItem()
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "checkbox" {
                let item = EntryCheckboxItem()
                item.checked = (customFieldObject!.value == "1")
                if customFieldObject!.value.isEmpty {
                    item.checked = (customFieldObject!.defaultValue == "1")
                }
                entryItem = item
            } else if field.type == "url" {
                let item = EntryURLItem()
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "datetime" {
                if field.options == "datetime" {
                    let item = EntryDateTimeItem()
                    item.datetime = Utils.dateTimeFromString(customFieldObject!.value)
                    entryItem = item
                } else if field.options == "date" {
                    let item = EntryDateItem()
                    item.date = Utils.dateTimeFromString(customFieldObject!.value)
                    entryItem = item
                } else if field.options == "time" {
                    let item = EntryTimeItem()
                    item.time = Utils.dateTimeFromString(customFieldObject!.value)
                    entryItem = item
                }
            } else if field.type == "select" {
                let item = EntrySelectItem()
                if !customFieldObject!.value.isEmpty {
                    item.selected = customFieldObject!.value
                } else {
                    item.selected = customFieldObject!.defaultValue
                }
                let options = field.options.characters.split { $0 == "," }.map { String($0) }
                item.list.removeAll(keepCapacity: false)
                for option in options {
                    item.list.append(Utils.trimSpace(option))
                }
                entryItem = item
            } else if field.type == "radio" {
                let item = EntryRadioItem()
                if !customFieldObject!.value.isEmpty {
                    item.selected = customFieldObject!.value
                } else {
                    item.selected = customFieldObject!.defaultValue
                }
                let options = field.options.characters.split { $0 == "," }.map { String($0) }
                item.list.removeAll(keepCapacity: false)
                for option in options {
                    item.list.append(Utils.trimSpace(option))
                }
                entryItem = item
            } else if field.type == "embed" {
                let item = EntryEmbedItem()
                item.text = customFieldObject!.value
                if customFieldObject!.value.isEmpty {
                    item.text = customFieldObject!.defaultValue
                }
                entryItem = item
            } else if field.type == "image" {
                let item = EntryImageItem()
                item.extractInfoFromHTML(customFieldObject!.value)
                entryItem = item
            }
            
            entryItem.id = field.basename
            entryItem.label = field.name
            entryItem.isCustomField = true
            entryItem.required = field.required
            entryItem.descriptionText = field.descriptionText
            
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
    
    func orderSettingKeyOld()-> String {
        if object is Entry {
            return blog.settingKey("entryitem_order_entry")
        } else {
            return blog.settingKey("entryitem_order_page")
        }
    }
    
    func orderSettingKey()-> String {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let user = app.currentUser {
            if object is Entry {
                return blog.settingKey("entryitem_order_entry", user: user)
            } else {
                return blog.settingKey("entryitem_order_page", user: user)
            }
        }

        return self.orderSettingKeyOld()
    }
    
    func loadOrderSettings()-> [[String:AnyObject]]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let value: AnyObject = defaults.objectForKey(self.orderSettingKey()) {
            return value as? [Dictionary]
        }
        
        //V1.0.xとの互換性のため
        if let value: AnyObject = defaults.objectForKey(self.orderSettingKeyOld()) {
            defaults.removeObjectForKey(self.orderSettingKeyOld())
            
            defaults.setObject(value, forKey:self.orderSettingKey())
            defaults.synchronize()
            
            return value as? [Dictionary]
        }
        return nil
    }
    
    func saveOrderSettings() {
        var array = [[String:AnyObject]]()
        for item in items {
            let i = [
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
    
    func makeParams(preview: Bool)->[String: AnyObject] {
        var params = [String: AnyObject]()
        var fields = [AnyObject]()
        for item in items {
            if item.isCustomField {
                let itemParams = item.makeParams()
                var param = [String: AnyObject]()
                for key in itemParams.keys {
                    if !key.isEmpty {
                        if item.type == "datetime" || item.type == "date" || item.type == "time" {
                            if (itemParams[key] as! String).isEmpty {
                                continue
                            }
                        }
                        
                        param["basename"] = key
                        param["value"] = itemParams[key]
                    }
                }
                fields.append(param)
            } else {
                item.isPreview = preview
                let itemParams = item.makeParams()
                for key in itemParams.keys {
                    if !key.isEmpty {
                        params[key] = itemParams[key]
                    }
                }
            }
        }
        params["customFields"] = fields
        
        if object.id.isEmpty {
            //新規作成時にカテゴリ未選択なら送信しない
            if let categories = params["categories"] as? [[String: String]] {
                if categories.count == 0 {
                    params.removeValueForKey("categories")
                }
            }
            //新規作成時にフォルダ未選択なら送信しない
            if let folder = params["folder"] as? [String: String] {
                if let id = folder["id"] {
                    if id.isEmpty {
                        params.removeValueForKey("folder")
                    }
                } else {
                    params.removeValueForKey("folder")
                }
            }
        }
        
        //id
        if !object.id.isEmpty {
            params["id"] = object.id
        }
        
        //Tags
        var tags = [String]()
        for tag in object.tags {
            tags.append(tag.name)
        }
        params["tags"] = tags
        
        //Assets
        var assetIDs = [String]()
        func appendID(id: String) {
            if !id.isEmpty && !assetIDs.contains(id) {
                assetIDs.append(id)
            }
        }
        
        for asset in object.assets {
            if !assetIDs.contains(asset.id) {
                assetIDs.append(asset.id)
            }
        }
        for item in self.items {
            if item is EntryAssetItem {
                let id = (item as! EntryAssetItem).assetID
                appendID(id)
            } else if item is EntryBlocksItem {
                for block in (item as! EntryBlocksItem).blocks {
                    if block is EntryAssetItem {
                        let id = (block as! EntryAssetItem).assetID
                        appendID(id)
                    }
                }
            } else if item is EntryTextAreaItem {
                let assets = (item as! EntryTextAreaItem).assets
                for asset in assets {
                    let id = asset.id
                    appendID(id)
                }
            }
        }
        var assets = [[String: String]]()
        for id in assetIDs {
            assets.append(["id":id])
        }
        if assets.count > 0 {
            params["assets"] = assets
        }
        
        //PublishDate
        if object.date != nil {
            params["date"] = Utils.ISO8601StringFromDate(object.date!)
        }
        
        //UnpublishDate
        if object.unpublishedDate != nil {
            params["unpublishedDate"] = Utils.ISO8601StringFromDate(object.unpublishedDate!)
        }
        
        if object.id.isEmpty {
            params["format"] = object.editMode.format()
        }
        
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
        var path = blog.draftDirPath(object)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let user = app.currentUser {
            path = blog.draftDirPath(object, user: user)
        }
        return path
    }
    
    func makeFilename()-> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let filename = dateFormatter.stringFromDate(NSDate())
        
        return filename
    }
    
    class func loadFromFile(path: String, filename: String)-> EntryItemList {
        let list = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! EntryItemList
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
        let err: NSErrorPointer = nil
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            err.memory = error
        } catch {
        }
        if err == nil {
            path = path.stringByAppendingPathComponent(self.filename)
            return NSKeyedArchiver.archiveRootObject(self, toFile: path)
        }
        
        return false
    }
    
    func removeDraftData()-> Bool {
        let paths = self.ImageFiles()
        for path in paths {
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtPath(path)
            } catch {
            }
        }
        
        if !self.filename.isEmpty {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            var path = paths[0].stringByAppendingPathComponent(self.dataDir())
            path = path.stringByAppendingPathComponent(self.filename)
            
            let fileManager = NSFileManager.defaultManager()
            let err: NSErrorPointer = nil
            do {
                try fileManager.removeItemAtPath(path)
            } catch let error as NSError {
                err.memory = error
            } catch {
            }
            
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
    
    func clean() {
        for item in items {
            item.isDirty = false
        }
    }
    
    func notUploadedImages()->[EntryImageItem] {
        var images = [EntryImageItem]()
        for item in items {
            if item is EntryImageItem {
                let imageItem = (item as! EntryImageItem)
                if !imageItem.imageFilename.isEmpty {
                    images.append(imageItem)
                }
            } else if item is EntryBlocksItem {
                for block in (item as! EntryBlocksItem).blocks {
                    if block is BlockImageItem {
                        let imageItem = (block as! BlockImageItem)
                        if !imageItem.imageFilename.isEmpty {
                            images.append(imageItem)
                        }
                    }
                }
            }

        }
        return images
    }

    func ImageFiles()->[String] {
        var files = [String]()
        for item in items {
            if item is EntryImageItem {
                let imageItem = (item as! EntryImageItem)
                if !imageItem.imageFilename.isEmpty {
                    files.append(imageItem.imageFilename)
                }
            } else if item is EntryBlocksItem {
                for block in (item as! EntryBlocksItem).blocks {
                    if block is BlockImageItem {
                        let imageItem = (block as! BlockImageItem)
                        if !imageItem.imageFilename.isEmpty {
                            files.append(imageItem.imageFilename)
                        }
                    }
                }
            }
            
        }
        return files
    }
}
