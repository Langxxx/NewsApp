//
//  BigPictureCell.swift
//  网易新闻
//
//  Created by wl on 15/11/15.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class BigPictureCell: NewsCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var digestLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
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
        self.digestLabel.text = self.newsModel?.digest
        self.subjectLabel.hidden = true
        if let tags = self.newsModel?.tags {
            self.subjectLabel.hidden = false
            self.subjectLabel.text = tags
            self.subjectLabel.textColor = UIColor.blueColor()
        }
        
    }
}
