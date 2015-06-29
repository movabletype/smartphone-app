//
//  BaseCategoryListTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/08.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CategoryList: ItemList {
    var blog: Blog!
    
    override func toModel(json: JSON)->BaseObject {
        return Category(json: json)
    }
    
    private func levelLoop(object: Category, parent: Category) {
        object.level++
        object.path = parent.label + "/" + object.path
        let parent = self.objectWithID(parent.parent)
        if parent != nil {
            levelLoop(object, parent: parent as! Category)
        }
        return
    }

    func makeLevel() {
        for item in items as! [Category] {
            item.path = item.label
            let parent = self.objectWithID(item.parent)
            if parent != nil {
                levelLoop(item, parent: parent as! Category)
            } else {
                item.level = 0
            }
        }
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
            self.makeLevel()
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
                var params = ["limit":"9999", "sortOrder":"ascend"]
                
                api.listCategories(siteID: self.blog.id, options: params, success: success, failure: failure)
            },
            failure: failure
        )
        
    }
}

class BaseCategoryListTableViewController: BaseTableViewController {
    var blog: Blog!
    var object: BaseEntryItem!

    var list: ItemList = CategoryList()
    var actionMessage = NSLocalizedString("Fetch data", comment: "Fetch data")
    var selected = [String:Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshControl = MTRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        
        var items: [Category]
        if object is EntryCategoryItem {
            items = (object as! EntryCategoryItem).selected
        } else {
            items = (object as! PageFolderItem).selected
        }
        for item in items {
            selected[item.id] = true
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arw"), left: true, target: self, action: "backButtonPushed:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        let item = self.list[indexPath.row] as! Category
        cell.object = item
        
        if selected[item.id] != nil && selected[item.id] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selected = true
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selected = false
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Refresh
    @IBAction func refresh(sender:UIRefreshControl) {
        self.fetch()
    }
    
    // MARK: - fetch
    func fetch() {
        SVProgressHUD.showWithStatus(actionMessage + "...")
        var success: (([JSON]!, Int!)-> Void) = {
            (result: [JSON]!, total: Int!)-> Void in
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            SVProgressHUD.showErrorWithStatus(String(format: NSLocalizedString("%@ failured.", comment: "%@ failured."), arguments: [self.actionMessage]))
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
    
    @IBAction func saveButtonPushed(sender: UIBarButtonItem) {
        var selectedObjects = [BaseObject]()
        for (id, value) in selected {
            if value {
                if !id.isEmpty {
                    selectedObjects.append(list.objectWithID(id)!)
                }
            }
        }
        
        if object is EntryCategoryItem {
            (object as! EntryCategoryItem).selected = selectedObjects as! [Category]
        } else {
            (object as! PageFolderItem).selected = selectedObjects as! [Folder]
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        if !object.isDirty {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        Utils.confrimSave(self)
    }
}
