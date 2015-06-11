//
//  Utils.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/21.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import Foundation

class Utils {
    class func userAgent()->String {
        let uName = "MTiOS"
        let version: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let userAgent = uName + "/" + version
        
        return userAgent
    }

    class func dateFromISO8601String(string: String)->NSDate? {
        if string.isEmpty {
            return nil
        }
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
        return formatter.dateFromString(string)
    }

    class func ISO8601StringFromDate(date: NSDate) -> String {
        var formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return formatter.stringFromDate(date).stringByAppendingString("Z")
    }

    
    class func dateTimeFromString(string: String)->NSDate? {
        if string.isEmpty {
            return nil
        }
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss";
        return formatter.dateFromString(string)
    }

    class func dateTimeTextFromDate(date: NSDate)->String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss";
        return formatter.stringFromDate(date)
    }

    class func dateTimeStringFromDate(date: NSDate, template: String)->String {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        var dateFormat: NSString = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: NSLocale.currentLocale())!
        dateFormatter.dateFormat = dateFormat as String
        return dateFormatter.stringFromDate(date)
    }
    
    class func fullDateTimeFromDate(date: NSDate)->String {
        return Utils.dateTimeStringFromDate(date, template:"yMMMMdEE HHmm")
    }

    class func mediumDateTimeFromDate(date: NSDate)->String {
        return Utils.dateTimeStringFromDate(date, template:"yMMMMd HHmm")
    }
    
    class func dateTimeFromDate(date: NSDate)->String {
        return Utils.dateTimeStringFromDate(date, template:"yMMMMd HHmm")
    }

    class func dateStringFromDate(date: NSDate)->String {
        return Utils.dateTimeStringFromDate(date, template:"yMMMMdEEE")
    }

    class func mediumDateStringFromDate(date: NSDate)->String {
        return Utils.dateTimeStringFromDate(date, template:"yMMMMd")
    }

    class func timeStringFromDate(date: NSDate)->String {
        return Utils.dateTimeStringFromDate(date, template:"HHmm")
    }
    
    class func getTextFieldFromView(view: UIView)->UITextField? {
        for subview in view.subviews as! [UIView] {
            if subview.isKindOfClass(UITextField) {
                return subview as? UITextField
            } else {
                let textField = self.getTextFieldFromView(subview)
                if (textField != nil) {
                    return textField
                }
            }
        }
        
        return nil
    }
    
    class func removeHTMLTags(html: String)-> String {
        var destination : String = html.stringByReplacingOccurrencesOfString("<(\"[^\"]*\"|'[^']*'|[^'\">])*>", withString:"", options:NSStringCompareOptions.RegularExpressionSearch, range: nil)
        destination = destination.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return destination
    }
    
    class func performAfterDelay(block: dispatch_block_t, delayTime: Double) {
        let delay = delayTime * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    class func resizeImage(image: UIImage, width: CGFloat)-> UIImage {
        var w = image.size.width
        var h = image.size.height
        var scale = width / w
        //オリジナルサイズのとき
        if width == 0 {
            w = image.size.width
            scale = 1.0
        }
        h = h * scale
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    class func convertImageToJPEG(image: UIImage, quality: CGFloat)-> NSData {
        let imageData = UIImageJPEGRepresentation(image, quality)
        return imageData
    }
    
    class func makeJPEGFilename()-> String {
        let date = NSDate()
        let filename = String(format: "mt-%04d%02d%02d%02d%02d%02d.jpg", arguments: [date.year, date.month, date.day, date.hour, date.minute, date.seconds])
        return filename
    }
}