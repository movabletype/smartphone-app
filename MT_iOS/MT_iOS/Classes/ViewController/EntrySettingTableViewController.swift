//
//  EntrySettingTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol EntrySettingDelegate {
    func entrySettingCancel(controller: EntrySettingTableViewController)
    func entrySettingDone(controller: EntrySettingTableViewController, object: BaseEntry)
    func entrySettingDelete(controller: EntrySettingTableViewController, object: BaseEntry)
}

class EntrySettingTableViewController: BaseTableViewController, DatePickerViewControllerDelegate {
    enum Item: Int {
        case Tags = 0,
        PublishDate,
        UnpublishDateEnabled,
        UnpublishDate,
        Spacer1,
        EditorMode,
        Spacer2,
        DeleteButton,
        _Num
    }
    
    var object: BaseEntry!
    var blog: Blog!
    var list: EntryItemList?
    var delegate: EntrySettingDelegate?
    
    var tagObject = EntryTagItem()
    var publishDate: NSDate?
    var unpublishDate: NSDate?
    var editorMode = EntrySelectItem()
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = NSLocalizedString("Advanced Setting", comment: "Advanced Setting")
        self.tableView.backgroundColor = Color.tableBg
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
        
        let barButton:UIBarButtonItem = UIBarButtonItem(); barButton.title = "";
        self.navigationItem.backBarButtonItem = barButton;
        
        self.tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        
        publishDate = object.date
        unpublishDate = object.unpublishedDate
        
        tagObject.id = "tag"
        tagObject.label = NSLocalizedString("Tag", comment: "Tag")
        tagObject.text = object.tagsString()
        
        editorMode.id = "editorMode"
        editorMode.label = NSLocalizedString("EditorMode", comment: "EditorMode")
        editorMode.list = [Entry.EditMode.PlainText.label(), Entry.EditMode.RichText.label()]
        editorMode.selected = object.editMode.text()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
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
        if list!.filename.isEmpty && object.id.isEmpty {
            return Item._Num.rawValue - 1
        }
        
        return Item._Num.rawValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        var separatorLineView = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 1.0))
        separatorLineView.backgroundColor = Color.separatorLine
        
        // Configure the cell...
        switch indexPath.row {
        case Item.Tags.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! UITableViewCell
            c.textLabel?.text = NSLocalizedString("Tags", comment: "Tags")
            c.detailTextLabel?.text = tagObject.text
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.PublishDate.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! UITableViewCell
            c.textLabel?.text = NSLocalizedString("Publish at", comment: "Publishat ")
            if let date = publishDate {
                c.detailTextLabel?.text = Utils.mediumDateTimeFromDate(date)
            } else {
                c.detailTextLabel?.text = ""
            }
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.UnpublishDateEnabled.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! UITableViewCell
            c.textLabel?.text = NSLocalizedString("Unpublish at", comment: "Unpublish at")
            c.detailTextLabel?.text = ""
            var switchCtrl = UISwitch()
            switchCtrl.on = (unpublishDate != nil)
            switchCtrl.addTarget(self, action: "unpublishEnabledChenged:", forControlEvents: UIControlEvents.ValueChanged)
            c.accessoryView = switchCtrl
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.UnpublishDate.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! UITableViewCell
            c.textLabel?.text = ""
            if let date = unpublishDate {
                c.detailTextLabel?.text = Utils.mediumDateTimeFromDate(date)
            } else {
                c.detailTextLabel?.text = NSLocalizedString("Not set", comment: "Not set")
            }
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.EditorMode.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! UITableViewCell
            c.textLabel?.text = NSLocalizedString("Editor Mode", comment: "Editor Mode")
            c.detailTextLabel?.text = editorMode.selected
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.DeleteButton.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
            var titleText: String
            if object is Entry {
                if list!.filename.isEmpty {
                    titleText = NSLocalizedString("Delete this Entry", comment: "Delete this Entry")
                } else {
                    titleText = NSLocalizedString("Delete this local saved entry", comment: "Delete this local saved entry")
                }
            } else {
                if list!.filename.isEmpty {
                    titleText = NSLocalizedString("Delete this Page", comment: "Delete this Page")
                } else {
                    titleText = NSLocalizedString("Delete this local saved page", comment: "Delete this local saved page")
                }
            }
            c.button.setTitle(titleText, forState: UIControlState.Normal)
            c.button.titleLabel?.font = UIFont.systemFontOfSize(17.0)
            c.button.setTitleColor(Color.buttonText, forState: UIControlState.Normal)
            c.button.setTitleColor(Color.buttonDisableText, forState: UIControlState.Disabled)
            c.button.setBackgroundImage(UIImage(named: "btn_signin"), forState: UIControlState.Normal)
            c.button.setBackgroundImage(UIImage(named: "btn_signin_highlight"), forState: UIControlState.Highlighted)
            c.button.setBackgroundImage(UIImage(named: "btn_signin_disable"), forState: UIControlState.Disabled)
            c.button.addTarget(self, action: "deleteButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            c.backgroundColor = Color.clear
            
            if object is Entry {
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                c.button.enabled = blog.canDeleteEntry(user: app.currentUser!, entry: object as! Entry)
            } else {
                c.button.enabled = blog.canDeletePage()
            }
            
            cell = c
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        case Item.Spacer1.rawValue:
            cell.contentView.addSubview(separatorLineView)
            cell.backgroundColor = Color.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        case Item.Spacer2.rawValue:
            cell.contentView.addSubview(separatorLineView)
            cell.backgroundColor = Color.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        default:
            break
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case Item.Tags.rawValue:
            return 48.0
        case Item.PublishDate.rawValue:
            return 48.0
        case Item.UnpublishDateEnabled.rawValue:
            return 48.0
        case Item.UnpublishDate.rawValue:
            return 48.0
        case Item.EditorMode.rawValue:
            return 48.0
        case Item.DeleteButton.rawValue:
            return 40.0
        case Item.Spacer1.rawValue:
            return 20.0
        default:
            return 12.0
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedIndexPath = indexPath
        switch indexPath.row {
        case Item.Tags.rawValue:
            let vc = EntryTextEditorViewController()
            vc.object = tagObject
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.PublishDate.rawValue:
            let storyboard: UIStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! DatePickerViewController
            if let date = publishDate {
                vc.date = date
            } else {
                vc.date = NSDate()
            }
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.UnpublishDate.rawValue:
            let storyboard: UIStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! DatePickerViewController
            if let date = unpublishDate {
                vc.date = date
            } else {
                vc.date = NSDate()
            }
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.EditorMode.rawValue:
            let vc = EntrySelectTableViewController()
            vc.object = editorMode
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @IBAction func closeButtonPushed(sender: AnyObject) {
        self.delegate?.entrySettingCancel(self)
    }
    
    @IBAction func doneButtonPushed(sender: AnyObject) {
        object.date = publishDate
        object.unpublishedDate = unpublishDate
        object.setTagsFromString(tagObject.text)
        
        if Entry.EditMode.PlainText.text() == editorMode.selected {
            object.editMode = Entry.EditMode.PlainText
        } else {
            object.editMode = Entry.EditMode.RichText
        }
        
        self.delegate?.entrySettingDone(self, object: self.object)
    }
    
    @IBAction func deleteButtonPushed(sender: AnyObject) {
        var titleText: String
        var messageText: String
        if object is Entry {
            titleText = NSLocalizedString("Delete Entry", comment: "Delete Entry")
            messageText = NSLocalizedString("Are you sure you want to delete the Entry?", comment: "Are you sure you want to delete the Entry?")
        } else {
            titleText = NSLocalizedString("Delete Page", comment: "Delete Page")
            messageText = NSLocalizedString("Are you sure you want to delete the Page?", comment: "Are you sure you want to delete the Page?")
        }
        
        let alertController = UIAlertController(
            title: titleText,
            message: messageText,
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Destructive) {
            action in
            self.delegate?.entrySettingDelete(self, object: self.object)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {
            action in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func datePickerDone(controller: DatePickerViewController, date: NSDate) {
        if selectedIndexPath == nil {
            return
        }
        
        switch selectedIndexPath!.row {
        case Item.PublishDate.rawValue:
            self.publishDate = date
        case Item.UnpublishDate.rawValue:
            self.unpublishDate = date
        default:
            break
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func unpublishEnabledChenged(sender: UISwitch) {
        if sender.on {
            unpublishDate = NSDate()
        } else {
            unpublishDate = nil
        }
        self.tableView.reloadData()
    }
    
}
