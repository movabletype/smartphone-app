//
//  ResetPasswordTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/28.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class ResetPasswordTableViewController: BaseTableViewController, UITextFieldDelegate {

    enum Item: Int {
        case Username = 0,
        Email,
        Endpoint,
        Spacer1,
        Button,
        _Num
    }

    var username = ""
    var email = ""
    var endpoint = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBarHidden = false
        self.title = NSLocalizedString("Forgot password", comment: "Forgot password")
        
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = Color.tableBg
        
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
        var cell = UITableViewCell()

        // Configure the cell...
        switch indexPath.row {
        case Item.Username.rawValue:
            let c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
            c.textField.placeholder = NSLocalizedString("username", comment: "username")
            c.textField.keyboardType = UIKeyboardType.Default
            c.textField.returnKeyType = UIReturnKeyType.Done
            c.textField.secureTextEntry = false
            c.textField.text = username
            c.textField.tag = indexPath.row
            c.textField.delegate = self
            c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            c.bgImageView.image = UIImage(named: "signin_table_1")
            cell = c
            
        case Item.Email.rawValue:
            let c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
            c.textField.placeholder = NSLocalizedString("email", comment: "email")
            c.textField.keyboardType = UIKeyboardType.EmailAddress
            c.textField.returnKeyType = UIReturnKeyType.Done
            c.textField.secureTextEntry = false
            c.textField.text = email
            c.textField.tag = indexPath.row
            c.textField.delegate = self
            c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            c.bgImageView.image = UIImage(named: "signin_table_2")
            cell = c

        case Item.Endpoint.rawValue:
            let c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
            c.textField.placeholder = NSLocalizedString("endpoint", comment: "endpoint")
            c.textField.keyboardType = UIKeyboardType.URL
            c.textField.returnKeyType = UIReturnKeyType.Done
            c.textField.secureTextEntry = false
            c.textField.text = endpoint
            c.textField.tag = indexPath.row
            c.textField.delegate = self
            c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            c.bgImageView.image = UIImage(named: "signin_table_3")
            cell = c
            
        case Item.Button.rawValue:
            let c = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
            c.button.setTitle(NSLocalizedString("Reset", comment: "Reset"), forState: UIControlState.Normal)
            c.button.titleLabel?.font = UIFont.systemFontOfSize(17.0)
            c.button.setTitleColor(Color.buttonText, forState: UIControlState.Normal)
            c.button.setTitleColor(Color.buttonDisableText, forState: UIControlState.Disabled)
            c.button.setBackgroundImage(UIImage(named: "btn_signin"), forState: UIControlState.Normal)
            c.button.setBackgroundImage(UIImage(named: "btn_signin_highlight"), forState: UIControlState.Highlighted)
            c.button.setBackgroundImage(UIImage(named: "btn_signin_disable"), forState: UIControlState.Disabled)
            c.button.enabled = self.validate()
            c.button.addTarget(self, action: "resetButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell = c
            
        default:
            break
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = Color.clear

        return cell
    }

    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: GroupedHeaderView = GroupedHeaderView.instanceFromNib() as! GroupedHeaderView
        headerView.label.text = NSLocalizedString("Reset password", comment: "Reset password")
        return headerView
    }
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case Item.Username.rawValue:
            return 48.0
        case Item.Email.rawValue:
            return 48.0
        case Item.Endpoint.rawValue:
            return 48.0
        case Item.Button.rawValue:
            return 40.0
        default:
            return 12.0
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    private func validate()-> Bool {
        if username.isEmpty || email.isEmpty || endpoint.isEmpty {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldChanged(field: UITextField) {
        switch field.tag {
        case Item.Username.rawValue:
            username = field.text!
        case Item.Email.rawValue:
            email = field.text!
        case Item.Endpoint.rawValue:
            endpoint = field.text!
        default:
            break
        }
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:Item.Button.rawValue , inSection: 0)) as! ButtonTableViewCell
        cell.button.enabled = self.validate()
    }

    private func resetPassword(username: String, email: String, endpoint: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Reset password...", comment: "Reset password..."))
        let api = DataAPI.sharedInstance
        api.APIBaseURL = endpoint
        
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        api.recoverPassword(username, email: email,
            success: {_ in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.dismiss()

                self.navigationController?.popViewControllerAnimated(true)
            },
            failure: failure
        )
    }
    
    @IBAction func resetButtonPushed(sender: AnyObject) {
        self.resetPassword(username, email: email, endpoint: endpoint)
    }
    
}
