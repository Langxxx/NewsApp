//
//  SecondLaunchView.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//  第二启动页面，使用xib

import UIKit
import Kingfisher

class SecondLaunchView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func showAtWindow(image: String?) {
        
        guard let imageStr = image  else {
            return
        }
        
        let secondLaunchView = NSBundle.mainBundle().loadNibNamed("SecondLaunchView", owner: self, options: nil).first as! SecondLaunchView

        let window = UIApplication.sharedApplication().keyWindow
        secondLaunchView.frame = window!.bounds
        window?.addSubview(secondLaunchView)
        
        secondLaunchView.imageView.sd_setImageWithURL(NSURL(string: imageStr)!)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            secondLaunchView.removeFromSuperview()
        }
    }
    
    deinit {
//        print("SecondLaunchView--deinit")
    }
    
}
