//
//  AddAssetTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/10.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices
import SVProgressHUD
import SwiftyJSON

protocol AddAssetDelegate {
    func AddAssetDone(controller: AddAssetTableViewController, asset: Asset)
}

class AddAssetTableViewController: BaseTableViewController, BlogImageSizeDelegate, BlogImageQualityDelegate, BlogUploadDirDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageAlignDelegate {
    enum Section:Int {
        case Buttons = 0,
        Items,
        _Num
    }
    
    enum Item:Int {
        case UploadDir = 0,
        Size,
        Quality,
        Align,
        _Num
    }
    
    var blog: Blog!
    var delegate: AddAssetDelegate?
    
    var uploadDir = "/"
    var imageSize = Blog.ImageSize.M
    var imageQuality = Blog.ImageQuality.Normal
    var imageAlign = Blog.ImageAlign.None
    
    var showAlign = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = NSLocalizedString("Add Item", comment: "Add Item")
        
        self.tableView.backgroundColor = Color.tableBg
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
        
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
        return Section._Num.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case Section.Buttons.rawValue:
            return 1
        case Section.Items.rawValue:
            if showAlign {
                return Item._Num.rawValue
            } else {
                return Item._Num.rawValue - 1
            }
        default:
            return 0
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.Buttons.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! UITableViewCell
            
            self.adjustCellLayoutMargins(cell)
            
            cell.backgroundColor = Color.tableBg
            
            if let cameraButton = cell.viewWithTag(1) as? UIButton {
                cameraButton.addTarget(self, action: "cameraButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            if let libraryButton = cell.viewWithTag(2) as? UIButton {
                libraryButton.addTarget(self, action: "libraryButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            if let assetListButton = cell.viewWithTag(3) as? UIButton {
                assetListButton.addTarget(self, action: "assetListButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            return cell
        case Section.Items.rawValue:
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
            case Item.Align.rawValue:
                cell.textLabel?.text = NSLocalizedString("Align", comment: "Align")
                cell.imageView?.image = UIImage(named: "ico_align")
                cell.detailTextLabel?.text = imageAlign.label()
            default:
                cell.textLabel?.text = ""
            }
            
            // Configure the cell...
            
            return cell
        default:
            break
        }
    
        // Configure the cell...

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.Buttons.rawValue:
            return 220.0
        case Section.Items.rawValue:
            return 58.0
        default:
            return 0
        }
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
        if indexPath.section == Section.Buttons.rawValue {
            return
        }
        
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
        case Item.Align.rawValue:
            let storyboard: UIStoryboard = UIStoryboard(name: "ImageAlign", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! ImageAlignTableViewController
            vc.selected = imageAlign.rawValue
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
    
    func imageAlignDone(controller: ImageAlignTableViewController, selected: Int) {
        imageAlign = Blog.ImageAlign(rawValue: selected)!
        self.tableView.reloadData()
    }
    
    @IBAction func cameraButtonPushed(sender: UIButton) {
        let ipc: UIImagePickerController = UIImagePickerController()
        ipc.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            ipc.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        ipc.mediaTypes = [kUTTypeImage]
        
        self.presentViewController(ipc, animated:true, completion:nil)
    }
    
    @IBAction func libraryButtonPushed(sender: UIButton) {
        let ipc: UIImagePickerController = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        ipc.mediaTypes = [kUTTypeImage]
        
        self.presentViewController(ipc, animated:true, completion:nil)
    }
    
    @IBAction func assetListButtonPushed(sender: UIButton) {
        //Implement Subclass
    }
    
    private func uploadData(data: NSData, filename: String, path: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Upload data...", comment: "Upload data..."))
        let api = DataAPI.sharedInstance
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let authInfo = app.authInfo
        
        var success: ((JSON!)-> Void) = {
            (result: JSON!)-> Void in
            LOG("\(result)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            
            let asset = Asset(json: result)
            self.delegate?.AddAssetDone(self, asset: asset)
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
        }
        
        api.authentication(authInfo.username, password: authInfo.password, remember: true,
            success:{_ in
                api.uploadAssetForSite(siteID: self.blog.id, assetData: data, fileName: filename, options: ["path":path, "autoRenameIfExists":"true"], success: success, failure: failure)
            },
            failure: failure
        )
    }
    
    private func uploadImage(image: UIImage) {
        let resizedImage = Utils.resizeImage(image, width: imageSize.size())
        let jpeg = Utils.convertImageToJPEG(resizedImage, quality: imageQuality.quality() / 100.0)
        let filename = Utils.makeJPEGFilename()

        self.uploadData(jpeg, filename: filename, path: uploadDir)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            picker.dismissViewControllerAnimated(true, completion:
                {_ in
                    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        self.uploadImage(image)
                    }
                }
            );
    }

    
}
