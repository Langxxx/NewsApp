//
//  NewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class NewsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let secondLaunchView = NSBundle.mainBundle().loadNibNamed("SecondLaunchView", owner: self, options: nil).first as! SecondLaunchView
        
        secondLaunchView.showAtController(self, image: DataTool.getLuanchImageUrl())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
