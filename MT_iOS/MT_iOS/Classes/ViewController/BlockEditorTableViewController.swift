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
    
    var noItemLabel = UILabel()
    var tophImage = UIImageView(image: UIImage(named: "guide_toph_sleep"))
    var guidanceBgView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = blocks.label

        items = [BaseEntryItem]()
        for block in blocks.blocks {
            if block is BlockImageItem {
                let item = BlockImageItem()
                item.asset = (block as! BlockImageItem).asset
                items.append(item)
            } else {
                let item = BlockTextItem()
                item.text = (block as! BlockTextItem).text
                items.append(item)
            }
        }
        
        self.tableView.registerNib(UINib(nibName: "TextBlockTableViewCell", bundle: nil), forCellReuseIdentifier: "TextBlockTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ImageBlockTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageBlockTableViewCell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "saveButtonPushed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arw"), left: true, target: self, action: "backButtonPushed:")

        self.view.addSubview(tophImage)
        tophImage.center = view.center
        var frame = tophImage.frame
        frame.origin.y = 109.0
        tophImage.frame = frame
        
        noItemLabel.textColor = Color.placeholderText
        noItemLabel.font = UIFont.systemFontOfSize(18.0)
        noItemLabel.text = String(format: NSLocalizedString("No %@", comment: "No %@"), arguments: [blocks.label])
        noItemLabel.sizeToFit()
        self.view.addSubview(noItemLabel)
        noItemLabel.center = view.center
        frame = noItemLabel.frame
        frame.origin.y = tophImage.frame.origin.y + tophImage.frame.size.height + 13.0
        noItemLabel.frame = frame
        
        tophImage.hidden = true
        noItemLabel.hidden = true
        
        guidanceBgView.backgroundColor = colorize(0x000000, alpha: 0.3)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        guidanceBgView.frame = app.window!.frame
        app.window!.addSubview(guidanceBgView)
        
        let guidanceView = BlockGuidanceView.instanceFromNib() as! BlockGuidanceView
        guidanceView.closeButton.addTarget(self, action: "guidanceCloseButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
        guidanceBgView.addSubview(guidanceView)
        guidanceView.center = guidanceBgView.center
        frame = guidanceView.frame
        frame.origin.y = 70.0
        guidanceView.frame = frame
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let showed = defaults.boolForKey("blocksGuidanceShowed")
        if showed {
            guidanceBgView.removeFromSuperview()
        }
                
        self.tableView.backgroundColor = Color.tableBg
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        tophImage.hidden = !(items.count == 0)
        noItemLabel.hidden = !(items.count == 0)

        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        // Configure the cell...
        let item = items[indexPath.row]
        
        if item.type == "textarea" {
            let c = tableView.dequeueReusableCellWithIdentifier("TextBlockTableViewCell", forIndexPath: indexPath) as! TextBlockTableViewCell
            let text = item.dispValue()
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
            let c = tableView.dequeueReusableCellWithIdentifier("ImageBlockTableViewCell", forIndexPath: indexPath) as! ImageBlockTableViewCell
            c.blockImageView.sd_setImageWithURL(NSURL(string: item.dispValue()))
            cell = c
        }
        
        self.adjustCellLayoutMargins(cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110.0
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
            vc.blog = blog
            vc.entry = entry
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
        blocks.isDirty = true
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func makeToolbarItems(editMode: Bool) {
        var buttons = [UIBarButtonItem]()
        if editMode {
            let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
            
            buttons = [flexible, doneButton]
        } else {
            let cameraButton = UIBarButtonItem(image: UIImage(named: "btn_camera"), left: true, target: self, action: "cameraButtonPushed:")
            let textAddButton = UIBarButtonItem(image: UIImage(named: "btn_textadd"), left: false, target: self, action: "textAddButtonPushed:")
            
            let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            let previewButton = UIBarButtonItem(image: UIImage(named: "btn_preview"), style: UIBarButtonItemStyle.Plain, target: self, action: "previewButtonPushed:")

            let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPushed:")
            
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
        let item = BlockImageItem()
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
        let item = BlockTextItem()
        item.label = NSLocalizedString("Text", comment: "Text")
        items.append(item)
        self.tableView.reloadData()
        
        self.showHTMLEditor(item)
    }
    
    @IBAction func previewButtonPushed(sender: UIBarButtonItem) {
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)
        let html = self.makeHTML()
        vc.html = html
        self.presentViewController(nav, animated: true, completion: nil)
    }

    func makeItemsHTML()-> String {
        var html = ""
        for item in items {
            if item is BlockImageItem {
                html += item.value() + "\n"
            } else {
                html += "<p>" + item.value() + "</p>" + "\n"
            }
        }
        return html
    }
    
    func makeHTML()-> String {
        var html = "<!DOCTYPE html><html><head><title>Preview</title><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"></head><body>"
        
        html += self.makeItemsHTML()

        html += "</body></html>"
        
        return html
    }
    
    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        if self.makeItemsHTML() == blocks.value() {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        Utils.confrimSave(self)
    }
    
    func guidanceCloseButtonPushed(sender: UIButton) {
        UIView.animateWithDuration(0.3,
            animations:
            {_ in
                self.guidanceBgView.alpha = 0.0
            },
            completion:
            {_ in
                self.guidanceBgView.removeFromSuperview()
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "blocksGuidanceShowed")
                defaults.synchronize()
            }
        )
    }

}
