//
//  SecondLaunchView.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit
import Kingfisher

class SecondLaunchView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showAtController(vc: UIViewController, image: String?) {
        
        guard let imageStr = image  else {
            return
        }
    
        vc.view.addSubview(self)
        self.frame = vc.view.bounds
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self)
        
        self.imageView.kf_setImageWithURL(NSURL(string: imageStr)!)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.removeFromSuperview()
        }
    }
    
    deinit {
//        print("SecondLaunchView--deinit")
    }
    
}
