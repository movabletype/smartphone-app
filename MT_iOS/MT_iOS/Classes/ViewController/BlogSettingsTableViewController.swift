//
//  BlogSettingsTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/26.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlogSettingsTableViewController: BaseTableViewController, BlogImageSizeDelegate, BlogImageQualityDelegate, BlogUploadDirDelegate {
    enum Item:Int {
        case UploadDir = 0,
        Size,
        Quality,
        _Num
    }
    
    var blog: Blog!
    
    var uploadDir = "/"
    var imageSize = Blog.ImageSize.M
    var imageQuality = Blog.ImageQuality.Normal

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = NSLocalizedString("Settings", comment: "Settings")
        
        self.tableView.backgroundColor = Color.tableBg
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")

        uploadDir = blog.uploadDir
        imageSize = blog.imageSize
        imageQuality = blog.imageQuality
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
        return Item._Num.rawValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        self.adjustCellLayoutMargins(cell)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = Color.black
        cell.textLabel?.font = UIFont.systemFontOfSize(18.0)
        cell.detailTextLabel?.textColor = Color.black
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(16.0)
        
        switch indexPath.row {
        case Item.UploadDir.rawValue:
            cell.textLabel?.text = NSLocalizedString("Upload Dir", comment: "Upload Dir")
            cell.imageView?.image = UIImage(named: "ico_upload")
            cell.detailTextLabel?.text = uploadDir
        case Item.Size.rawValue:
            cell.textLabel?.text = NSLocalizedString("Image Size", comment: "Image Size")
            cell.imageView?.image = UIImage(named: "ico_size")
            cell.detailTextLabel?.text = imageSize.label() + "(" + imageSize.pix() + ")"
        case Item.Quality.rawValue:
            cell.textLabel?.text = NSLocalizedString("Image Quality", comment: "Image Quality")
            cell.imageView?.image = UIImage(named: "ico_quality")
            cell.detailTextLabel?.text = imageQuality.label()
        default:
            cell.textLabel?.text = ""
        }
        
        // Configure the cell...
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58.0
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case Item.UploadDir.rawValue:
            let storyboard: UIStoryboard = UIStoryboard(name: "BlogUploadDir", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! BlogUploadDirTableViewController
            vc.directory = uploadDir
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.Size.rawValue:
            let storyboard: UIStoryboard = UIStoryboard(name: "BlogImageSize", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! BlogImageSizeTableViewController
            vc.selected = imageSize.rawValue
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.Quality.rawValue:
            let storyboard: UIStoryboard = UIStoryboard(name: "BlogImageQuality", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! BlogImageQualityTableViewController
            vc.selected = imageQuality.rawValue
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeButtonPushed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPushed(sender: AnyObject) {
        blog.uploadDir = uploadDir
        blog.imageSize = imageSize
        blog.imageQuality = imageQuality
        blog.saveSettings()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func blogImageSizeDone(controller: BlogImageSizeTableViewController, selected: Int) {
        imageSize = Blog.ImageSize(rawValue: selected)!
        self.tableView.reloadData()
    }
    
    func blogImageQualityDone(controller: BlogImageQualityTableViewController, selected: Int) {
        imageQuality = Blog.ImageQuality(rawValue: selected)!
        self.tableView.reloadData()
    }
    
    func blogUploadDirDone(controller: BlogUploadDirTableViewController, directory: String) {
        uploadDir = directory
        self.tableView.reloadData()
    }


}
