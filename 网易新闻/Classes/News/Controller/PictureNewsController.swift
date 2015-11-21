//
//  PictureNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/20.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit
// TODO: 最后一页推荐页使用cyclePictureView是做不了的，暂时先这样
class PictureNewsController: UIViewController, CyclePictureViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleContainerView: UIView!
    
    @IBOutlet weak var replyCountBtn: UIButton!
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var NewsTextView: UITextView!
    
    var newsModel: NewsModel?
    var newsPictureModel: NewsPictureModel? {
        didSet {
            self.setupSubview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.newsModel?.photosetID != nil)
        
        DataTool.loadPictureNewsData(self.newsModel!.photosetID!) { (newsPictureModel) -> Void in
            guard newsPictureModel != nil else {
                return
            }
            
            self.newsPictureModel = newsPictureModel
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func setupSubview() {
        
        guard let newsPictureModel = self.newsPictureModel else {
            return
        }
        
        self.cyclePictureView.autoScroll = false
        self.cyclePictureView.needEndlessScroll = false
        self.cyclePictureView.showPageControl = false
        self.cyclePictureView.delegate = self
        self.cyclePictureView.placeholderImage = UIImage(named: "placeholder")
        self.cyclePictureView.imageURLArray =  {
            var array: [String] = []
            for photo in newsPictureModel.photos {
                array.append(photo.imgurl)
            }
            return array
        }()
        self.cyclePictureView.pictureContentMode = .ScaleAspectFit
        self.titleLabel.text = newsPictureModel.setname
        self.pageLabel.text = "1/\(newsPictureModel.imgsum)"
        self.NewsTextView.text = newsPictureModel.photos[0].note
        
        if let replyCount = self.newsModel?.replyCount {
            if replyCount > 10000 {
                self.replyCountBtn.setTitle(String(format: "%.1f万跟帖", Float(replyCount)/10000.0), forState: .Normal)
            }else {
                self.replyCountBtn.setTitle("\(replyCount)跟帖", forState: .Normal)
            }
        }
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - cyclePictureView代理
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.topView.alpha = 1 - self.topView.alpha
            self.titleContainerView.alpha = 1 - self.titleContainerView.alpha
            self.NewsTextView.alpha = 1 - self.NewsTextView.alpha
             self.bottomView.alpha = 1 -  self.bottomView.alpha
        }
    }
    
    /**
    这个协议方法是自己修改源码添加的，原本是没有的
    */
    func cyclePictureViewDidEndDecelerating(cyclePictureView: CyclePictureView) {
        guard let newsPictureModel = self.newsPictureModel else {
            return
        }
        let index = cyclePictureView.getCurrentCellIndex()
        self.pageLabel.text = "\(index+1)/\(newsPictureModel.imgsum)"
        self.NewsTextView.text = newsPictureModel.photos[index].note
    }
}
