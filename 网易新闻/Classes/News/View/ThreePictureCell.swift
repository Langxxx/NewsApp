//
//  ThreePictureCell.swift
//  网易新闻
//
//  Created by wl on 15/11/15.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ThreePictureCell: NewsCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
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
        
        self.titleLabel.text = self.newsModel?.title
        if let replyCount = self.newsModel?.replyCount {
            self.replyCountLabel.text = "\(replyCount)跟贴"
        }
        self.firstImageView.kf_setImageWithURL(NSURL(string: self.newsModel!.imgsrc)!, placeholderImage: UIImage(named: "placeholder"))
        self.secondImageView.kf_setImageWithURL(NSURL(string: self.newsModel!.imgextra![0])!, placeholderImage: UIImage(named: "placeholder"))
        self.thirdImageView.kf_setImageWithURL(NSURL(string: self.newsModel!.imgextra![1])!, placeholderImage: UIImage(named: "placeholder"))
    }
}
