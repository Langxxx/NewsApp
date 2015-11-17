//
//  NewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class NewsController: UIViewController, UIScrollViewDelegate {
    
 // MARK: - 属性
//========================================================
// MARK: 频道列表属性
//========================================================
    @IBOutlet weak var channelScrollView: UIScrollView!
    var channels: ChannelBox = ChannelBox()
    var labelArray: [ChannelLabel] = []
    var currentChannelsLabel: ChannelLabel!
    var maxchannelsCount: Int = 20
    var channelCount: Int!
    let labelMargin: CGFloat = 25
//========================================================
// MARK: 新闻列表属性
//========================================================
    @IBOutlet weak var newsContainerView: NewsContainerView!
    var newsListVcArray: [NewsListContorller] = []

 // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        SecondLaunchView.showAtWindow(DataTool.getLuanchImageUrl())

        self.setupChannelScrollView()
        self.setupNewsContainerView()
        self.showFirstNewsList()
    }

    /**
    channelScrollView的一些初始化操作，
    用来创建默认的新闻频道
    */
    func setupChannelScrollView() {
        channelCount = channels.channels.count > maxchannelsCount ? maxchannelsCount : channelCount
        let labelX: ([UILabel]) -> CGFloat = {
            (labels: [UILabel]) -> CGFloat in
            
            let lastObj = labels.last
            guard let label = lastObj else {
                return self.labelMargin
            }
            return CGRectGetMaxX(label.frame) + self.labelMargin
        }
        
        for i in 0..<channelCount {
            let label = ChannelLabel()
            label.text = self.channels[i].channelName
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize(14)
            label.sizeToFit()
            label.frame.origin.x = labelX(self.labelArray)
            label.frame.origin.y = (self.channelScrollView.bounds.height -  label.bounds.height) * 0.5
            //添加点击事件
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("channelLabelClick:")))
            label.userInteractionEnabled = true
            label.tag = i
            self.labelArray.append(label)
            self.channelScrollView.addSubview(label)
        }
        self.channelScrollView.contentSize = CGSizeMake(labelX(self.labelArray), 0)
    }
    /**
    newsContainerView的一些初始化操作，
    根据默认新闻频道，创建所有可能需要展示的新闻列表
    */
    func setupNewsContainerView() {
        
        for i in 0..<self.channelCount {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("NewsListContorller") as! NewsListContorller
            vc.channel = self.channels[i].channelName
            vc.channelUrl = self.channels[i].channelUrl
            self.newsListVcArray.append(vc)
            //成为自控制器，方便以后调用
            self.addChildViewController(vc)
        }
        
        self.newsContainerView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * CGFloat(self.newsListVcArray.count), 0)
        self.newsContainerView.pagingEnabled = true
        self.newsContainerView.delegate = self
    }
    /**
    显示默认的新闻列表(头条频道)
    */
    func showFirstNewsList() {
        
        let vc = self.newsListVcArray.first!
        self.newsContainerView.showViewInScrollView(vc.tableView, showViewIndex: 0)

        let label = self.labelArray.first!
        currentChannelsLabel = label
        label.scale = 1
    }
    /**
    频道label的点击手势回调方法，
    当点击事件发生后，将新闻列表切换到被点击label对应的新闻列表
    */
    func channelLabelClick(recognizer: UITapGestureRecognizer) {
    
        let label = recognizer.view as! ChannelLabel
        let index = label.tag
        
        self.currentChannelsLabel.scale = 0
        label.scale = 1
        
        let offsetX = CGFloat(index) * self.newsContainerView.bounds.width
        let offset = CGPointMake(offsetX, 0)
        //这个方法animated为true才会导致scrollViewDidEndScrollingAnimation代理方法被调用
        self.newsContainerView.setContentOffset(offset, animated: false)
        //代码滚动到显示了那一"页"
        self.scrollViewDidEndScrollingAnimation(self.newsContainerView)
    }
}


// MARK: - UIScrollView的代理方法(newsContainerView)

extension NewsController {
    
    /**
    每次滑动newsContainerView都会调用，用来制造频道label的动画效果
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
        let leftIndex = Int(currentIndex)
        let rightIndex = leftIndex + 1

        guard currentIndex > 0 && rightIndex <  self.labelArray.count else {
            return
        }
        let rightScale = currentIndex - CGFloat(leftIndex)
        let leftScale = CGFloat(rightIndex) - currentIndex
        
        let rightLabel = self.labelArray[rightIndex]
        let leftLabel = self.labelArray[leftIndex]

        rightLabel.scale = rightScale
        leftLabel.scale = leftScale
    }
    
    /**
    这个是在newsContainerView减速停止的时候开始执行，
    用来切换需要显示的新闻列表和让频道标签处于合适的位置
    */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    /**
    这个是当用户用代码导致滚动时候调用列如setContentOffset，
    用来切换需要显示的新闻列表和让频道标签处于合适的位置
    */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        // 让频道标签处于合适的位置
        let currentLabel = self.labelArray[index]
        self.currentChannelsLabel = currentLabel
        var offsetX = currentLabel.center.x - self.channelScrollView.bounds.width * 0.5
        let maxOffset = self.channelScrollView.contentSize.width - self.channelScrollView.bounds.width
        if offsetX > 0{
            offsetX = offsetX > maxOffset ? maxOffset : offsetX
        }else {
            offsetX = 0
        }
        let offset = CGPointMake(offsetX, 0)
        self.channelScrollView.setContentOffset(offset, animated: true)
        
        // 切换需要显示的控制器
        let vc = self.newsListVcArray[index]
        self.newsContainerView.showViewInScrollView(vc.tableView, showViewIndex: index)

    }

}


