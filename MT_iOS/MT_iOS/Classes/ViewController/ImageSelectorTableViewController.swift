//
//  ImageSelectorTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/11.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class ImageSelectorTableViewController: AddAssetTableViewController, AssetSelectorDelegate {
    var object: EntryImageItem!
    var entry: BaseEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = NSLocalizedString("Photos", comment: "Photos")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        let user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser!
        switch indexPath.section {
        case Section.Buttons.rawValue:
            if let cameraButton = cell.viewWithTag(1) as? UIButton {
                cameraButton.enabled =  self.blog.canUpload(user: user)
            }
            
            if let libraryButton = cell.viewWithTag(2) as? UIButton {
                libraryButton.enabled =  self.blog.canUpload(user: user)
            }
            
            if let assetListButton = cell.viewWithTag(3) as? UIButton {
                if self.entry is Entry {
                    assetListButton.enabled =  self.blog.canListAssetForEntry(user: user)
                } else {
                    assetListButton.enabled =  self.blog.canListAssetForPage(user: user)
                }
            }
            
            return cell
        case Section.Items.rawValue:
            return cell
        default:
            break
        }
        
        // Configure the cell...
        
        return UITableViewCell()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction override func assetListButtonPushed(sender: UIButton) {
        let vc = AssetSelectorTableViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.blog = self.blog
        vc.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }

    func AssetSelectorDone(controller: AssetSelectorTableViewController, asset: Asset) {
        self.delegate?.AddAssetDone(self, asset: asset)
    }
}
