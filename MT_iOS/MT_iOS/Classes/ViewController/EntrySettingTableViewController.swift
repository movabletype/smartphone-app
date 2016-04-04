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

class EntrySettingTableViewController: BaseTableViewController, DatePickerViewControllerDelegate, EditorModeDelegate {
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
    
    var items = [Item]()
    var object: BaseEntry!
    var blog: Blog!
    var list: EntryItemList?
    var delegate: EntrySettingDelegate?
    
    var tagObject = EntryTagItem()
    var publishDate: NSDate?
    var unpublishDate: NSDate?
    var editorMode = Entry.EditMode.RichText
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if list!.filename.isEmpty && object.id.isEmpty {
            self.items = [
                .Tags,
                .PublishDate,
                .UnpublishDateEnabled,
                .UnpublishDate,
                .Spacer1,
                .EditorMode,
                .Spacer2,
            ]
        } else if !object.id.isEmpty {
            self.items = [
                .Tags,
                .PublishDate,
                .UnpublishDateEnabled,
                .UnpublishDate,
                .Spacer1,
                .DeleteButton,
            ]

        } else {
            self.items = [
                .Tags,
                .PublishDate,
                .UnpublishDateEnabled,
                .UnpublishDate,
                .Spacer1,
                .EditorMode,
                .Spacer2,
                .DeleteButton,
            ]
        }

        
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
        
        self.editorMode = object.editMode
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
        return self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let separatorLineView = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 1.0))
        separatorLineView.backgroundColor = Color.separatorLine
        
        // Configure the cell...
        let item = items[indexPath.row]
        switch item {
        case Item.Tags:
            let c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) 
            c.textLabel?.text = NSLocalizedString("Tags", comment: "Tags")
            c.detailTextLabel?.text = tagObject.text
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.PublishDate:
            let c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) 
            c.textLabel?.text = NSLocalizedString("Publish at", comment: "Publishat ")
            if let date = publishDate {
                c.detailTextLabel?.text = Utils.mediumDateTimeFromDate(date)
            } else {
                c.detailTextLabel?.text = ""
            }
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.UnpublishDateEnabled:
            let c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) 
            c.textLabel?.text = NSLocalizedString("Unpublish at", comment: "Unpublish at")
            c.detailTextLabel?.text = ""
            let switchCtrl = UISwitch()
            switchCtrl.on = (unpublishDate != nil)
            switchCtrl.addTarget(self, action: "unpublishEnabledChenged:", forControlEvents: UIControlEvents.ValueChanged)
            c.accessoryView = switchCtrl
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.UnpublishDate:
            let c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) 
            c.textLabel?.text = ""
            if let date = unpublishDate {
                c.detailTextLabel?.text = Utils.mediumDateTimeFromDate(date)
            } else {
                c.detailTextLabel?.text = NSLocalizedString("Not set", comment: "Not set")
            }
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.EditorMode:
            let c = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) 
            c.textLabel?.text = NSLocalizedString("Editor Mode", comment: "Editor Mode")
            if self.editorMode == Entry.EditMode.RichText {
                c.detailTextLabel?.text = Entry.EditMode.RichText.label()
            } else if editorMode == Entry.EditMode.PlainText {
                c.detailTextLabel?.text = Entry.EditMode.PlainText.label()
            } else if editorMode == Entry.EditMode.Markdown {
                c.detailTextLabel?.text = Entry.EditMode.Markdown.label()
            }
            c.contentView.addSubview(separatorLineView)
            c.backgroundColor = Color.bg
            cell = c
            
        case Item.DeleteButton:
            let c = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
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
            
            let user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser!
            if object is Entry {
                c.button.enabled = blog.canDeleteEntry(user: user, entry: object as! Entry)
            } else {
                c.button.enabled = blog.canDeletePage(user: user)
            }
            
            cell = c
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        case Item.Spacer1:
            cell.contentView.addSubview(separatorLineView)
            cell.backgroundColor = Color.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        case Item.Spacer2:
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
        let item = items[indexPath.row]
        switch item {
        case Item.Tags:
            return 48.0
        case Item.PublishDate:
            return 48.0
        case Item.UnpublishDateEnabled:
            return 48.0
        case Item.UnpublishDate:
            return 48.0
        case Item.EditorMode:
            return 48.0
        case Item.DeleteButton:
            return 40.0
        case Item.Spacer1:
            return 20.0
        default:
            return 12.0
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedIndexPath = indexPath
        let item = items[indexPath.row]
        switch item {
        case Item.Tags:
            let vc = EntrySingleLineTextEditorViewController()
            vc.object = tagObject
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.PublishDate:
            let storyboard: UIStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! DatePickerViewController
            if let date = publishDate {
                vc.date = date
            } else {
                vc.date = NSDate()
            }
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.UnpublishDate:
            let storyboard: UIStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! DatePickerViewController
            if let date = unpublishDate {
                vc.date = date
            } else {
                vc.date = NSDate()
            }
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case Item.EditorMode:
            let vc = EditorModeTableViewController()
            vc.oldSelected = self.editorMode
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @IBAction func closeButtonPushed(sender: AnyObject) {
        self.delegate?.entrySettingCancel(self)
    }
    
    @IBAction func doneButtonPushed(sender: AnyObject) {
        if let date = unpublishDate {
            if date.isInPast() {
                let alertController = UIAlertController(
                    title: NSLocalizedString("Error", comment: "Error"),
                    message: NSLocalizedString("'Unpublished on' dates should be dates in the future.", comment: "'Unpublished on' dates should be dates in the future."),
                    preferredStyle: .Alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default) {
                    action in
                }
                alertController.addAction(okAction)
                presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
        }
        
        object.date = publishDate
        object.unpublishedDate = unpublishDate
        object.setTagsFromString(tagObject.text)
        object.editMode = self.editorMode
        
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
        
        let item = items[selectedIndexPath!.row]
        switch item {
        case Item.PublishDate:
            self.publishDate = date
        case Item.UnpublishDate:
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
    
    
    func editorModeDone(controller: EditorModeTableViewController, selected: Entry.EditMode) {
        self.editorMode = selected
    }
}
