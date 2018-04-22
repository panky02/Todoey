//
//  AppDelegate.swift
//  Todoey
//
//  Created by Pankaj Kumar on 16/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //path for .plist file which stores data for USERDEFAULTS method
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
       
        do{
            _ = try Realm()
        } catch{
            print("some error in intialising Realm \(error)")
        }
        
        return true
    }

    
    
    

}

