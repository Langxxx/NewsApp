//
//  ReadHeadView.swift
//  网易新闻
//
//  Created by wl on 15/12/27.
//  Copyright © 2015年 wl. All rights reserved.
//
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class ReadHeadView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    static func readHeadView() -> ReadHeadView {
        let view = NSBundle.mainBundle().loadNibNamed("ReadHeadView", owner: nil, options: nil).last as! ReadHeadView
        view.frame.size.height = 110
       return view
    }
    

}
