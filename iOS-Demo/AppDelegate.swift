//
//  AppDelegate.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit
import GDPerformanceView_Swift
//import AvoidCrash

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        AvoidCrash.becomeEffective()
        PerformanceMonitor.shared().start()
        
        return true
    }

    // MARK: UISceneSession Lifecycle



}

