//
//  PreviewViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/21.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class PreviewViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    var url: String!
    var html: String?
    
    var webView: WKWebView!
    var segmentedControl: UISegmentedControl!
    var indicator: UIActivityIndicatorView!
    
    private func makeWebView() {
        if self.webView != nil {
            self.webView.removeFromSuperview()
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            var js = ""
            js += "var metalist = document.getElementsByTagName('meta');"
            js += "for(var i = 0; i < metalist.length; i++) {"
            js += "  var name = metalist[i].getAttribute('name');"
            js += "  if(name && name.toLowerCase() === 'viewport') {"
            js += "    metalist[i].setAttribute('content', 'width=1024px');"
            js += "    break;"
            js += "  }"
            js += "}"

            let userScript = WKUserScript(source: js, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
            
            let controller = WKUserContentController()
            controller.addUserScript(userScript)
            
            let configuration = WKWebViewConfiguration()
            configuration.userContentController = controller
            
            self.webView = WKWebView(frame: view.bounds, configuration: configuration)
        } else {
            self.webView = WKWebView(frame: self.view.bounds)
        }
        
        //self.webView.scalesPageToFit = true
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
        
        self.webView.UIDelegate = self
        self.webView.navigationDelegate = self
        
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
        super.viewWillAppear(animated)
        self.userAgentChange(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.indicator.hidden = true
        if !Utils.hasConnectivity() {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("You can not connect to the network.", comment: "You can not connect to the network."))
        }
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
            let escapedURL = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let request = NSMutableURLRequest(URL: NSURL(string: escapedURL!)!)
            self.webView.loadRequest(request)
        } else {
            self.webView.loadHTMLString(html!, baseURL: nil)
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
    private func loadStart() {
        self.indicator.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    private func loadFinish() {
        self.indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadStart()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.loadFinish()
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        self.loadFinish()
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        self.loadFinish()
    }
    
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Authentication Required", comment: "Authentication Required"), message: webView.URL!.host, preferredStyle: .Alert)

        weak var usernameTextField: UITextField!
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = NSLocalizedString("Username", comment: "Username")
            usernameTextField = textField
        }
        
        weak var passwordTextField: UITextField!
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = NSLocalizedString("Password", comment: "Password")
            textField.secureTextEntry = true
            passwordTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {
            action in
            completionHandler(.CancelAuthenticationChallenge, nil)
        }
        
        let loginAction = UIAlertAction(title: NSLocalizedString("Login", comment: "Login"), style: .Default) {
            action in
            var username = ""
            var password = ""
            if usernameTextField.text != nil {
                username = usernameTextField.text!
            }
            if passwordTextField.text != nil {
                password = passwordTextField.text!
            }
            
            let credential = NSURLCredential(user: username, password: password, persistence: NSURLCredentialPersistence.Permanent)
            completionHandler(.UseCredential, credential)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(loginAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: -
    func closeButtonPushed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
