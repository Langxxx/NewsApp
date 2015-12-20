//
//  SubReplyCell.swift
//  网易新闻
//
//  Created by wl on 15/12/18.
//  Copyright © 2015年 wl. All rights reserved.
//  子评论显示的cell

import UIKit

class SubReplyCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    
    var replyModel: ReplyModel! {
        didSet {
            self.userNameLabel.text = replyModel.name
            self.addressLabel.text = replyModel.userAddress.componentsSeparatedByString(" ").first
            self.messageLabel.text = replyModel.message
            self.floorLabel.text = String(replyModel.floor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 251/255.0, green: 245/255.0, blue: 221/255.0, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
