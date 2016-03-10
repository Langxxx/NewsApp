//
//  SubReplyCell.swift
//  网易新闻
//
//  Created by wl on 15/12/18.
//  Copyright © 2015年 wl. All rights reserved.
//  子评论显示的cell
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class SubReplyCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    
    var replyModel: ReplyModel! {
        didSet {
            self.userNameLabel.text = replyModel.name
            self.addressLabel.text = replyModel.userAddress.componentsSeparatedByString("&nbsp").first
            self.messageLabel.text = replyModel.message
            self.floorLabel.text = String(replyModel.floor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView =  UIImageView(frame: self.bounds)
        imageView.image = UIImage(named: "comment_roof_1")
        self.backgroundView = imageView
    }


}
