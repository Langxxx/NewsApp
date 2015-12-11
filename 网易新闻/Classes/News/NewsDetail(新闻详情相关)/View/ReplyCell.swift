//
//  ReplyCell.swift
//  网易新闻
//
//  Created by wl on 15/12/9.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {

    
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var supposeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    
    var replyModelArray: [ReplyModel]! {
        didSet {
            let model = self.replyModelArray.last
            nameLabel.text = model?.name
            addressLabel.text = model?.userAddress.componentsSeparatedByString("&nbsp").first
            supposeLabel.text = model?.suppose
            messageLabel.text = model?.message
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
