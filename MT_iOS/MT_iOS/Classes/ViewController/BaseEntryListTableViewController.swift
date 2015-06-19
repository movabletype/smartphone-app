//
//  BaseEntryListTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/22.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class BaseEntryListTableViewController: BaseTableViewController, UISearchBarDelegate {
    var searchBar: UISearchBar!
    
    var blog: Blog!
    var list: ItemList = ItemList()
    var actionMessage = NSLocalizedString("Fetch data", comment: "Fetch data")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = MTRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        searchBar = UISearchBar()
        searchBar.frame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 44.0)
        searchBar.barTintColor = Color.tableBg
        searchBar.placeholder = NSLocalizedString("Search", comment: "Search")
        searchBar.delegate = self
        
        var textField = Utils.getTextFieldFromView(searchBar)
        if textField != nil {
            textField!.enablesReturnKeyAutomatically = false
        }
        
        self.tableView.registerNib(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    @IBAction func refresh(sender:UIRefreshControl) {
        self.fetch()
    }
    
    // MARK: - fetch
    func fetch() {
        SVProgressHUD.showWithStatus(actionMessage + "...")
        var success: (([JSON]!, Int!)-> Void) = {
            (result: [JSON]!, total: Int!)-> Void in
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            SVProgressHUD.showErrorWithStatus(String(format: NSLocalizedString("%@ failured.", comment: "%@ failured."), arguments: [self.actionMessage]))
            self.refreshControl!.endRefreshing()
        }
        list.refresh(success, failure: failure)
    }
    
    func more() {
        var success: (([JSON]!, Int!)-> Void) = {
            (result: [JSON]!, total: Int!)-> Void in
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            self.refreshControl!.endRefreshing()
        }
        list.more(success, failure: failure)
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
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryTableViewCell", forIndexPath: indexPath) as! EntryTableViewCell
    
        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        let item = self.list[indexPath.row] as! BaseEntry
        cell.object = item
    
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    //MARK: -
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
            
            if self.list.working {return}
            if self.list.isFinished() {return}
            
            self.more()
        }
    }
    
    //MARK: -
    func composeButtonPushed(sender: UIBarButtonItem) {

    }
    
    // MARK: --
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.list.searchText = searchBar.text
        if self.list.count > 0 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
        self.fetch()
    }
}
