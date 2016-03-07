//
//  CommonWebViewController.swift
//  SenseiNote
//
//  Created by CHEEBOW on 2015/01/09.
//  Copyright (c) 2015年 LOUPE,Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class CommonWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String = ""
    var filePath: String = ""
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        self.webView.UIDelegate = self
        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.backgroundColor = Color.bg
        
        let leading: NSLayoutConstraint = NSLayoutConstraint(
            item: self.webView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 0.0)
        
        let trailing: NSLayoutConstraint = NSLayoutConstraint(
            item: self.webView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0.0)
        
        let top: NSLayoutConstraint = NSLayoutConstraint(
            item: self.webView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0)
        
        let bottom: NSLayoutConstraint = NSLayoutConstraint(
            item: self.webView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.bottomLayoutGuide,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0.0)
        
        self.view.addConstraints([leading, trailing, top, bottom])
        
        var url = NSURL(string: urlString)
        if !filePath.isEmpty {
            url = NSURL(fileURLWithPath: filePath)
        }
        
        let request = NSMutableURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.webView.addSubview(self.indicator)
        self.indicator.center = self.webView.center
        var rect = self.indicator.frame
        if (self.navigationController != nil) {
            rect.origin.y -= self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        }
        self.indicator.frame = rect
        self.indicator.startAnimating()
        
        self.title = NSLocalizedString("Loading...", comment: "Loading...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !Utils.hasConnectivity() {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("You can not connect to the network.", comment: "You can not connect to the network."))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:-
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.indicator.removeFromSuperview()
        let title = webView.title
        self.title = title
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    private func didFail(error: NSError) {
        self.indicator.removeFromSuperview()
        if error.code != -999 {
            self.title = NSLocalizedString("Error", comment: "Error")
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        self.didFail(error)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        self.didFail(error)
    }
}
