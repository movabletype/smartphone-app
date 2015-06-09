//
//  AssetDetailViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/29.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class AssetDetailViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var CreatedAtLabel: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var asset: Asset!
    var blog: Blog!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = asset.dispName()
        self.imageView.sd_setImageWithURL(NSURL(string: asset.url))
        
        self.sizeLabel.text = NSLocalizedString("Size：\(asset.width) x \(asset.height)", comment: "Size：\(asset.width) x \(asset.height)")
        self.AuthorLabel.text = NSLocalizedString("Author：\(asset.createdByName)", comment: "Author：\(asset.createdByName)")
        
        if let date = asset.createdDate {
            let dateString = Utils.dateTimeFromDate(date)
            self.CreatedAtLabel.text = NSLocalizedString("Created at：\(dateString)", comment: "Created at：\(dateString)")
        } else {
            self.CreatedAtLabel.text = NSLocalizedString("Created at：?", comment: "Created at：?")
        }

        deleteButton.enabled = blog.canDeleteAsset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func deleteAsset() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Delete item...", comment: "Delete item..."))
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: ((JSON!)-> Void) = {
            (result: JSON!)-> Void in
            LOG("\(result)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            let defaultCenter = NSNotificationCenter.defaultCenter()
            defaultCenter.postNotificationName(MTIAssetDeletedNotification, object: nil, userInfo: ["asset":self.asset])

            self.navigationController?.popViewControllerAnimated(true)
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
        }
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                api.deleteAsset(siteID: self.asset.blogID, assetID: self.asset.id, success: success, failure: failure)
            },
            failure: failure
        )
    }
    
    @IBAction func deleteButtonPushed(sender: AnyObject) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Delete Item", comment: "Delete Item"),
            message: NSLocalizedString("Are you sure you want to delete the Item?", comment: "Are you sure you want to delete the Item?"),
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Destructive) {
            action in
            self.deleteAsset()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {
            action in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
