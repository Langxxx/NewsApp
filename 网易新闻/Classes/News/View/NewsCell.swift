//
//  NewsCell.swift
//  网易新闻
//
//  Created by wl on 15/11/14.
//  Copyright © 2015年 wl. All rights reserved.
//  一个基类

import UIKit

class NewsCell: UITableViewCell {
    
    var newsModel: NewsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
