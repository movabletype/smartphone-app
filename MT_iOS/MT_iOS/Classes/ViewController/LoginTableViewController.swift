//
//  LoginTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/28.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LoginTableViewController: BaseTableViewController, UITextFieldDelegate {
    enum Section: Int {
        case Logo = 0,
        AuthInfo,
        Spacer1,
        BasicAuth,
        Spacer2,
        LoginButton,
        Spacer3,
        RecoverButton,
        _Num
    }
    
    enum AuthInfoItem: Int {
        case Username = 0,
        Password,
        Endpoint,
        _Num
    }

    enum BasicAuthItem: Int {
        case Button = 0,
        Spacer1,
        Username,
        Password,
        _Num
    }
    
    enum FieldType: Int {
        case Username = 1,
        Password,
        Endpoint,
        BasicAuthUsername,
        BasicAuthPassword
    }
    
    var auth = AuthInfo()
    
    var basicAuthVisibled = false
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gradientLayer.frame = self.view.bounds
        let startColor = Color.loginBgStart.CGColor
        let endColor = Color.loginBgEnd.CGColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBarHidden = true
        
        self.tableView.registerNib(UINib(nibName: "LogoTableViewCell", bundle: nil), forCellReuseIdentifier: "LogoTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = Color.clear
        
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var authInfo = app.authInfo
        if authInfo.username.isEmpty && authInfo.endpoint.isEmpty {
            authInfo.clear()
            authInfo.save()
        }
        auth.username = authInfo.username
        auth.password = authInfo.password
        auth.endpoint = authInfo.endpoint
        auth.basicAuthUsername = authInfo.basicAuthUsername
        auth.basicAuthPassword = authInfo.basicAuthPassword
        
        if !auth.basicAuthUsername.isEmpty {
            basicAuthVisibled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
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
        case Section.Logo.rawValue:
            return 1
        case Section.AuthInfo.rawValue:
            return AuthInfoItem._Num.rawValue
        case Section.BasicAuth.rawValue:
            if basicAuthVisibled {
                return BasicAuthItem._Num.rawValue
            } else {
                return 1
            }
        case Section.LoginButton.rawValue:
            return 1
        case Section.RecoverButton.rawValue:
            return 1
        default:
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        
        //tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.section {
        case Section.Logo.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("LogoTableViewCell", forIndexPath: indexPath) as! LogoTableViewCell
            cell = c
            
        case Section.AuthInfo.rawValue:
            switch indexPath.row {
            case AuthInfoItem.Username.rawValue:
                var c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                c.textField.placeholder = NSLocalizedString("username", comment: "username")
                c.textField.keyboardType = UIKeyboardType.Default
                c.textField.returnKeyType = UIReturnKeyType.Done
                c.textField.secureTextEntry = false
                c.textField.text = auth.username
                c.textField.tag = FieldType.Username.rawValue
                c.textField.delegate = self
                c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                c.bgImageView.image = UIImage(named: "signin_table_1")
                cell = c
            case AuthInfoItem.Password.rawValue:
                var c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                c.textField.placeholder = NSLocalizedString("password", comment: "password")
                c.textField.keyboardType = UIKeyboardType.Default
                c.textField.returnKeyType = UIReturnKeyType.Done
                c.textField.secureTextEntry = true
                c.textField.text = auth.password
                c.textField.tag = FieldType.Password.rawValue
                c.textField.delegate = self
                c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                c.bgImageView.image = UIImage(named: "signin_table_2")
                cell = c
            case AuthInfoItem.Endpoint.rawValue:
                var c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                c.textField.placeholder = NSLocalizedString("endpoint", comment: "endpoint")
                c.textField.keyboardType = UIKeyboardType.URL
                c.textField.returnKeyType = UIReturnKeyType.Done
                c.textField.secureTextEntry = false
                c.textField.text = auth.endpoint
                c.textField.tag = FieldType.Endpoint.rawValue
                c.textField.delegate = self
                c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                c.bgImageView.image = UIImage(named: "signin_table_3")
                cell = c
            default:
                break
            }

        case Section.BasicAuth.rawValue:
            switch indexPath.row {
            case BasicAuthItem.Button.rawValue:
                var c = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
                c.button.setTitle(NSLocalizedString("Basic Auth", comment: "Basic Auth"), forState: UIControlState.Normal)
                c.button.titleLabel?.font = UIFont.systemFontOfSize(16.0)
                c.button.setTitleColor(Color.buttonText, forState: UIControlState.Normal)
                if self.basicAuthVisibled {
                    c.button.setBackgroundImage(UIImage(named: "btn_basic_open"), forState: UIControlState.Normal)
                } else {
                    c.button.setBackgroundImage(UIImage(named: "btn_basic_close"), forState: UIControlState.Normal)
                }
                c.button.addTarget(self, action: "basicAuthButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
                cell = c
            case BasicAuthItem.Username.rawValue:
                var c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                c.textField.placeholder = NSLocalizedString("username", comment: "username")
                c.textField.keyboardType = UIKeyboardType.Default
                c.textField.returnKeyType = UIReturnKeyType.Done
                c.textField.secureTextEntry = false
                c.textField.text = auth.basicAuthUsername
                c.textField.tag = FieldType.BasicAuthUsername.rawValue
                c.textField.delegate = self
                c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                c.bgImageView.image = UIImage(named: "signin_table_1")
                cell = c
            case BasicAuthItem.Password.rawValue:
                var c = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                c.textField.placeholder = NSLocalizedString("password", comment: "password")
                c.textField.keyboardType = UIKeyboardType.Default
                c.textField.returnKeyType = UIReturnKeyType.Done
                c.textField.secureTextEntry = true
                c.textField.text = auth.basicAuthPassword
                c.textField.tag = FieldType.BasicAuthPassword.rawValue
                c.textField.delegate = self
                c.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                c.bgImageView.image = UIImage(named: "signin_table_3")
                cell = c
            default:
                break
            }

        case Section.LoginButton.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
            c.button.setTitle(NSLocalizedString("Sign In", comment: "Sign In"), forState: UIControlState.Normal)
            c.button.titleLabel?.font = UIFont.systemFontOfSize(17.0)
            c.button.setTitleColor(Color.buttonText, forState: UIControlState.Normal)
            c.button.setTitleColor(Color.buttonDisableText, forState: UIControlState.Disabled)
            c.button.setBackgroundImage(UIImage(named: "btn_signin"), forState: UIControlState.Normal)
            c.button.setBackgroundImage(UIImage(named: "btn_signin_highlight"), forState: UIControlState.Highlighted)
            c.button.setBackgroundImage(UIImage(named: "btn_signin_disable"), forState: UIControlState.Disabled)
            c.button.enabled = self.validate()
            c.button.addTarget(self, action: "signInButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell = c

        case Section.RecoverButton.rawValue:
            var c = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
            c.button.setTitle(NSLocalizedString("Forgot your password?", comment: "Forgot your password?"), forState: UIControlState.Normal)
            c.button.titleLabel?.font = UIFont.systemFontOfSize(17.0)
            c.button.setTitleColor(Color.buttonText, forState: UIControlState.Normal)
            c.button.addTarget(self, action: "forgetPasswordButtonPushed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell = c

        default:
            break
        }
        
        //tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.backgroundColor = Color.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.Logo.rawValue:
            return 175.0
            
        case Section.AuthInfo.rawValue:
            switch indexPath.row {
            case AuthInfoItem.Username.rawValue:
                return 48.0
            case AuthInfoItem.Password.rawValue:
                return 48.0
            case AuthInfoItem.Endpoint.rawValue:
                return 48.0
            default:
                return 0.0
            }
            
        case Section.BasicAuth.rawValue:
            switch indexPath.row {
            case BasicAuthItem.Button.rawValue:
                return 40.0
            case BasicAuthItem.Username.rawValue:
                return 48.0
            case BasicAuthItem.Password.rawValue:
                return 48.0
            default:
                return 12.0
            }
            
        case Section.LoginButton.rawValue:
            return 40.0
            
        case Section.RecoverButton.rawValue:
            return 40.0
            
        case Section.Spacer3.rawValue:
            return 17.0
            
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

    @IBAction func signInButtonPushed(sender: AnyObject) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.signIn(self.auth, showHud: true)
    }
    
    @IBAction func forgetPasswordButtonPushed(sender: AnyObject) {
        let vc = ResetPasswordTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func basicAuthButtonPushed(sender: AnyObject) {
        basicAuthVisibled = !basicAuthVisibled
        
        var indexPaths = [
            NSIndexPath(forRow: BasicAuthItem.Spacer1.rawValue, inSection: Section.BasicAuth.rawValue),
            NSIndexPath(forRow: BasicAuthItem.Username.rawValue, inSection: Section.BasicAuth.rawValue),
            NSIndexPath(forRow: BasicAuthItem.Password.rawValue, inSection: Section.BasicAuth.rawValue)
        ]
        self.tableView.beginUpdates()
        if basicAuthVisibled {
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Top)
        } else {
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Top)
        }
        
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: BasicAuthItem.Button.rawValue, inSection: Section.BasicAuth.rawValue)], withRowAnimation: UITableViewRowAnimation.None)
        self.tableView.endUpdates()
    }

    private func validate()-> Bool {
        if auth.username.isEmpty || auth.password.isEmpty || auth.endpoint.isEmpty {
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
        case FieldType.Username.rawValue:
            auth.username = field.text
        case FieldType.Password.rawValue:
            auth.password = field.text
        case FieldType.Endpoint.rawValue:
            auth.endpoint = field.text
        case FieldType.BasicAuthUsername.rawValue:
            auth.basicAuthUsername = field.text
        case FieldType.BasicAuthPassword.rawValue:
            auth.basicAuthPassword = field.text
        default:
            break
        }
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:0 , inSection: Section.LoginButton.rawValue)) as! ButtonTableViewCell
        cell.button.enabled = self.validate()
    }
}
