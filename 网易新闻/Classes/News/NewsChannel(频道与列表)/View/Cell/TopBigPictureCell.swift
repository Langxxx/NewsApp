//
//  TopBigPictureCell.swift
//  网易新闻
//
//  Created by wl on 15/11/15.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class TopBigPictureCell: NewsCell {


    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var newsModel: NewsModel? {
        didSet {
            self.setupSubView()
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
    func setupSubView() {
        
        self.bigImageView?.sd_setImageWithURL(NSURL(string: self.newsModel!.imgsrc)!, placeholderImage: UIImage(named: "placeholder"))
        self.titleLabel.text = self.newsModel?.title
        
    }

}
