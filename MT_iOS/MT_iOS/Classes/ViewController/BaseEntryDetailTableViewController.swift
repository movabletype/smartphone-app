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

class stringArray {
    var items = [String]()
}

class BaseEntryDetailTableViewController: BaseTableViewController, EntrySettingDelegate, DatePickerViewControllerDelegate, AddAssetDelegate, UploaderTableViewControllerDelegate {
    var object: BaseEntry!
    var blog: Blog!
    var list: EntryItemList?
    var selectedIndexPath: NSIndexPath?
    var addedImageFiles = stringArray()
    
    let headerHeight: CGFloat = 30.0
    
    var uploader = MultiUploader()
    
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
        
        self.getDetail()
    }
    
    private func makeToolbarItems() {
        var buttons = [UIBarButtonItem]()
        let settingsButtonPushed = UIBarButtonItem(image: UIImage(named: "btn_entry_setting"), left: true, target: self, action: "settingsButtonPushed:")
        
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let previewButton = UIBarButtonItem(image: UIImage(named: "btn_preview"), style: UIBarButtonItemStyle.Plain, target: self, action: "previewButtonPushed:")
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPushed:")
            
        buttons = [settingsButtonPushed, flexible, previewButton, editButton]
        
        self.setToolbarItems(buttons, animated: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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

    private func getDetail() {
        let id = self.object.id
        if id.isEmpty {
            //新規作成の時
            return
        }
        if !list!.filename.isEmpty {
            //ローカル読み出しの時
            return
        }
        
        let blogID = blog.id
        let isEntry = object is Entry
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        let success: (JSON!-> Void) = {
            (result: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            var newObject: BaseEntry
            if isEntry {
                newObject = Entry(json: result)
            } else {
                newObject = Page(json: result)
            }
            
            LOG("\(result)")

            self.object = newObject
            self.list = EntryItemList(blog: self.blog, object: self.object)
            
            self.tableView.reloadData()
        }
        let failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Get detail...", comment: "Get detail..."))
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                let params = ["no_text_filter":"1"]
                if isEntry {
                    api.getEntry(siteID: blogID, entryID: id, options: params, success: success, failure: failure)
                } else {
                    api.getPage(siteID: blogID, pageID: id, options: params, success: success, failure: failure)
                }
            },
            failure: failure
        )
        
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
                return 58.0
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
                let c = tableView.dequeueReusableCellWithIdentifier("EntryPermalinkTableViewCell", forIndexPath: indexPath) as! EntryPermalinkTableViewCell
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
                let c = tableView.dequeueReusableCellWithIdentifier("EntryTextTableViewCell", forIndexPath: indexPath) as! EntryTextTableViewCell
                let text = item.dispValue()
                if text.isEmpty {
                    c.textLabel?.text = (item as! EntryTextItem).placeholder()
                    c.textLabel?.textColor = Color.placeholderText
                } else {
                    c.textLabel?.text = text
                    c.textLabel?.textColor = Color.black
                }
                cell = c
            } else if item.type == "text" {
                let c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c

            } else if item.type == "textarea" || item.type == "embed" {
                if indexPath.row == 0 {
                    let c = tableView.dequeueReusableCellWithIdentifier("EntryHeaderTableViewCell", forIndexPath: indexPath) as! EntryHeaderTableViewCell
                    c.textLabel?.text = item.label
                    c.backgroundColor = Color.tableBg
                    c.selectionStyle = UITableViewCellSelectionStyle.None
                    c.require = item.required
                    cell = c
                } else {
                    let c = tableView.dequeueReusableCellWithIdentifier("EntryTextAreaTableViewCell", forIndexPath: indexPath) as! EntryTextAreaTableViewCell
                    let text = item.dispValue()
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
                    let c = tableView.dequeueReusableCellWithIdentifier("EntryHeaderTableViewCell", forIndexPath: indexPath) as! EntryHeaderTableViewCell
                    c.textLabel?.text = item.label
                    c.backgroundColor = Color.tableBg
                    c.selectionStyle = UITableViewCellSelectionStyle.None
                    c.require = item.required
                    cell = c
                } else {
                    let blockItem = item as! EntryBlocksItem
                    if blockItem.isImageCell() {
                        let c = tableView.dequeueReusableCellWithIdentifier("EntryImageTableViewCell", forIndexPath: indexPath) as! EntryImageTableViewCell
                        LOG(blockItem.dispValue())
                        if item.dispValue().isEmpty {
                            c.assetImageView.hidden = true
                            c.placeholderLabel?.text = blockItem.placeholder()
                            c.placeholderLabel.hidden = false
                        } else {
                            let value = item.dispValue()
                            if !value.hasPrefix("/") {
                                c.assetImageView.sd_setImageWithURL(NSURL(string: item.dispValue()))
                            } else {
                                c.assetImageView.image = UIImage(contentsOfFile: item.dispValue())
                            }

                            c.assetImageView.hidden = false
                            c.placeholderLabel.hidden = true
                        }
                        cell = c
                    } else {
                        let c = tableView.dequeueReusableCellWithIdentifier("EntryTextAreaTableViewCell", forIndexPath: indexPath) as! EntryTextAreaTableViewCell
                        let text = blockItem.dispValue()
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
                let c = tableView.dequeueReusableCellWithIdentifier("EntryCheckboxTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = ""
                let switchCtrl = UISwitch()
                switchCtrl.tag = indexPath.section
                switchCtrl.on = (item.dispValue() == "true")
                switchCtrl.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
                c.accessoryView = switchCtrl
                c.selectionStyle = UITableViewCellSelectionStyle.None
                c.require = item.required
                cell = c
            } else if item.type == "url" {
                let c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c
            } else if item.type == "datetime" || item.type == "date" || item.type == "time"  {
                let c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c
            } else if item.type == "select" {
                let c = tableView.dequeueReusableCellWithIdentifier("EntrySelectTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c
            } else if item.type == "radio" {
                let c = tableView.dequeueReusableCellWithIdentifier("EntryRadioTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c
            } else if item.type == "image" {
                if indexPath.row == 0 {
                    let c = tableView.dequeueReusableCellWithIdentifier("EntryHeaderTableViewCell", forIndexPath: indexPath) as! EntryHeaderTableViewCell
                    c.textLabel?.text = item.label
                    c.backgroundColor = Color.tableBg
                    c.selectionStyle = UITableViewCellSelectionStyle.None
                    c.require = item.required
                    cell = c
                } else {
                    let c = tableView.dequeueReusableCellWithIdentifier("EntryImageTableViewCell", forIndexPath: indexPath) as! EntryImageTableViewCell
                    if item.dispValue().isEmpty {
                        c.placeholderLabel.hidden = false
                        c.assetImageView.hidden = true
                        if item.descriptionText.isEmpty {
                            c.placeholderLabel.text = NSLocalizedString("Select Image...", comment: "Select Image...")
                        } else {
                            c.placeholderLabel.text = item.descriptionText
                        }
                    } else {
                        c.placeholderLabel.hidden = true
                        c.assetImageView.hidden = false
                        
                        if (item as! EntryImageItem).imageFilename.isEmpty {
                            c.assetImageView.sd_setImageWithURL(NSURL(string: item.dispValue()))
                        } else {
                            LOG(item.dispValue())
                            c.assetImageView.image = UIImage(contentsOfFile: item.dispValue())
                        }
                    }
                    cell = c
                }
            } else if item.type == "status" {
                let c = tableView.dequeueReusableCellWithIdentifier("EntrySelectTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c
            } else if item.type == "category" || item.type == "folder" {
                let c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
                cell = c
            } else {
                let c = tableView.dequeueReusableCellWithIdentifier("EntryBasicTableViewCell", forIndexPath: indexPath) as! EntryBasicTableViewCell
                c.textLabel?.text = item.label
                c.detailTextLabel?.text = item.dispValue().isEmpty ? " " : item.dispValue()
                c.require = item.required
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
    
    private func showSingleLineTextEditor(object: EntryTextItem) {
        let vc = EntrySingleLineTextEditorViewController()
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showRichTextEditor(object: EntryTextAreaItem) {
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
    
    private func showHTMLEditor(object: EntryTextAreaItem) {
        let vc = EntryHTMLEditorViewController()
        vc.object = object
        vc.blog = blog
        vc.entry = self.object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showMarkdownEditor(object: EntryTextAreaItem) {
        let vc = EntryMarkdownEditorViewController()
        vc.object = object
        vc.blog = blog
        vc.entry = self.object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSelector(object: EntrySelectItem) {
        let vc = EntrySelectTableViewController()
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showStatusSelector(object: EntryStatusItem) {
        let vc = EntryStatusSelectTableViewController()
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
        vc.entryAddedImageFiles = self.addedImageFiles
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
            item.isDirty = true
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
            item.isDirty = true
            if item is EntryCheckboxItem {
                (item as! EntryCheckboxItem).checked = sender.on
            }
        }
    }
    
    func statusChanged(sender: UISegmentedControl) {
        if let list = self.list {
            let item = list[sender.tag - 1]
            item.isDirty = true
            if item is EntryStatusItem {
                (item as! EntryStatusItem).selected = sender.selectedSegmentIndex
            }
        }
    }
    
    private func showAssetSelector(item: EntryImageItem) {
        if object.id.isEmpty {
            self.showOfflineImageSelector(item)
        } else {
            self.showImageSelector(item)
        }
    }
    
    private func showImageSelector(item: EntryImageItem) {
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
    
    private func showOfflineImageSelector(item: EntryImageItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "OfflineImageSelector", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! OfflineImageSelectorTableViewController
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
            return
        }
        
        let actionSheet: UIAlertController = UIAlertController(title:item.label,
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction) -> Void in
                LOG("cancelAction")
            }
        )
        
        let selectAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Select Image", comment: "Select Image"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                self.showAssetSelector(item)
            }
        )
        
        let deleteAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Delete Image", comment: "Delete Image"),
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction) -> Void in
                item.clear()
                item.isDirty = true
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
                self.showSingleLineTextEditor(item as! EntryTextItem)
            } else if item.type == "text" {
                self.showSingleLineTextEditor(item as! EntryTextItem)
            } else if item.type == "textarea" || item.type == "embed"  {
                if indexPath.row == 0 {
                    // Do nothing
                    return
                } else {
                    if item.id == "body" || item.id == "more" {
                        if self.object.format.hasPrefix(Entry.EditMode.Markdown.format()) {
                            self.showMarkdownEditor(item as! EntryTextAreaItem)
                        } else {
                            self.showRichTextEditor(item as! EntryTextAreaItem)
                        }
                    } else {
                        self.showHTMLEditor(item as! EntryTextAreaItem)
                    }
                }
            } else if item.type == "blocks" {
                self.showBlockEditor(item as! EntryBlocksItem)
            } else if item.type == "checkbox" {
                // Do nothing
            } else if item.type == "url" {
                self.showSingleLineTextEditor(item as! EntryURLItem)
            } else if item.type == "datetime" || item.type == "date" || item.type == "time" {
                self.showDatePicker(item)
            } else if item.type == "select" {
                self.showSelector(item as! EntrySelectItem)
            } else if item.type == "radio" {
                self.showSelector(item as! EntryRadioItem)
            } else if item.type == "image" {
                self.imageAction(item as! EntryImageItem)
            } else if item.type == "status" {
                self.showStatusSelector(item as! EntryStatusItem)
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
        vc.list = list
        vc.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }

    private func previewSuccess(controller: UploaderTableViewController) {
        controller.dismissViewControllerAnimated(false,
            completion: {
                guard let json = controller.result else {
                    return
                }
                
                var url = ""
                if json["preview"].isExists() {
                    url = json["preview"].stringValue
                }
                
                if !url.isEmpty {
                    let vc = PreviewViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    vc.url = url
                    self.presentViewController(nav, animated: true, completion: nil)
                }
            }
        )
    }
    
    func UploaderFinish(controller: UploaderTableViewController) {
        if controller.mode == .Preview {
            self.previewSuccess(controller)
        } else if controller.mode == .PostEntry || controller.mode == .PostPage {
            self.postSuccess(controller)
        }
    }
    
    private func preview() {
        self.uploader = MultiUploader()
        uploader.blogID = self.blog.id
        if let items = self.list?.notUploadedImages() {
            for item in items {
                uploader.addImageItem(item, blogID: self.blog.id)
            }
        }
        
        uploader.addPreview(self.list!)
        
        let vc = UploaderTableViewController()
        vc.mode = .Preview
        vc.uploader = uploader
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: false, completion: nil)
    }

/*
    private func preview() {
        let json = self.makeParams(true)
        if json == nil {
            return
        }
        
        let isEntry = object is Entry
        let blogID = blog.id
        let id: String? = object.id.isEmpty ? nil : object.id
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        let success: (JSON!-> Void) = {
            (result: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            let url = result["preview"].stringValue
            
            let vc = PreviewViewController()
            let nav = UINavigationController(rootViewController: vc)
            vc.url = url
            self.presentViewController(nav, animated: true, completion: nil)
        }
        let failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Make preview...", comment: "Make preview..."))
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
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
*/
    
    @IBAction func previewButtonPushed(sender: UIBarButtonItem) {
        if !Utils.hasConnectivity() {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("You can not connect to the network.", comment: "You can not connect to the network."))
            return
        }

        if let items = self.list?.notUploadedImages() {
            if items.count == 0 {
                self.preview()
                return
            }
            
            let alertController = UIAlertController(
                title: NSLocalizedString("Preview", comment: "Preview"),
                message: NSLocalizedString("Need to upload the images to make a preview.\nAre you sure you want to continue a preview?", comment: "Need to upload the images to make a preview.\nAre you sure you want to continue a preview?"),
                preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: "YES"), style: .Default) {
                action in
                
                self.preview()
            }
            let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: "NO"), style: .Default) {
                action in
                
            }
            
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.preview()
        }
    }
    
    @IBAction func editButtonPushed(sender: UIBarButtonItem) {
        let vc = EntryItemListTableViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.list = list
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    private func makeParams(preview: Bool)-> [String:AnyObject]? {
        if let params = list?.makeParams(preview) {
            return params
        }

        return nil
    }
    
    private func postSuccess(controller: UploaderTableViewController) {
        controller.dismissViewControllerAnimated(false,
            completion: {
                guard let json = controller.result else {
                    return
                }

                let isEntry = self.object is Entry
                
                self.list!.removeDraftData()
                
                var newObject: BaseEntry? = nil
                if isEntry {
                    newObject = Entry(json: json)
                } else {
                    newObject = Page(json: json)
                }
                
                if newObject != nil {
                    self.object = newObject
                }
                
                self.title = self.object.title
                
                self.list = EntryItemList(blog: self.blog, object: self.object)
                
                self.tableView.reloadData()
                self.makeToolbarItems()
                
                self.list!.clean()
            }
        )
    }

    private func saveEntry() {
        self.uploader = MultiUploader()
        uploader.blogID = self.blog.id
        if let items = self.list?.notUploadedImages() {
            for item in items {
                uploader.addImageItem(item, blogID: self.blog.id)
            }
        }
        
        uploader.addPost(self.list!)
        
        let vc = UploaderTableViewController()
        vc.mode = object is Entry ? .PostEntry : .PostPage
        vc.uploader = uploader
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
/*
    private func saveEntry() {
        let json = self.makeParams(false)
        if json == nil {
            return
        }
        
        let create = object.id.isEmpty
        let isEntry = object is Entry
        
        let blogID = blog.id
        let id = object.id
        
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        let success: (JSON!-> Void) = {
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
            self.list!.clean()
        }
        let failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Save...", comment: "Save..."))

        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                let params = ["no_text_filter":"1"]
                if create {
                    if isEntry {
                        api.createEntry(siteID: blogID, entry: json!, options: params, success: success, failure: failure)
                    } else {
                        api.createPage(siteID: blogID, page: json!, options: params, success: success, failure: failure)
                    }
                } else {
                    if isEntry {
                        api.updateEntry(siteID: blogID, entryID: id, entry: json!, options: params, success: success, failure: failure)
                    } else {
                        api.updatePage(siteID: blogID, pageID: id, page: json!, options: params, success: success, failure: failure)
                    }
                }
            },
            failure: failure
        )
    }
*/
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
        
        let success: (JSON!-> Void) = {
            (result: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            LOG(result.description)
            
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
        let failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            LOG(error.description)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Check modified at...", comment: "Check modified at..."))
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                let params = ["fields":"id,modifiedDate"]
                if isEntry {
                    api.getEntry(siteID: blogID, entryID: id, options: params, success: success, failure: failure)
                } else {
                    api.getPage(siteID: blogID, pageID: id, options: params, success: success, failure: failure)
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
        if let statusItem = self.list!.itemWithID("status", isCustomField: false) {
            self.object.status = statusItem.value()
        }
        let success = self.list!.saveToFile()
        if !success {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("Save failed", comment: "Save failed"))
        } else {
            SVProgressHUD.showSuccessWithStatus(NSLocalizedString("Success", comment: "Success"))
            self.list!.clean()
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
                (action:UIAlertAction) -> Void in
                LOG("cancelAction")
            }
        )
        
        let submitAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                
                if !self.object.id.isEmpty && !self.list!.filename.isEmpty {
                    self.checkModified()
                } else {
                    self.saveEntry()
                }
            }
        )
        
        let saveLocalAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Save Local", comment: "Save Local"),
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                self.saveLocal()
            }
        )
        
        actionSheet.addAction(submitAction)
        actionSheet.addAction(saveLocalAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func entrySettingCancel(controller: EntrySettingTableViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func entrySettingDone(controller: EntrySettingTableViewController, object: BaseEntry) {
        if let list = self.list {
            for item in list.items {
                if item is EntryBlocksItem {
                    (item as! EntryBlocksItem).editMode = object.editMode
                }
            }
        }
        
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
        
        let success: ((JSON!)-> Void) = {
            (result: JSON!)-> Void in
            LOG("\(result)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            if self.presentingViewController != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        let failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
        }
        
        api.authenticationV2(authInfo.username, password: authInfo.password, remember: true,
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
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
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
        self.dismissViewControllerAnimated(false, completion: {
            let vc = controller as! ImageSelectorTableViewController
            let item = vc.object
            item.asset = asset
            item.isDirty = true
            self.tableView.reloadData()
        })
    }
    
    func AddAssetsDone(controller: AddAssetTableViewController) {
    }
    
    func AddOfflineImageDone(controller: AddAssetTableViewController, item: EntryImageItem) {
        self.dismissViewControllerAnimated(false, completion: {
            item.asset = nil
            item.isDirty = true
            self.addedImageFiles.items.append(item.imageFilename)
            self.tableView.reloadData()
        })
    }
    
    func AddOfflineImageStorageError(controller: AddAssetTableViewController, item: EntryImageItem) {
        self.dismissViewControllerAnimated(false, completion: {
            let alertController = UIAlertController(
                title: NSLocalizedString("Error", comment: "Error"),
                message: NSLocalizedString("The selected image could not be saved to the storage.", comment: "The selected image could not be saved to the storage."),
                preferredStyle: .Alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default) {
                action in
            }
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }

    func cleanup() {
        for path in self.addedImageFiles.items {
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtPath(path)
            } catch {
            }
        }
    }
    
    @IBAction func closeButtonPushed(sender: AnyObject) {
        for item in self.list!.items {
            if item.isDirty {
                Utils.confrimSave(self, dismiss: true, block: {self.cleanup()})
                return
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        for item in self.list!.items {
            if item.isDirty {
                Utils.confrimSave(self, block: {self.cleanup()})
                return
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
