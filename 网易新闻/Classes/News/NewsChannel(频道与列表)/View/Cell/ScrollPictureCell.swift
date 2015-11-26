//
//  ScrollPictureCell.swift
//  网易新闻
//
//  Created by wl on 15/11/14.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ScrollPictureCell: NewsCell, CyclePictureViewDelegate{

    @IBOutlet weak var cyclePictureView: CyclePictureView!
    
    override var newsModel: NewsModel? {
        didSet {
            self.setupSubView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cyclePictureView.autoScroll = false
        self.cyclePictureView.pageControlAliment = .RightBottom
        self.cyclePictureView.detailLableTextFont = UIFont.systemFontOfSize(15)
        self.cyclePictureView.placeholderImage = UIImage(named: "placeholder")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSubView() {
        self.cyclePictureView.imageURLArray = {
            assert(self.newsModel!.ads != nil)
            var array: [String] = []

            array.append(self.newsModel!.imgsrc)
            for ads in self.newsModel!.ads! {
                array.append(ads.imgsrc)
            }
            return array
        }()
        
        self.cyclePictureView.imageDetailArray = {
            assert(self.newsModel!.ads != nil)
            var array: [String] = []
            
            array.append(self.newsModel!.title)
            for ads in self.newsModel!.ads! {
                array.append(ads.title)
            }
            return array
        }()
        // 这个cell的控制器为代理
        self.cyclePictureView.delegate = {
                for (var next = self.superview; next != nil; next = next?.superview) {
                    let nextResponder = next?.nextResponder()
                    if nextResponder!.isKindOfClass(NewsListContorller.self) {
                        return nextResponder as! NewsListContorller
                    }
                }
                return nil
            }()
    }

}
