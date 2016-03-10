//
//  ReplyHeardView.swift
//  网易新闻
//
//  Created by wl on 15/12/11.
//  Copyright © 2015年 wl. All rights reserved.
//
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class ReplyHeardView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleButton: UIButton!
    
    static func ReplyHeardViewWithTitle(title: String) -> ReplyHeardView {
        let view = NSBundle.mainBundle().loadNibNamed("ReplyHeardView", owner: nil, options: nil).last as! ReplyHeardView
        view.titleButton.setTitle(title, forState: .Normal)
        
        return view
    }

}
