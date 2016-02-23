//
//  BlogImageSizeTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol BlogImageSizeDelegate {
    func blogImageSizeDone(controller: BlogImageSizeTableViewController, selected: Int, customWidth: Int)
}

class BlogImageSizeTableViewController: BaseTableViewController, UITextFieldDelegate {
    var selected = NOTSELECTED
    var customWidth = 0
    var delegate: BlogImageSizeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = NSLocalizedString("Image Size", comment: "Image Size")
        self.tableView.backgroundColor = Color.tableBg
        
        self.tableView.delaysContentTouches = false
        for case let view as UIScrollView in tableView.subviews {
            view.delaysContentTouches = false
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
        
        self.tableView.registerNib(UINib(nibName: "ImageSizeTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageSizeTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ImageCustomSizeTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageCustomSizeTableViewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        return Blog.ImageSize._Num.rawValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == Blog.ImageSize.Custom.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCustomSizeTableViewCell", forIndexPath: indexPath) as! ImageCustomSizeTableViewCell
            
            self.adjustCellLayoutMargins(cell)
            
            // Configure the cell...
            cell.nameLabel?.text = Blog.ImageSize(rawValue: indexPath.row)?.label()
            
            if self.customWidth > 0 {
                cell.sizeField.text = "\(self.customWidth)"
            }
            cell.sizeField.placeholder = NSLocalizedString("Any size", comment: "Any size")
            cell.sizeField.keyboardType = UIKeyboardType.NumberPad
            cell.sizeField.returnKeyType = UIReturnKeyType.Done
            cell.sizeField.autocorrectionType = UITextAutocorrectionType.No
            cell.sizeField.delegate = self
            cell.sizeField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            
            cell.checkIcon.hidden = (selected != indexPath.row)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageSizeTableViewCell", forIndexPath: indexPath) as! ImageSizeTableViewCell
            
            self.adjustCellLayoutMargins(cell)
            
            // Configure the cell...
            cell.nameLabel?.text = Blog.ImageSize(rawValue: indexPath.row)?.label()
            
            cell.sizeLabel?.text = Blog.ImageSize(rawValue: indexPath.row)?.pix()
            
            cell.checkIcon.hidden = (selected != indexPath.row)
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selected = indexPath.row
        
        if selected == Blog.ImageSize.Custom.rawValue {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ImageCustomSizeTableViewCell
            Utils.performAfterDelay({
                cell.sizeField.becomeFirstResponder()
                }, delayTime: 0.0)
        }
        
        self.tableView.reloadData()
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldChanged(field: UITextField) {
        if let text = field.text {
            if let width = Int(text) {
                if width > MAX_IMAGE_SIZE {
                    customWidth = MAX_IMAGE_SIZE
                    field.text = "\(customWidth)"
                } else {
                    customWidth = width
                }
            } else {
                customWidth = 0
            }
        }
    }
    
    @IBAction func doneButtonPushed(sender: AnyObject) {
        if selected == Blog.ImageSize.Custom.rawValue {
            if customWidth == 0 {
                let alertController = UIAlertController(
                    title: NSLocalizedString("Error", comment: "Error"),
                    message: NSLocalizedString("Please enter a custom size.", comment: "Please enter a custom size."),
                    preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default) {
                    action in
                    return
                }

                alertController.addAction(okAction)

                presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.blogImageSizeDone(self, selected: selected, customWidth: customWidth)
    }
}
