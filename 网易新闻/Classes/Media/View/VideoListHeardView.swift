//
//  VideoListHeardView.swift
//  网易新闻
//
//  Created by wl on 16/1/17.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class VideoListHeardView: UIView {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var label4: UILabel!
    
    var videoSidArray: [VideoSidModel]! {
        didSet {
            setupSubView()
        }
    }
    
    var imageViewArray: [UIImageView]!
    var labelArray: [UILabel]!

    override func awakeFromNib() {
        imageViewArray = [imageView1, imageView2, imageView3, imageView4]
        labelArray = [label1, label2, label3, label4]
    }
    
    func setupSubView() {
        for (idx, imageView) in imageViewArray.enumerate() {
            let videoSidModel = self.videoSidArray[idx]
            imageView.sd_setImageWithURL(NSURL(string: videoSidModel.imgsrc))
        }
        
        for (idx, label) in labelArray.enumerate() {
            let videoSidModel = self.videoSidArray[idx]
            label.text = videoSidModel.title
        }
    }
    
    static func videoListHeardView(videoSidArray: [VideoSidModel]) -> VideoListHeardView {
        let view = NSBundle.mainBundle().loadNibNamed("VideoListHeardView", owner: nil, options: nil).last as! VideoListHeardView
        view.frame.size.height = 80
        view.videoSidArray = videoSidArray
        return view
    }

}
