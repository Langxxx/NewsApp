//
//  SpecialNewsCell.swift
//  网易新闻
//
//  Created by wl on 15/11/18.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class SpecialNewsCell: NewsCell {
    
    override var newsModel: NewsModel? {
        didSet {
//            self.setupSubView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
