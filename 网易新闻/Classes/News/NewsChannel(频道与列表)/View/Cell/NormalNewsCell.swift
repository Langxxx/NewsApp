//
//  NormalNewsCell.swift
//  网易新闻
//
//  Created by wl on 15/11/14.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit


class NormalNewsCell: NewsCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var digestLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!

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

        self.newsImageView.sd_setImageWithURL(NSURL(string: self.newsModel!.imgsrc)!, placeholderImage: UIImage(named: "placeholder"))
        self.titleLabel.text = self.newsModel?.title
        self.digestLabel.text = self.newsModel?.digest
        
        self.replyCountLabel.hidden = true
        self.replyImageView.hidden = true
        self.subjectLabel.hidden = true
        if let _ = self.newsModel?.specialID {
            self.subjectLabel.hidden = false
            self.subjectLabel.text = "专题"
            self.subjectLabel.textColor = UIColor.redColor()
        }else if let tags = self.newsModel?.tags {
            self.subjectLabel.hidden = false
            self.subjectLabel.text = tags
            self.subjectLabel.textColor = UIColor.blueColor()
        }else if let replyCount = self.newsModel?.replyCount {
            self.replyCountLabel.text = "\(replyCount)跟贴"
            self.replyCountLabel.hidden = false
            self.replyImageView.hidden = false
        }
        
    }

}
