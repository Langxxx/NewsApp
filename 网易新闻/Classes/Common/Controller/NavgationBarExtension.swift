//
//  NavgationBarExtension.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//  设置UINavigationBar显示样式

/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/

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


