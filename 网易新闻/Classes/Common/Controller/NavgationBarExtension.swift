//
//  NavgationBarExtension.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    class func setupStyle() {
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.whiteColor()
        navBar.barTintColor = UIColor(red: 212 / 255.0, green: 25 / 255.0, blue: 38 / 255.0, alpha: 1.0)
        navBar.translucent = false
        
        let attr = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        navBar.titleTextAttributes = attr
        
    }

}


