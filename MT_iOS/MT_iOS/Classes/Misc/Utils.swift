//
//  Utils.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/21.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import Foundation
import TMReachability

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
        let formatter = NSDateFormatter()
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
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let dateFormat: NSString = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: NSLocale.currentLocale())!
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
        for subview in view.subviews {
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
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    class func resizeImage(image: UIImage, width: CGFloat)-> UIImage {
        //オリジナルサイズのとき
        if width == 0.0 {
            return image
        }
        
        var w = image.size.width
        var h = image.size.height
        let scale = width / w
        if scale >= 1.0 {
            return image
        }
        w = width
        h = h * scale
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    class func convertImageToJPEG(image: UIImage, quality: CGFloat)-> NSData {
        let imageData = UIImageJPEGRepresentation(image, quality)
        return imageData!
    }
    
    class func convertJpegData(image: UIImage, width: CGFloat, quality: CGFloat)->NSData {
        let resizedImage = Utils.resizeImage(image, width: width)
        let jpeg = Utils.convertImageToJPEG(resizedImage, quality: quality)
        return jpeg
    }
    
    class func makeJPEGFilename(date: NSDate)-> String {
        let filename = String(format: "mt-%04d%02d%02d%02d%02d%02d.jpg", arguments: [date.year, date.month, date.day, date.hour, date.minute, date.seconds])
        return filename
    }
    
    class func hasConnectivity()-> Bool {
        let reachability = TMReachability.reachabilityForInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus()
        return (networkStatus != NetworkStatus.NotReachable)
    }

    class func preferredLanguage()-> String {
        let languages = NSLocale.preferredLanguages()
        let language = languages[0] 
        return language
    }
    
    class func confrimSave(vc: UIViewController, dismiss: Bool = false) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Confirm", comment: "Confirm"),
            message: NSLocalizedString("Are you sure not have to save?", comment: "Are you sure not have to save?"),
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Destructive) {
            action in
            if dismiss {
                vc.dismissViewControllerAnimated(true, completion: nil)
            } else {
                vc.navigationController?.popViewControllerAnimated(true)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {
            action in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func trimSpace(src: String)-> String {
        return src.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    class func regexpMatch(pattern: String, text: String)-> Bool {
        let regexp = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regexp.matchesInString(text, options: [], range:NSMakeRange(0, text.characters.count))
        return matches.count > 0
    }
    
    class func validatePath(path: String)-> Bool {
        if let _ = path.rangeOfString("./") {
            return false
        }
        
        let pattern = "[ \"%<>\\[\\\\\\]\\^`{\\|}~]"
        let replaceString = path.stringByReplacingOccurrencesOfString(pattern, withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        let api = DataAPI.sharedInstance
        let str = api.urlencoding(replaceString)
        if let _ = str.rangeOfString("%") {
            return false
        }
        return true
    }
}