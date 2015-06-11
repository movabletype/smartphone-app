//
//  BlockEditorTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/10.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class BlockEditorTableViewController: BaseTableViewController, AddAssetDelegate {
    var blog: Blog!
    var entry: BaseEntry!
    var blocks: EntryBlocksItem!
    var items: [BaseEntryItem]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = blocks.label

        items = blocks.blocks
        
        self.tableView.registerNib(UINib(nibName: "TextBlockTableViewCell", bundle: nil), forCellReuseIdentifier: "TextBlockTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ImageBlockTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageBlockTableViewCell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")
        
        self.tableView.backgroundColor = Color.tableBg
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.makeToolbarItems(false)
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if items == nil {
            return 0
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if items == nil {
            return 0
        }
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        // Configure the cell...
        let item = items[indexPath.row]
        
        if item.type == "textarea" {
            var c = tableView.dequeueReusableCellWithIdentifier("TextBlockTableViewCell", forIndexPath: indexPath) as! TextBlockTableViewCell
            var text = item.dispValue()
            if text.isEmpty {
                c.placeholderLabel?.text = (item as! EntryTextAreaItem).placeholder()
                c.placeholderLabel.hidden = false
                c.blockTextLabel.hidden = true
            } else {
                c.blockTextLabel?.text = Utils.removeHTMLTags(text)
                c.placeholderLabel.hidden = true
                c.blockTextLabel.hidden = false
            }
            cell = c
        } else {
            var c = tableView.dequeueReusableCellWithIdentifier("ImageBlockTableViewCell", forIndexPath: indexPath) as! ImageBlockTableViewCell
            c.blockImageView.sd_setImageWithURL(NSURL(string: item.dispValue()))
            cell = c
        }
        
        self.adjustCellLayoutMargins(cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

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

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = items[sourceIndexPath.row];
        items.removeAtIndex(sourceIndexPath.row);
        items.insert(item, atIndex: destinationIndexPath.row)
    }
    
    private func showHTMLEditor(object: EntryTextAreaItem) {
        if self.entry.editMode == Entry.EditMode.PlainText {
            let vc = EntryHTMLEditorViewController()
            vc.object = object
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = EntryRichTextViewController()
            vc.object = object
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showAssetSelector(object: EntryImageItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ImageSelector", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! ImageSelectorTableViewController
        vc.blog = blog
        vc.delegate = self
        vc.showAlign = true
        vc.object = object
        vc.entry = self.entry
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let items = self.items {
            let item = items[indexPath.row]
            
            if item.type == "textarea"  {
                self.showHTMLEditor(item as! EntryTextAreaItem)
            } else if item.type == "image" {
                self.showAssetSelector(item as! EntryImageItem)
            }
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
    
    @IBAction func saveButtonPushed(sender: UIBarButtonItem) {
        blocks.blocks = self.items
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func makeToolbarItems(editMode: Bool) {
        var buttons = [UIBarButtonItem]()
        if editMode {
            var flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
            
            buttons = [flexible, doneButton]
        } else {
            var cameraButton = UIBarButtonItem(image: UIImage(named: "btn_camera"), left: true, target: self, action: "cameraButtonPushed:")
            var textAddButton = UIBarButtonItem(image: UIImage(named: "btn_textadd"), left: false, target: self, action: "textAddButtonPushed:")
            
            var flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            var previewButton = UIBarButtonItem(image: UIImage(named: "btn_preview"), style: UIBarButtonItemStyle.Plain, target: self, action: "previewButtonPushed:")

            var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPushed:")
            
            buttons = [cameraButton, textAddButton, flexible, previewButton, editButton]

        }
        
        self.setToolbarItems(buttons, animated: true)
    }

    @IBAction func editButtonPushed(sender: UIBarButtonItem) {
        self.tableView.setEditing(true, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.makeToolbarItems(true)
    }

    @IBAction func doneButtonPushed(sender: UIBarButtonItem) {
        self.tableView.setEditing(false, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.makeToolbarItems(false)
    }
    
    @IBAction func cameraButtonPushed(sender: UIBarButtonItem) {
        var item = BlockImageItem()
        item.label = NSLocalizedString("Image", comment: "Image")
        items.append(item)
        self.tableView.reloadData()

        self.showAssetSelector(item)
    }
    
    func AddAssetDone(controller: AddAssetTableViewController, asset: Asset) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let vc = controller as! ImageSelectorTableViewController
        let item = vc.object
        item.asset = asset
        (item as! BlockImageItem).align = controller.imageAlign
        self.tableView.reloadData()
    }
    
    @IBAction func textAddButtonPushed(sender: UIBarButtonItem) {
        var item = BlockTextItem()
        item.label = NSLocalizedString("Text", comment: "Text")
        items.append(item)
        self.tableView.reloadData()
        
        self.showHTMLEditor(item)
    }
    
    @IBAction func previewButtonPushed(sender: UIBarButtonItem) {
        //TODO:
    }
}
