//
//  AuthInfo.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import LUKeychainAccess

class AuthInfo: NSObject {
    var username = ""
    var password = ""
    var endpoint = ""
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(username, forKey: "username")
        userDefaults.setObject(endpoint, forKey: "endpoint")
        userDefaults.synchronize()

        let keychainAccess = LUKeychainAccess.standardKeychainAccess()
        keychainAccess.setString(password, forKey: "password")
    }
    
    func load() {
        var value: String?
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        value = userDefaults.objectForKey("username") as? String
        username = (value != nil) ? value! : ""
        value = userDefaults.objectForKey("endpoint") as? String
        endpoint = (value != nil) ? value! : ""

        let keychainAccess = LUKeychainAccess.standardKeychainAccess()
        value = keychainAccess.stringForKey("password")
        password = (value != nil) ? value! : ""
    }
    
    func clear() {
        username = ""
        password = ""
        endpoint = ""
    }
    
    func logout() {
        self.clear()
        self.save()
    }
}
