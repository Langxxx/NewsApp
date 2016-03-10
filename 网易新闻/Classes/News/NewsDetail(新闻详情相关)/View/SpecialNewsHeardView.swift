//
//  SpecialNewsHeardView.swift
//  网易新闻
//
//  Created by wl on 15/11/19.
//  Copyright © 2015年 wl. All rights reserved.
//  专题新闻的头部
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

protocol SpecialNewsHeardViewDelegate : class{
    func specialNewsTopicBtnClik(index: Int)
}

class SpecialNewsHeardView: UIView {

    weak var delegate: SpecialNewsHeardViewDelegate?
    /// 头部图片
    var heardImageView: UIImageView
    /// 话题标签的数组
    var topicBtnArray: [UIButton]
    /// 每个标签之间的距离
    var btnMarign: CGFloat = 10
    /// 每一行的标签个数
    let row: Int = 4
    /// 标签的宽度
    let btnHeight: CGFloat = 20
    var btnwidth: CGFloat {
        get {
            return (self.frame.width - (CGFloat(row) * btnMarign + btnMarign)) / CGFloat(row)
        }
    }
    /// 头部图片高度
    let heardImageViewHeight: CGFloat = 64
    
    init(topics: [Topic], topImageStr: String, delegate: SpecialNewsHeardViewDelegate) {
        
        heardImageView = UIImageView()
        heardImageView.sd_setImageWithURL(NSURL(string: topImageStr)!, placeholderImage: UIImage(named: "placeholder"))
        topicBtnArray = []
        
        let height = CGFloat(topics.count % row == 0 ? topics.count / row : topics.count / row + 1) * (btnHeight + btnMarign) + btnMarign + heardImageViewHeight
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , height))
        
        self.delegate = delegate
        self.addSubview(heardImageView)
        for (index, topic) in topics.enumerate() {
            let btn = UIButton()
            btn.tag = index
            btn.titleLabel?.textAlignment = .Center
            btn.setTitle(topic.tname, forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setBackgroundImage(UIImage(named: "topicBtn"), forState: .Normal)
            btn.addTarget(self, action: Selector("btnClik:"), forControlEvents: .TouchDown)
            topicBtnArray.append(btn)
            self.addSubview(btn)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.heardImageView.frame = CGRectMake(0, 0, self.frame.width, heardImageViewHeight)
        heardImageView.backgroundColor = UIColor.blackColor()
        for (index, btn) in self.topicBtnArray.enumerate() {
            let btnx = btnMarign + CGFloat(index % row) * (btnMarign + btnwidth)
            let btny = CGFloat(index / row) * (btnHeight + btnMarign) +  btnMarign + heardImageViewHeight
            btn.frame = CGRectMake(btnx, btny, btnwidth, btnHeight)

        }

    }
    /**
    当某个话题标签点击时，被调用。通知代理
    */
    func btnClik(btn: UIButton) {
        self.delegate?.specialNewsTopicBtnClik(btn.tag)
    }

}
