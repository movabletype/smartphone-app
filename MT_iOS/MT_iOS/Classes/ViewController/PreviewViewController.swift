//
//  PreviewViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/21.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class PreviewViewController: BaseViewController, UIWebViewDelegate {
    var url: String!
    var html: String?
    
    var webView: UIWebView!
    var segmentedControl: UISegmentedControl!
    var indicator: UIActivityIndicatorView!
    
    private func makeWebView() {
        if self.webView != nil {
            self.webView.removeFromSuperview()
        }
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)

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
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.webView.addSubview(self.indicator)
        self.indicator.center = self.webView.center
        var rect = self.indicator.frame
        if (self.navigationController != nil) {
            rect.origin.y -= self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        }
        self.indicator.frame = rect

        self.webView.addSubview(self.indicator)
        
        self.webView.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let items = [
            NSLocalizedString("Mobile", comment: "Mobile"),
            NSLocalizedString("PC", comment: "PC"),
        ]
        
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl .addTarget(self, action: "segmentedControlChanged:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
        
    }

    override func viewWillAppear(animated: Bool) {
        self.userAgentChange(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func userAgentChange(mobile: Bool) {
        var dic = [String: String]()
        if mobile {
            dic = ["UserAgent": "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X; en-us) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53"]
        } else {
            dic = ["UserAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8) AppleWebKit/536.25 (KHTML, like Gecko) Version/7.0 Safari/536.25"]
        }
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dic)

        self.makeWebView()
        
        if html == nil {
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            self.webView.loadRequest(request)
        } else {
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //Mobile
            userAgentChange(true)
        case 1: //PC
            userAgentChange(false)
        default:
            break
        }
    }
    
    //MARK:-
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.indicator.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: -
    func closeButtonPushed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
