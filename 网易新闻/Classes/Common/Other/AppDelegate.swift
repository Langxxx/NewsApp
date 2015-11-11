//
//  AppDelegate.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UITabBar.setupStyle()
        UINavigationBar.setupStyle()
        return true
    }


}

