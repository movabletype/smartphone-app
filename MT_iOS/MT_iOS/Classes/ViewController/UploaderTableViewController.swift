//
//  UploaderTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/09.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

protocol UploaderTableViewControllerDelegate {
    func UploaderFinish(controller: UploaderTableViewController)
}

class UploaderTableViewController: BaseTableViewController {
    var uploader: MultiUploader!
    var delegate: UploaderTableViewControllerDelegate?

    var progress: ((UploadItem, Float)-> Void)!
    var success: (Int-> Void)!
    var failure: ((Int, JSON) -> Void)!
    
    let IMAGE_SIZE: CGFloat = 44.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = NSLocalizedString("Uploader", comment: "Uploader")
        
        self.tableView.registerNib(UINib(nibName: "UploaderTableViewCell", bundle: nil), forCellReuseIdentifier: "UploaderTableViewCell")
        
        self.progress = {
            (item: UploadItem, progress: Float) in
            self.tableView.reloadData()
        }
        self.success = {
            (processed: Int) in
            
            self.delegate?.UploaderFinish(self)
        }
        self.failure = {
            (processed: Int, error: JSON) in
            
            self.uploadError(error)
            self.tableView.reloadData()
        }

        self.uploader.start(progress: self.progress, success: self.success, failure: self.failure)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return uploader.count()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UploaderTableViewCell", forIndexPath: indexPath) as! UploaderTableViewCell

        // Configure the cell...
        let item = self.uploader.items[indexPath.row]
        cell.uploaded = item.uploaded
        cell.progress = item.progress
        cell.nameLabel.text = ""
        if item is UploadItemImage {
            cell.nameLabel.text = item.filename
        }
        item.thumbnail(CGSize(width: IMAGE_SIZE, height: IMAGE_SIZE),
            completion: { image in
                cell.thumbView.image = image
            }
        )
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IMAGE_SIZE
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func uploadRestart() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Image upload", comment: "Image upload"),
            message: NSLocalizedString("There is the rest of the items , you sure that you want to upload again ?", comment: "There is the rest of the items , you sure that you want to upload again ?"),
            preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: "YES"), style: .Default) {
            action in
            
            self.uploader.restart(progress: self.progress, success: self.success, failure: self.failure)
        }
        let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: "NO"), style: .Default) {
            action in
            self.delegate?.UploaderFinish(self)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func uploadError(error: JSON) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Upload error", comment: "Upload error"),
            message: error["message"].stringValue,
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default) {
            action in
            if self.uploader.queueCount() > 0 {
                self.uploadRestart()
            }
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
