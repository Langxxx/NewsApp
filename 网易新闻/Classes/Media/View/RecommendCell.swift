//
//  RecommendCell.swift
//  网易新闻
//
//  Created by wl on 16/3/6.
//  Copyright © 2016年 wl. All rights reserved.
//
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class RecommendCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var videoNewsModel: VideoNewsModel! {
        didSet {
            setupSubView() 
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupSubView() {
        self.iconImageView.sd_setImageWithURL(NSURL(string: self.videoNewsModel.cover)!, placeholderImage: UIImage(named: "placeholder"))
        self.titleLabel.text = self.videoNewsModel.title
        self.timeLabel.text = String(format:"%02d:%02d", self.videoNewsModel.length/60, self.videoNewsModel.length%60)
    }
}
