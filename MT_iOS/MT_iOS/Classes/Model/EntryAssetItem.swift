//
//  EntryAssetItem.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/04.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryAssetItem: BaseEntryItem {
    private var _asset: Asset?
    var asset: Asset? {
        get {
            return _asset
        }
        set {
            _asset = newValue
            
            if _asset != nil {
                assetID = _asset!.id
                url = _asset!.url
            } else {
                assetID = ""
                url = ""
            }
        }
    }
    
    var url = ""
    var assetID = ""
    var filename = ""
    
    override init() {
        super.init()
        
        type = "asset"
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self._asset, forKey: "_asset")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.assetID, forKey: "assetID")
        aCoder.encodeObject(self.filename, forKey: "filename")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self._asset = aDecoder.decodeObjectForKey("_asset") as? Asset
        self.url = aDecoder.decodeObjectForKey("url") as! String
        self.assetID = aDecoder.decodeObjectForKey("assetID") as! String
        self.filename = aDecoder.decodeObjectForKey("filename") as! String
    }
    
    func asHtml()-> String {
        return "<a href=\"\(url)\">\(filename)</a>"
    }
    
    override func value()-> String {
        if url.isEmpty {
            return ""
        }
        
        let html = self.asHtml()
        let form = "<form mt:asset-id=\"\(self.assetID)\" class=\"mt-enclosure mt-enclosure-\(self.type)\" style=\"display: inline;\">\(html)</form>"
        
        return form
    }
    
    override func dispValue()-> String {
        return url
    }
    
    override func clear() {
        self.asset = nil
    }
    
    func extractInfoFromHTML(html: String) {
        self.url = self.extractURLFromHTML(html)
        self.assetID = self.extractAsssetIDFromHTML(html)
    }

    private func extractFromHTML(html: String, pattern: String)-> String {
        let content: NSString = html
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        if let result = regex?.firstMatchInString(content as String, options: NSMatchingOptions(), range: NSMakeRange(0, content.length)) {
            if result.numberOfRanges < 1 {
                return ""
            }
            let range = result.rangeAtIndex(1)
            let text = content.substringWithRange(range)
            return text
        } else {
            return ""
        }
    }
    
    private func extractURLFromHTML(html: String)-> String {
        return self.extractFromHTML(html, pattern: "<a href=\"([^\"]*)\">")
    }
    
    private func extractAsssetIDFromHTML(html: String)-> String {
        return self.extractFromHTML(html, pattern: "<form mt:asset-id=\"([^\"]*)\" ")
    }
    
    override func makeParams()-> [String : AnyObject] {
        return [self.id:self.value()]
    }
}
