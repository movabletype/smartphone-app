//
//  SettingTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class SettingTableViewController: BaseTableViewController {
    enum Section: Int {
        case Item = 0,
        Logout,
        _Num
    }
    
    enum Item: Int {
        case Help = 0,
        License,
        ReportBug,
        _Num
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = NSLocalizedString("Setting", comment: "Setting")
        self.tableView.backgroundColor = Color.tableBg

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
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
        case Section.Item.rawValue:
            return Item._Num.rawValue
        case Section.Logout.rawValue:
            return 1
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        switch indexPath.section {
        case Section.Item.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell

            self.adjustCellLayoutMargins(cell)

            switch indexPath.row {
            case Item.Help.rawValue:
                cell.textLabel?.text = NSLocalizedString("Help", comment: "Help")
            case Item.License.rawValue:
                cell.textLabel?.text = NSLocalizedString("License", comment: "License")
            case Item.ReportBug.rawValue:
                cell.textLabel?.text = NSLocalizedString("Report bug", comment: "Report bug")
            default:
                break
            }
        case Section.Logout.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("LogoutCell", forIndexPath: indexPath) as! UITableViewCell
        default:
            break
        }

        // Configure the cell...

        return cell
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
        switch indexPath.section {
        case Section.Item.rawValue:
            switch indexPath.row {
            case Item.Help.rawValue:
                var vc = CommonWebViewController()
                vc.urlString = HELP_URL
                if Utils.preferredLanguage() != "ja" {
                    vc.urlString += "/en"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            case Item.License.rawValue:
                var vc = CommonWebViewController()
                let path = NSBundle.mainBundle().pathForResource("license", ofType: "html")
                vc.filePath = path!
                self.navigationController?.pushViewController(vc, animated: true)
            case Item.ReportBug.rawValue:
                var vc = CommonWebViewController()
                vc.urlString = REPORT_BUG_URL
                if Utils.preferredLanguage() != "ja" {
                    vc.urlString += "/en"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case Section.Logout.rawValue:
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            app.logout()
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

    //MARK: -
    func closeButtonPushed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
