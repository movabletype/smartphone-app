//
//  CategoryListTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/08.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryListTableViewController: BaseCategoryListTableViewController, PrimaryCategorySelectorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Select categories", comment: "Select categories")
        
        list = CategoryList()
        (list as! CategoryList).blog = self.blog
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        actionMessage = NSLocalizedString("Fetch categories", comment: "Fetch categories")
        
        self.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.list[indexPath.row] as! Category
        
        if let sel = selected[selectedItem.id] {
            selected[selectedItem.id] = !sel
        } else {
            selected[selectedItem.id] = true
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    @IBAction override func saveButtonPushed(sender: UIBarButtonItem) {
        var selectedObjects = [Category]()
        for (id, value) in selected {
            if value {
                selectedObjects.append(list.objectWithID(id)! as! Category)
            }
        }
        
        sort(&selectedObjects) {
            (cat1 : Category, cat2 : Category) -> Bool in
            return cat1.level < cat2.level
        }
        
        if selectedObjects.count > 1 {
            let vc = PrimaryCategorySelectorTableViewController()
            let nav = UINavigationController(rootViewController: vc)
            vc.items = selectedObjects
            vc.delegate = self
            self.presentViewController(nav, animated: true, completion: nil)
        } else {
            (object as! EntryCategoryItem).selected = selectedObjects
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    func primaryCategorySelectorDone(controller: PrimaryCategorySelectorTableViewController, selected: String) {
        self.dismissViewControllerAnimated(false, completion:
            {
                var selectedObjects = [Category]()
                for (id, value) in self.selected {
                    if value {
                        let item = self.list.objectWithID(id)! as! Category
                        if id == selected {
                            selectedObjects.insert(item, atIndex: 0)
                        } else {
                            selectedObjects.append(item)
                        }
                    }
                }
                
                (self.object as! EntryCategoryItem).selected = selectedObjects
                self.navigationController?.popViewControllerAnimated(true)
            }
        )
    }
}
