//
//  AppDelegate.swift
//  Movable Type for iOS
//
//  Created by CHEEBOW on 2015/05/18.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //TODO:Assetの投稿
    //TODO:下書き対応

    var window: UIWindow?
    
    var authInfo = AuthInfo()
    var currentUser: User?
    
    private func initAppearance() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        UINavigationBar.self.appearance().translucent = false
        UINavigationBar.self.appearance().barTintColor = Color.navBar
        UINavigationBar.self.appearance().tintColor = Color.navBarTint
        UINavigationBar.self.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Color.navBarTitle];
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.initAppearance()
        
        let api = DataAPI.sharedInstance
        api.clientID = "MTiOS"
        
        authInfo.load()
        
        if authInfo.username.isEmpty || authInfo.password.isEmpty || count(authInfo.endpoint) < 8 {
            self.goLoginView()
        } else {
            self.signIn(authInfo.username, password: authInfo.password, endpoint: authInfo.endpoint)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: -
    private func goLoginView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UIViewController
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    private func goBlogList() {
        let storyboard: UIStoryboard = UIStoryboard(name: "BlogList", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UIViewController
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    func signIn(username: String, password: String, endpoint: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus(NSLocalizedString("Sign In...", comment: "Sign In..."))
        let api = DataAPI.sharedInstance
        api.APIBaseURL = endpoint
        
        var failure: (JSON!-> Void) = {
            (error: JSON!)-> Void in
            LOG("failure:\(error.description)")
            SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        api.authentication(username, password: password, remember: true,
            success:{_ in
                api.getUser("me",
                    success: {(user: JSON!)-> Void in
                        LOG("\(user)")
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        SVProgressHUD.dismiss()
                        
                        self.currentUser = User(json: user)
                        
                        var authInfo = self.authInfo
                        authInfo.username = username
                        authInfo.password = password
                        authInfo.endpoint = endpoint
                        authInfo.save()
                        
                        self.goBlogList()
                    },
                    failure: failure
                )
            },
            failure: failure
        )
    }
    
    func logout() {
        let api = DataAPI.sharedInstance
        
        if api.sessionID.isEmpty {
            self.goLoginView()
            return
        }
        
        SVProgressHUD.showWithStatus(NSLocalizedString("Logout...", comment: "Logout..."))
        api.revokeAuthentication(
            {_ in
                SVProgressHUD.dismiss()
                
                api.resetAuth()
                
                let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let authInfo = app.authInfo
                authInfo.logout()
                
                self.goLoginView()
            },
            failure: {(error: JSON!)-> Void in
                SVProgressHUD.showErrorWithStatus(error["message"].stringValue)
            }
        )
    }
    
    func createEntry(blog: Blog, controller: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "EntryDetail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! EntryDetailTableViewController
        vc.object = Entry(json: ["id":"", "status":"Draft"])
        vc.blog = blog
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: vc, action: "closeButtonPushed:")
        controller.presentViewController(nav, animated: true, completion:
            {_ in
                vc.title = NSLocalizedString("Create entry", comment: "Create entry")
            }
        )
    }

    func createPage(blog: Blog, controller: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PageDetail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PageDetailTableViewController
        vc.object = Page(json: ["id":"", "status":"Draft"])
        vc.blog = blog
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: vc, action: "closeButtonPushed:")
        vc.title = NSLocalizedString("Create page", comment: "Create page")
        controller.presentViewController(nav, animated: true, completion:
            {_ in
                vc.title = NSLocalizedString("Create page", comment: "Create page")
            }
        )
    }
}

