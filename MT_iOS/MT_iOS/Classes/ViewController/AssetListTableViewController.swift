//
//  AssetListTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class AssetList: ItemList {
    var blog: Blog!
    
    override func toModel(json: JSON)->BaseObject {
        return Asset(json: json)
    }
    
    override func fetch(offset: Int, success: ((items:[JSON]!, total:Int!) -> Void)!, failure: (JSON! -> Void)!) {
        if working {return}
        
        self.working = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: (([JSON]!, Int!)-> Void) = {
            (result: [JSON]!, total: Int!)-> Void in
            LOG("\(result)")
            if self.refresh {
                self.items = []
            }
            self.totalCount = total
            self.parseItems(result)
            success(items: result, total: total)
            self.postProcess()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            failure(error)
            self.postProcess()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                var params = ["limit":"20", "class":"image", "relatedAssets":"1"]
                if !self.refresh {
                    params["offset"] = "\(self.items.count)"
                }
                if !self.searchText.isEmpty {
                    params["search"] = self.searchText
                    params["searchFields"] = "label,filename"
                }
                
                api.listAssets(siteID: self.blog.id, options: params, success: success, failure: failure)
            },
            failure: failure
        )
        
    }
}

class AssetListTableViewController: BaseTableViewController, UISearchBarDelegate, AddAssetDelegate {
    var cameraButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    
    var blog: Blog!
    var list: AssetList = AssetList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Items", comment: "Items")
        
        list.blog = self.blog

        self.refreshControl = MTRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        searchBar = UISearchBar()
        searchBar.frame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 44.0)
        searchBar.barTintColor = Color.tableBg
        searchBar.placeholder = NSLocalizedString("Search", comment: "Search")
        searchBar.delegate = self
        
        var textField = Utils.getTextFieldFromView(searchBar)
        if textField != nil {
            textField!.enablesReturnKeyAutomatically = false
        }
        
        self.tableView.registerNib(UINib(nibName: "AssetTableViewCell", bundle: nil), forCellReuseIdentifier: "AssetTableViewCell")
        
        self.navigationController?.toolbar.barTintColor = Color.navBar
        self.navigationController?.toolbar.tintColor = Color.navBarTint
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "assetDeleted:", name: MTIAssetDeletedNotification, object: nil)
        
        cameraButton = UIBarButtonItem(image: UIImage(named: "btn_camera"), left: true, target: self, action: "cameraButtonPushed:")
        self.toolbarItems = [cameraButton]
        let user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser!
        cameraButton.enabled = blog.canUpload(user: user)

    }
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if list.count == 0 {
            self.fetch()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    @IBAction func refresh(sender:UIRefreshControl) {
        self.fetch()
    }
    
    // MARK: - fetch
    func fetch() {
        SVProgressHUD.showWithStatus("Fetch items...")
        var success: (([JSON]!, Int!)-> Void) = {
            (result: [JSON]!, total: Int!)-> Void in
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("Fetch items failured.", comment: "Fetch items failured."))
            self.refreshControl!.endRefreshing()
        }
        list.refresh(success, failure: failure)
    }
    
    func more() {
        var success: (([JSON]!, Int!)-> Void) = {
            (result: [JSON]!, total: Int!)-> Void in
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            self.refreshControl!.endRefreshing()
        }
        list.more(success, failure: failure)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AssetTableViewCell", forIndexPath: indexPath) as! AssetTableViewCell
        
        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        let item = self.list[indexPath.row] as! Asset
        cell.asset = item
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 92.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let asset = list[indexPath.row] as! Asset
        let storyboard: UIStoryboard = UIStoryboard(name: "AssetDetail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AssetDetailViewController
        vc.asset = asset
        vc.blog = blog
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: -
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
            
            if self.list.working {return}
            if self.list.isFinished() {return}
            
            self.more()
        }
    }
    
    //MARK: -
    func composeButtonPushed(sender: UIBarButtonItem) {
        
    }
    
    // MARK: --
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.list.searchText = searchBar.text
        if self.list.count > 0 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
        self.fetch()
    }
    
    @IBAction func cameraButtonPushed(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddAsset", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! AddAssetTableViewController
        vc.blog = blog
        vc.delegate = self
        vc.showAlign = false
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func assetDeleted(note: NSNotification) {
        if let userInfo = note.userInfo {
            let asset = userInfo["asset"]! as! Asset
            if self.list.deleteObject(asset) {
                self.tableView.reloadData()
            }
        }
    }

    func AddAssetDone(controller: AddAssetTableViewController, asset: Asset) {
        self.dismissViewControllerAnimated(false, completion:
            {_ in
                self.fetch()
            }
        )
    }
}
