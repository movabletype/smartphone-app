//
//  BaseEntryDetailTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import ZSSRichTextEditor
import SwiftyJSON
import SVProgressHUD

class BaseEntryDetailTableViewController: BaseTableViewController, EntrySettingDelegate, DatePickerViewControllerDelegate, AddAssetDelegate {
    var object: BaseEntry!
    var blog: Blog!
    var list: EntryItemList?
    var selectedIndexPath: NSIndexPath?
    
    let headerHeight: CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = object.title
    
        self.navigationController?.toolbar.barTintColor = Color.navBar
        self.navigationController?.toolbar.tintColor = Color.navBarTint
        
        self.tableView.backgroundColor = Color.tableBg
        
        if list == nil {
            list = EntryItemList(blog: blog, object: object)
        }
        
        self.tableView.registerNib(UINib(nibName: "EntryPermalinkTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryPermalinkTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryTextTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryTextTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryBasicTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryCheckboxTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "EntrySelectTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryRadioTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryStatusTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryTextAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryTextAreaTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryImageTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryImageTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EntryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryHeaderTableViewCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")
        
        if object.id.isEmpty && list!.filename.isEmpty {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arw"), left: true, target: self, action: "backButtonPushed:")
        }
    }
    
    private func makeToolbarItems() {
        var buttons = [UIBarButtonItem]()
        var settingsButtonPushed = UIBarButtonItem(image: UIImage(named: "btn_entry_setting"), left: true, target: self, action: "settingsButtonPushed:")
        
        var flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var previewButton = UIBarButtonItem(image: UIImage(named: "btn_preview"), style: UIBarButtonItemStyle.Plain, target: self, action: "previewButtonPushed:")
        
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPushed:")
            
        buttons = [settingsButtonPushed, flexible, previewButton, editButton]
        
        self.setToolbarItems(buttons, animated: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.makeToolbarItems()
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
        if let list = self.list {
            return list.count + 1
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let list = self.list {
            if section == 0 {
                return 1
            }
            
            let item = list[section - 1]
            
            if item.type == "textarea" || item.type == "image" || item.type == "embed" || item.type == "blocks"  {
                return 2
            } else {
                return 1
            }
            
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let list = self.list {
            if indexPath.section == 0 {
                if object.permalink.isEmpty {
                    return 0.0
                }
                return 44.0
            }

            let item = list[indexPath.section - 1]
            
            if item.type == "text" {
                return 58.0
            } else if item.type == "title" {
                return 58.0
            } else if item.type == "textarea" || item.type == "embed" || item.type == "blocks" {
                if indexPath.row == 0 {
                    return headerHeight
                } else {
                    return 90.0
                }
            } else if item.type == "checkbox" {
                return 58.0
            } else if item.type == "url" {
                return 58.0
            } else if item.type == "datetime" || item.type == "date" || item.type == "time"  {
                return 58.0
            } else if item.type == "select" {
                return 58.0
            } else if item.type == "radio" {
                return 58.0
            } else if item.type == "image" {
                if indexPath.row == 0 {
                    return headerHeight
                } else {
                    return 90.0
                }
            } else if item.type == "status" {
                return 53.0
            } else if item.type == "category" || item.type == "folder" {
                return 58.0
            }
            
            return 58.0
        }
        
        return 0.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let list = self.list {
            if indexPath.section == 0 {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryPermalinkTableViewCell", forIndexPath: indexPath) as! EntryPermalinkTableViewCell
                self.adjustCellLayoutMargins(c)
                c.iconImageView.hidden = object.permalink.isEmpty
                c.permalinkLabel.text = object.permalink
                c.backgroundColor = Color.tableBg
                
                if object.status == Entry.Status.Publish.text() {
                    c.permalinkLabel.textColor = Color.linkText
                } else {
                    c.permalinkLabel.textColor = Color.placeholderText
                }

                return c
            }

            let item = list[indexPath.section - 1]
            
            var cell = UITableViewCell()
            
            if item.type == "title" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryTextTableViewCell", forIndexPath: indexPath) as! EntryTextTableViewCell
                var text = item.dispValue()
                if text.isEmpty {
                    c.textLabel?.text = (item as! EntryTextItem).placeholder()
                    c.textLabel?.textColor = Color.placeholderText
                } else {
                    c.textLabel?.text = text
                    c.textLabel?.textColor = Color.black
                }
                cell = c
            } else if item.type == "text" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c

            } else if item.type == "textarea" || item.type == "embed" {
                if indexPath.row == 0 {
                    var c = tableView.dequeueReusableCellWithIdentifier("EntryHeaderTableViewCell", forIndexPath: indexPath) as! EntryHeaderTableViewCell
                    c.textLabel?.text = item.label
                    c.backgroundColor = Color.tableBg
                    c.selectionStyle = UITableViewCellSelectionStyle.None
                    cell = c
                } else {
                    var c = tableView.dequeueReusableCellWithIdentifier("EntryTextAreaTableViewCell", forIndexPath: indexPath) as! EntryTextAreaTableViewCell
                    var text = item.dispValue()
                    if text.isEmpty {
                        c.placeholderLabel?.text = (item as! EntryTextAreaItem).placeholder()
                        c.placeholderLabel.hidden = false
                        c.textareaLabel.hidden = true
                    } else {
                        c.textareaLabel?.text = Utils.removeHTMLTags(text)
                        c.placeholderLabel.hidden = true
                        c.textareaLabel.hidden = false
                    }
                    cell = c
                }
            } else if item.type == "blocks" {
                if indexPath.row == 0 {
                    var c = tableView.dequeueReusableCellWithIdentifier("EntryHeaderTableViewCell", forIndexPath: indexPath) as! EntryHeaderTableViewCell
                    c.textLabel?.text = item.label
                    c.backgroundColor = Color.tableBg
                    c.selectionStyle = UITableViewCellSelectionStyle.None
                    cell = c
                } else {
                    let blockItem = item as! EntryBlocksItem
                    if blockItem.isImageCell() {
                        var c = tableView.dequeueReusableCellWithIdentifier("EntryImageTableViewCell", forIndexPath: indexPath) as! EntryImageTableViewCell
                        c.assetImageView.sd_setImageWithURL(NSURL(string: blockItem.dispValue()))
                        cell = c
                    } else {
                        var c = tableView.dequeueReusableCellWithIdentifier("EntryTextAreaTableViewCell", forIndexPath: indexPath) as! EntryTextAreaTableViewCell
                        var text = blockItem.dispValue()
                        if text.isEmpty {
                            c.placeholderLabel?.text = blockItem.placeholder()
                            c.placeholderLabel.hidden = false
                            c.textareaLabel.hidden = true
                        } else {
                            c.textareaLabel?.text = Utils.removeHTMLTags(text)
                            c.placeholderLabel.hidden = true
                            c.textareaLabel.hidden = false
                        }
                        cell = c
                    }
                    
                }
            } else if item.type == "checkbox" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryCheckboxTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = ""
                var switchCtrl = UISwitch()
                switchCtrl.tag = indexPath.section
                switchCtrl.on = (item.dispValue() == "true")
                switchCtrl.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
                c.accessoryView = switchCtrl
                c.selectionStyle = UITableViewCellSelectionStyle.None
                cell = c
            } else if item.type == "url" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c
            } else if item.type == "datetime" || item.type == "date" || item.type == "time"  {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c
            } else if item.type == "select" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntrySelectTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c
            } else if item.type == "radio" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryRadioTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c
            } else if item.type == "image" {
                if indexPath.row == 0 {
                    var c = tableView.dequeueReusableCellWithIdentifier("EntryHeaderTableViewCell", forIndexPath: indexPath) as! EntryHeaderTableViewCell
                    c.textLabel?.text = item.label
                    c.backgroundColor = Color.tableBg
                    c.selectionStyle = UITableViewCellSelectionStyle.None
                    cell = c
                } else {
                    var c = tableView.dequeueReusableCellWithIdentifier("EntryImageTableViewCell", forIndexPath: indexPath) as! EntryImageTableViewCell
                    c.assetImageView.sd_setImageWithURL(NSURL(string: item.dispValue()))
                    cell = c
                }
            } else if item.type == "status" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryStatusTableViewCell", forIndexPath: indexPath) as! EntryStatusTableViewCell
                let status = item as! EntryStatusItem
                c.segmentedControl.selectedSegmentIndex = status.selected
                c.segmentedControl.tag = indexPath.section
                c.segmentedControl.addTarget(self, action: "statusChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                if object is Entry {
                    if !blog.canPublishEntry() {
                        c.segmentedControl.setEnabled(false, forSegmentAtIndex: Entry.Status.Publish.rawValue)
                        c.segmentedControl.setEnabled(true, forSegmentAtIndex: Entry.Status.Draft.rawValue)
                        c.segmentedControl.setEnabled(false, forSegmentAtIndex: Entry.Status.Future.rawValue)
                        c.segmentedControl.selectedSegmentIndex = Entry.Status.Draft.rawValue
                    }
                }
                
                cell = c
            } else if item.type == "category" || item.type == "folder" {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c
            } else {
                var c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                cell = c
            }
            
            self.adjustCellLayoutMargins(cell)
            
            return cell
        }

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
    
    private func showTextEditor(object: EntryTextItem) {
        let vc = EntryTextEditorViewController()
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showHTMLEditor(object: EntryTextAreaItem) {
        if self.object.editMode == Entry.EditMode.PlainText || !self.object.id.isEmpty {
            let vc = EntryHTMLEditorViewController()
            vc.object = object
            vc.blog = blog
            vc.entry = self.object
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = EntryRichTextViewController()
            vc.object = object
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showSelector(object: EntrySelectItem) {
        let vc = EntrySelectTableViewController()
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showCategorySelector(object: BaseEntryItem) {
        let vc = CategoryListTableViewController()
        vc.blog = blog
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showFolderSelector(object: BaseEntryItem) {
        let vc = FolderListTableViewController()
        vc.blog = blog
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func showBlockEditor(item: EntryBlocksItem) {
        let vc = BlockEditorTableViewController()
        vc.blog = blog
        vc.blocks = item
        vc.entry = self.object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showDatePicker(object: BaseEntryItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! DatePickerViewController

        var date: NSDate?
        if object is EntryDateTimeItem {
            date = (object as! EntryDateTimeItem).datetime
            vc.initialMode = .DateTime
        } else if object is EntryDateItem {
            date = (object as! EntryDateItem).date
            vc.initialMode = .Date
        } else if object is EntryTimeItem {
            date = (object as! EntryTimeItem).time
            vc.initialMode = .Time
        }
        
        if date == nil {
            date = NSDate()
        }

        vc.navTitle = object.label
        vc.date = date!
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func datePickerDone(controller: DatePickerViewController, date: NSDate) {
        if selectedIndexPath == nil {
            return
        }
        
        if let list = self.list {
            let item = list[selectedIndexPath!.section - 1]
            if item is EntryDateTimeItem {
                (item as! EntryDateTimeItem).datetime = date
            } else if item is EntryDateItem {
                (item as! EntryDateItem).date = date
            } else if item is EntryTimeItem {
                (item as! EntryTimeItem).time = date
            }
        }
        
        self.tableView.reloadData()
    }
    
    func switchChanged(sender: UISwitch) {
        if let list = self.list {
            let item = list[sender.tag - 1]
            if item is EntryCheckboxItem {
                (item as! EntryCheckboxItem).checked = sender.on
            }
        }
    }
    
    func statusChanged(sender: UISegmentedControl) {
        if let list = self.list {
            let item = list[sender.tag - 1]
            if item is EntryStatusItem {
                (item as! EntryStatusItem).selected = sender.selectedSegmentIndex
            }
        }
    }
    
    private func showAssetSelector(item: EntryImageItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ImageSelector", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! ImageSelectorTableViewController
        vc.blog = blog
        vc.delegate = self
        vc.showAlign = true
        vc.object = item
        vc.entry = self.object
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    private func imageAction(item: EntryImageItem) {
        if item.dispValue().isEmpty {
            self.showAssetSelector(item)
        }
        
        let actionSheet: UIAlertController = UIAlertController(title:item.label,
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                LOG("cancelAction")
            }
        )
        
        let selectAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Select Image", comment: "Select Image"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                self.showAssetSelector(item)
            }
        )
        
        let deleteAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Delete Image", comment: "Delete Image"),
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction!) -> Void in
                item.clear()
                self.tableView.reloadData()
            }
        )
        
        actionSheet.addAction(selectAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        if let list = self.list {
            if indexPath.section == 0 {
                if object.status == Entry.Status.Publish.text() {
                    let vc = PreviewViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    vc.url = object.permalink
                    self.presentViewController(nav, animated: true, completion: nil)
                }
                return
            }
            
            let item = list[indexPath.section - 1]

            if item.type == "title" {
                self.showTextEditor(item as! EntryTextItem)
            } else if item.type == "text" {
                self.showTextEditor(item as! EntryTextItem)
            } else if item.type == "textarea" || item.type == "embed"  {
                if indexPath.row == 0 {
                    // Do nothing
                    return
                } else {
                    self.showHTMLEditor(item as! EntryTextAreaItem)
                }
            } else if item.type == "blocks" {
                self.showBlockEditor(item as! EntryBlocksItem)
            } else if item.type == "checkbox" {
                // Do nothing
            } else if item.type == "url" {
                self.showTextEditor(item as! EntryURLItem)
            } else if item.type == "datetime" || item.type == "date" || item.type == "time" {
                self.showDatePicker(item)
            } else if item.type == "select" {
                self.showSelector(item as! EntrySelectItem)
            } else if item.type == "radio" {
                self.showSelector(item as! EntryRadioItem)
            } else if item.type == "image" {
                self.imageAction(item as! EntryImageItem)
            } else if item.type == "status" {
                // Do nothing
            } else if item.type == "category" {
                self.showCategorySelector(item as! EntryCategoryItem)
            } else if item.type == "folder" {
                self.showFolderSelector(item as! PageFolderItem)
            } else {
            }
        }
    }
    
    @IBAction func settingsButtonPushed(sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "EntrySetting", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! EntrySettingTableViewController
        vc.object = object
        vc.blog = blog
        vc.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    private func preview() {
        let json = self.makeParams()
        if json == nil {
            return
        }
        
        let isEntry = object is Entry
        let blogID = blog.id
        let id: String? = object.id.isEmpty ? nil : object.id
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: (JSON!-> Void) = {
            (result: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            let url = result["preview"].stringValue
            
            let vc = PreviewViewController()
            let nav = UINavigationController(rootViewController: vc)
            vc.url = url
            self.presentViewController(nav, animated: true, completion: nil)
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Make preview...", comment: "Make preview..."))
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                if isEntry {
                    api.previewEntry(siteID: blogID, entryID: id, entry: json, success: success, failure: failure)
                } else {
                    api.previewPage(siteID: blogID, pageID: id, entry: json, success: success, failure: failure)
                }
            },
            failure: failure
        )
    }
    
    @IBAction func previewButtonPushed(sender: UIBarButtonItem) {
        self.preview()
    }
    
    @IBAction func editButtonPushed(sender: UIBarButtonItem) {
        let vc = EntryItemListTableViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.list = list
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    private func makeParams()-> [String:AnyObject]? {
        var params = list?.makeParams()
        if params != nil {
            //新規作成時にカテゴリ未選択なら送信しない
            if object.id.isEmpty {
                if let categories = params!["categories"] as? [[String: String]] {
                    if categories.count == 0 {
                        params?.removeValueForKey("categories")
                    }
                }
            }
            
            //id
            if !object.id.isEmpty {
                params!["id"] = object.id
            }
            
            //Tags
            var tags = [String]()
            for tag in object.tags {
                tags.append(tag.name)
            }
            params!["tags"] = tags
            
            //PublishDate
            if object.date != nil {
                params!["date"] = Utils.ISO8601StringFromDate(object.date!)
            }
            
            //UnpublishDate
            if object.unpublishedDate != nil {
                params!["unpublishedDate"] = Utils.ISO8601StringFromDate(object.unpublishedDate!)
            }
            
            return params!
        }
        return nil
    }
    
    private func saveEntry() {
        let json = self.makeParams()
        if json == nil {
            return
        }
        
        let create = object.id.isEmpty
        let isEntry = object is Entry
        
        let blogID = blog.id
        var id = object.id
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: (JSON!-> Void) = {
            (result: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            self.list!.removeDraftData()
            
            var newObject: BaseEntry
            if isEntry {
                newObject = Entry(json: result)
            } else {
                newObject = Page(json: result)
            }

            self.object = newObject
            
            self.title = self.object.title
            
            self.list = EntryItemList(blog: self.blog, object: self.object)
            
            self.tableView.reloadData()
            self.makeToolbarItems()
            
            SVProgressHUD.showSuccessWithStatus(NSLocalizedString("Success", comment: "Success"))
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Save...", comment: "Save..."))

        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                if create {
                    if isEntry {
                        api.createEntry(siteID: blogID, entry: json!, success: success, failure: failure)
                    } else {
                        api.createPage(siteID: blogID, page: json!, success: success, failure: failure)
                    }
                } else {
                    if isEntry {
                        api.updateEntry(siteID: blogID, entryID: id, entry: json!, success: success, failure: failure)
                    } else {
                        api.updatePage(siteID: blogID, pageID: id, page: json!, success: success, failure: failure)
                    }
                }
            },
            failure: failure
        )
    }
    
    private func checkModified() {
        let id = self.object.id
        if id.isEmpty {
            self.saveEntry()
        }

        let blogID = blog.id
        let isEntry = object is Entry

        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: (JSON!-> Void) = {
            (result: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            var newObject: BaseEntry
            if isEntry {
                newObject = Entry(json: result)
            } else {
                newObject = Page(json: result)
            }
            
            if newObject.modifiedDate?.compare(self.object.modifiedDate!) != .OrderedSame {
                let alertController = UIAlertController(
                    title: NSLocalizedString("Caution", comment: "Caution"),
                    message: NSLocalizedString("Data on the server seems to be new . Do you want to overwrite it ?", comment: "Data on the server seems to be new . Do you want to overwrite it ?"),
                    preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Destructive) {
                    action in
                    self.saveEntry()
                }
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {
                    action in
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.saveEntry()
            }
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Check modified at...", comment: "Check modified at..."))
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                if isEntry {
                    api.getEntry(siteID: blogID, entryID: id, success: success, failure: failure)
                } else {
                    api.getPage(siteID: blogID, pageID: id, success: success, failure: failure)
                }
            },
            failure: failure
        )

    }
    
    private func saveLocal() {
        if let titleItem = self.list!.itemWithID("title", isCustomField: false) {
            self.object.title = titleItem.value()
            self.title = titleItem.value()
        }
        let success = self.list!.saveToFile()
        if !success {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("Save failed", comment: "Save failed"))
        } else {
            SVProgressHUD.showSuccessWithStatus(NSLocalizedString("Success", comment: "Success"))
        }
    }
    
    @IBAction func saveButtonPushed(sender: UIBarButtonItem) {
        if let item = list!.requiredCheck() {
            let message = String(format: NSLocalizedString("Please enter some value for required '%@' field.", comment: "Please enter some value for required '%@' field."), arguments: [item.label])
            let alertController = UIAlertController(
                title: NSLocalizedString("Error", comment: "Error"),
                message: message,
                preferredStyle: .Alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default) {
                action in
            }
            
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let actionSheet: UIAlertController = UIAlertController(title:NSLocalizedString("Submit", comment: "Submit"),
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                LOG("cancelAction")
            }
        )
        
        let submitAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                
                if self.object.id.isEmpty {
                    self.saveEntry()
                } else {
                    self.checkModified()
                }
            }
        )
        
        let saveLocalAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Save Local", comment: "Save Local"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                self.saveLocal()
            }
        )
        
        actionSheet.addAction(submitAction)
        actionSheet.addAction(saveLocalAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - EntrySettingDelegate
    func entrySettingCancel(controller: EntrySettingTableViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func entrySettingDone(controller: EntrySettingTableViewController, object: BaseEntry) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func deleteEntry(object: BaseEntry) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if object is Entry {
            SVProgressHUD.showWithStatus(NSLocalizedString("Delete Entry...", comment: "Delete Entry..."))
        } else {
            SVProgressHUD.showWithStatus(NSLocalizedString("Delete Page...", comment: "Delete Page..."))
        }
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: ((JSON!)-> Void) = {
            (result: JSON!)-> Void in
            LOG("\(result)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
        }
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                if object is Entry {
                    api.deleteEntry(siteID: self.blog.id, entryID: object.id, success: success, failure: failure)
                } else {
                    api.deletePage(siteID: self.blog.id, pageID: object.id, success: success, failure: failure)
                }
            },
            failure: failure
        )
    }
    
    private func deleteDraft() {
        self.list!.removeDraftData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func entrySettingDelete(controller: EntrySettingTableViewController, object: BaseEntry) {
        self.dismissViewControllerAnimated(false, completion:
            {_ in
                if self.list!.filename.isEmpty {
                    self.deleteEntry(object)
                } else {
                    self.deleteDraft()
                }
            }
        )
    }
    
    func AddAssetDone(controller: AddAssetTableViewController, asset: Asset) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let vc = controller as! ImageSelectorTableViewController
        let item = vc.object
        item.asset = asset
        self.tableView.reloadData()
    }
    
    @IBAction func closeButtonPushed(sender: AnyObject) {
        Utils.confrimSave(self, dismiss: true)
    }
    
    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        Utils.confrimSave(self)
    }
}
