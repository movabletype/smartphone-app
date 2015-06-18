//
//  BlogTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/21.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class BlogTableViewController: BaseTableViewController {
    enum Section:Int {
        case Blog = 0,
        Asset,
        _Num
    }
    
    enum BlogItem:Int {
        case Entries = 0,
        DraftEntries,
        Pages,
        DraftPages,
        _Num
    }

    enum AssetItem:Int {
        case Assets = 0,
        _Num
    }

    var blog: Blog!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = blog.name
        self.tableView.backgroundColor = Color.tableBg

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Get blog settings...", comment: "Get blog settings..."))
        self.getPermissions(
            {(failure: Bool)-> Void in
                if self.blog.canCreateEntry() || self.blog.canCreatePage() {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_newentry"), left: false, target: self, action: "composeButtonPushed:")
                } else {
                    self.navigationItem.rightBarButtonItem = nil
                }

                self.tableView.reloadData()

                self.getCustomFields(
                    {(failure: Bool)-> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        if !failure {
                            SVProgressHUD.dismiss()
                        }
                    }
                )
            }
        )
    }
    
    private func getCustomFields(completion: (Bool)-> Void) {
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            completion(true)
        }
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                var params = ["includeShared":"system", "systemObject":"entry"]
                api.listFields(siteID: self.blog.id, options: params, success:
                    {(result: [JSON]!, total: Int!)-> Void in
                        LOG("\(result)")
                        self.blog.customfieldsForEntry.removeAll(keepCapacity: false)
                        for item in result {
                            let field = CustomField(json: item)
                            self.blog.customfieldsForEntry.append(field)
                        }
                        
                        var params = ["includeShared":"system", "systemObject":"page"]
                        api.listFields(siteID: self.blog.id, options: params, success:
                            {(result: [JSON]!, total: Int!)-> Void in
                                LOG("\(result)")
                                self.blog.customfieldsForPage.removeAll(keepCapacity: false)
                                for item in result {
                                    let field = CustomField(json: item)
                                    self.blog.customfieldsForPage.append(field)
                                }

                                completion(false)
                            }
                            , failure: failure
                        )
                    }
                    , failure: failure
                )
            },
            failure: failure
        )
    }
    
    private func getPermissions(completion: (Bool)-> Void) {
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            completion(true)
        }
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                api.listPermissionsForSite(self.blog.id, success: {
                    (result: [JSON]!, total: Int!)-> Void in
                        LOG("\(result)")
                        for item in result {
                            let permissions = item["permissions"].arrayValue
                            for item in permissions {
                                let permission = item.stringValue
                                if !self.blog.hasPermission(permission) {
                                    self.blog.permissions.append(permission)
                                }
                            }
                        }
                        completion(false)
                    }
                    , failure: failure
                )
            },
            failure: failure
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if self.blog.canListAsset() {
            return Section._Num.rawValue
        } else {
            return Section._Num.rawValue - 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case Section.Blog.rawValue:
            return BlogItem._Num.rawValue
        case Section.Asset.rawValue:
            return AssetItem._Num.rawValue
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        self.adjustCellLayoutMargins(cell)

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = Color.cellText
        cell.textLabel?.font = UIFont.systemFontOfSize(17.0)
        
        switch indexPath.section {
        case Section.Blog.rawValue:
            switch indexPath.row {
            case BlogItem.Entries.rawValue:
                cell.textLabel?.text = NSLocalizedString("Entries", comment: "Entries")
                cell.imageView?.image = UIImage(named: "ico_listfolder")
            case BlogItem.DraftEntries.rawValue:
                cell.textLabel?.text = NSLocalizedString("Local saved entries", comment: "Local saved entries")
                cell.imageView?.image = UIImage(named: "ico_listfolder copy")
            case BlogItem.Pages.rawValue:
                cell.textLabel?.text = NSLocalizedString("Pages", comment: "Pages")
                cell.imageView?.image = UIImage(named: "ico_listfolder")
            case BlogItem.DraftPages.rawValue:
                cell.textLabel?.text = NSLocalizedString("Local saved pages", comment: "Local saved pages")
                cell.imageView?.image = UIImage(named: "ico_webpage")
            default:
                cell.textLabel?.text = ""
            }
        case Section.Asset.rawValue:
            switch indexPath.row {
            case AssetItem.Assets.rawValue:
                cell.textLabel?.text = NSLocalizedString("Assets", comment: "Assets")
                cell.imageView?.image = UIImage(named: "ico_item")
            default:
                cell.textLabel?.text = ""
            }
        default:
            cell.textLabel?.text = ""
        }
        
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Table view delegte
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case Section.Blog.rawValue:
            return 110.0
        case Section.Asset.rawValue:
            return 15.0
        default:
            return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.Blog.rawValue:
            var blogInfoView: BlogInfoView = BlogInfoView.instanceFromNib() as! BlogInfoView
            blogInfoView.blog = self.blog
            
            blogInfoView.BlogURLButton.addTarget(self, action: "blogURLButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            blogInfoView.BlogPrefsButton.addTarget(self, action: "blogPrefsButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            return blogInfoView
        case Section.Asset.rawValue:
            return UIView()
        default:
            return UIView()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case Section.Blog.rawValue:
            switch indexPath.row {
            case BlogItem.Entries.rawValue:
                let vc = EntryListTableViewController()
                let blog = self.blog
                vc.blog = blog
                self.navigationController?.pushViewController(vc, animated: true)

            case BlogItem.DraftEntries.rawValue:
                let vc = EntryDraftTableViewController()
                let blog = self.blog
                vc.blog = blog
                self.navigationController?.pushViewController(vc, animated: true)

            case BlogItem.Pages.rawValue:
                let vc = PageListTableViewController()
                let blog = self.blog
                vc.blog = blog
                self.navigationController?.pushViewController(vc, animated: true)

            case BlogItem.DraftPages.rawValue:
                let vc = PageDraftTableViewController()
                let blog = self.blog
                vc.blog = blog
                self.navigationController?.pushViewController(vc, animated: true)

            default:
                break
            }
        case Section.Asset.rawValue:
            switch indexPath.row {
            case AssetItem.Assets.rawValue:
                let vc = AssetListTableViewController()
                let blog = self.blog
                vc.blog = blog
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Blog", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! BlogTableViewController
//        let blog = self.list[indexPath.row] as! Blog
//        vc.blog = blog
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    func blogURLButtonPushed(sender: UIButton) {
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.url = blog.url
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func blogPrefsButtonPushed(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "BlogSettings", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! BlogSettingsTableViewController
        vc.blog = blog
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func composeButtonPushed(sender: UIBarButtonItem) {
        let actionSheet: UIAlertController = UIAlertController(title:NSLocalizedString("Create", comment: "Create"),
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                LOG("cancelAction")
            }
        )
        
        let createEntryAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Create Entry", comment: "Create Entry"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                app.createEntry(self.blog, controller: self)
            }
        )
        
        let createPageAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Create Page", comment: "Create Page"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                app.createPage(self.blog, controller: self)
            }
        )
        
        
        if self.blog.canCreateEntry() {
            actionSheet.addAction(createEntryAction)
        }
        if self.blog.canCreatePage() {
            actionSheet.addAction(createPageAction)
        }
        
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
}
