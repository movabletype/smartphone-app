//
//  FolderListTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/08.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class FolderList: CategoryList {
    override func toModel(json: JSON)->BaseObject {
        return Folder(json: json)
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
                
                api.listFolders(siteID: self.blog.id, options: params, success: success, failure: failure)
            },
            failure: failure
        )
        
    }
}

class FolderListTableViewController: BaseCategoryListTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Select folders", comment: "Select folders")
        
        list = FolderList()
        (list as! FolderList).blog = self.blog
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        actionMessage = NSLocalizedString("Fetch folders", comment: "Fetch folders")
        
        self.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.list[indexPath.row] as! Folder
        
        object.isDirty = true

        if let sel = selected[selectedItem.id] {
            selected[selectedItem.id] = !sel
        } else {
            selected[selectedItem.id] = true
        }
        for item in self.list.items {
            if item.id != selectedItem.id {
                selected[item.id] = false
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction override func saveButtonPushed(sender: UIBarButtonItem) {
        var selectedObjects = [BaseObject]()
        for (id, value) in selected {
            if value {
                if !id.isEmpty {
                    selectedObjects.append(list.objectWithID(id)!)
                }
            }
        }
        
        (object as! PageFolderItem).selected = selectedObjects as! [Folder]
        self.navigationController?.popViewControllerAnimated(true)
    }

}
