//
//  MediaDetailController.swift
//  网易新闻
//
//  Created by wl on 16/3/6.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class MediaDetailController: UIViewController {

    var newsModel: VideoNewsModel!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var replyLabel: ChannelLabel!
    @IBOutlet weak var recommendLabel: ChannelLabel!
    @IBOutlet weak var containerScrollView: NewsContainerView!
    
    var hotReplyArray: [[ReplyModel]]?
    var newReplyArray: [[ReplyModel]]?
    
    var replyTableView: UITableView!
    let replyCellProvider = ReplyCellProvider()

    var recommendVideoArray: [VideoNewsModel]?
    
    var recommendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let replyLabelTap = UITapGestureRecognizer(target: self, action: "replyLabelTap")
        self.replyLabel.addGestureRecognizer(replyLabelTap)
        
        let recommendLabelTap = UITapGestureRecognizer(target: self, action: "recommendLabelTap")
        self.recommendLabel.addGestureRecognizer(recommendLabelTap)
        
        self.replyLabel.text = "\(self.newsModel.replyCount)跟帖"
        
        setupContainerScrollView()
        
        let hotUrl = "http://comment.api.163.com/api/json/post/list/new/hot/\(newsModel.replyBoard)/\(newsModel.replyid)/0/10/10/2/2"
        let newUrl = "http://comment.api.163.com/api/json/post/list/new/normal/\(newsModel.replyBoard)/\(newsModel.replyid)/desc/0/10/10/2/2"
        
        DataTool.loadReplyData((hotUrl, newUrl)) { (hotResponse, newResponse) -> Void in
            guard let hotReplyArray = hotResponse, newReplyArray = newResponse else {
                return
            }
            
            self.setupReplyTableView()
            
            self.hotReplyArray = hotReplyArray
            self.newReplyArray = newReplyArray
            self.replyCellProvider.hotReplyArray = hotReplyArray
            self.replyCellProvider.newReplyArray = newReplyArray
            self.showReplyView()
            self.recommendTableView.reloadData()
        }
        
        DataTool.loadVideoNewsData("http://c.3g.163.com/nc/video/detail/\(newsModel.vid).html") { (response) -> Void in

            guard let recommendVideoArray = response else {
                return
            }
            self.setupRecommendTableView()
            self.recommendVideoArray = recommendVideoArray
            self.recommendTableView.reloadData()
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    deinit {
        print("MediaDetailController===deinit")
    }
    
    func setupContainerScrollView() {

        self.containerScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * 2, 0)
        self.containerScrollView.pagingEnabled = true
        self.containerScrollView.delegate = self

    }
    
    func setupReplyTableView() {
        self.replyTableView = UITableView()
        self.replyTableView.registerNib(UINib(nibName: "ReplyCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ReplyCell")
        self.replyTableView.estimatedRowHeight = 100
        self.replyTableView.rowHeight = UITableViewAutomaticDimension
        self.replyTableView.dataSource = replyCellProvider
        self.replyTableView.delegate = replyCellProvider
        self.replyCellProvider.tableView = self.replyTableView
        replyTableView.frame = self.containerScrollView.bounds
        self.containerScrollView.addSubview(self.replyTableView)
    }
    
    
    func setupRecommendTableView() {
        self.recommendTableView = UITableView()
        self.recommendTableView.registerNib(UINib(nibName: "RecommendCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RecommendCell")
        self.recommendTableView.rowHeight = 80
        self.recommendTableView.dataSource = self
//        self.recommendTableView.delegate = self
        recommendTableView.frame = CGRect(x: self.containerScrollView.bounds.width, y: 0, width: self.containerScrollView.bounds.width, height: self.containerScrollView.bounds.size.height)
        self.containerScrollView.addSubview(self.recommendTableView)
    }

    
    func showReplyView() {
        self.containerScrollView.setContentOffset(CGPointZero, animated: false)
    }
    
    func showRecommendView() {
        let offset = CGPoint(x: self.containerScrollView.bounds.width, y: 0)
        self.containerScrollView.setContentOffset(offset, animated: false)
    }
    
    func replyLabelTap() {
        UIView.animateWithDuration(0.3) {
            self.recommendLabel.scale = 0
            self.replyLabel.scale = 1
        }
        showReplyView()
    }
    
    func recommendLabelTap() {
        UIView.animateWithDuration(0.3) {
            self.recommendLabel.scale = 1
            self.replyLabel.scale = 0
        }
        showRecommendView()
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
extension MediaDetailController:  UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendVideoArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendCell") as! RecommendCell
        
        let model = self.recommendVideoArray![indexPath.row]
        
        cell.videoNewsModel = model
        return cell
    }

}

extension MediaDetailController: UIScrollViewDelegate {
    /**
     每次滑动newsContainerView都会调用，用来制造频道label的动画效果
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
        let leftIndex = Int(currentIndex)
        let rightIndex = leftIndex + 1
        print(scrollView.contentOffset.x)
        guard currentIndex == 0 || rightIndex == 1 else {
            return
        }
        let rightScale = currentIndex - CGFloat(leftIndex)
        let leftScale = CGFloat(rightIndex) - currentIndex
        
        self.recommendLabel.scale = rightScale
        self.replyLabel.scale = leftScale
    }
}