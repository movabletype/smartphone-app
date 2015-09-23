//
//  BlogUploadDirTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/10.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol BlogUploadDirDelegate {
    func blogUploadDirDone(controller: BlogUploadDirTableViewController, directory: String)
}


class BlogUploadDirTableViewController: BaseTableViewController {

    var directory = ""
    var delegate: BlogUploadDirDelegate?
    var field: UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = NSLocalizedString("Upload Dir", comment: "Upload Dir")
        self.tableView.backgroundColor = Color.tableBg
        
        if directory.hasPrefix("/") {
            directory = (directory as NSString).substringFromIndex(1)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
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
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) 

        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        field = cell.viewWithTag(99) as? UITextField
        field?.keyboardType = UIKeyboardType.URL
        field?.text = directory
        field?.becomeFirstResponder()

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.frame.size.width, self.tableView(tableView, heightForHeaderInSection: 0)))
        let label = UILabel(frame: CGRectMake(10.0, 0.0, header.frame.size.width - 10.0 * 2, header.frame.size.height))
        label.text = NSLocalizedString("Upload Directory", comment: "Upload Directory")
        label.textColor = Color.placeholderText
        label.font = UIFont.systemFontOfSize(15.0)
        header.addSubview(label)
        
        return header
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
    
    @IBAction func doneButtonPushed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        if field != nil {
            var dir = field!.text
            if !dir!.hasPrefix("/") {
                dir = "/" + dir!
            }
            delegate?.blogUploadDirDone(self, directory: dir!)
        }
    }

}
