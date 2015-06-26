//
//  PageDraftTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/11.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class PageDraftTableViewController: BaseDraftTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = NSLocalizedString("Pages of unsent", comment: "Pages of unsent")
        
        let user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser!
        if self.blog.canCreatePage(user: user) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_newentry"), left: false, target: self, action: "composeButtonPushed:")
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
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
    
    // MARK: - Table view delegte
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filename = self.files[indexPath.row]
        let dir = self.dataDir()
        let path = dir.stringByAppendingPathComponent(filename)
        let item = EntryItemList.loadFromFile(path, filename: filename)
        item.blog = blog
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let vc = PageDetailTableViewController()
        vc.list = item
        vc.object = item.object
        vc.blog = blog
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: -
    func composeButtonPushed(sender: UIBarButtonItem) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.createPage(self.blog, controller: self)
    }

}
