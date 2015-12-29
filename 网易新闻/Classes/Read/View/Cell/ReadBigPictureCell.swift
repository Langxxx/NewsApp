//
//  ReadBigPictureCell.swift
//  网易新闻
//
//  Created by wl on 15/12/28.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ReadBigPictureCell: NewsCell {

    
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var title2recommendConstraint: NSLayoutConstraint!
    override var newsModel: NewsModel? {
        didSet {
            self.setupSubView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupSubView() {
        guard let readNewsModel = self.newsModel as? ReadNewsModel else {
            return
        }
        
        if let _ = readNewsModel.recReason {
            self.recommendView.hidden = false
            self.title2recommendConstraint.priority = 999
        }else {
            self.recommendView.hidden = true
            self.title2recommendConstraint.priority = 500
        }
        
        self.iconImageView.sd_setImageWithURL(NSURL(string: readNewsModel.imgsrc), placeholderImage: UIImage(named: "placeholder"))
        self.titleLabel.text = readNewsModel.title
        self.sourceLabel.text = readNewsModel.source
    }
}
