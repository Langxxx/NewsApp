//
//  MediaDetailController.swift
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

class MediaDetailController: UIViewController {

    var currentVideoModel: VideoNewsModel!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var replyLabel: ChannelLabel!
    @IBOutlet weak var recommendLabel: ChannelLabel!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    var hotReplyArray: [[ReplyModel]]?
    var newReplyArray: [[ReplyModel]]?
    
    var replyTableView: UITableView?
    let replyCellProvider = ReplyCellProvider()

    var recommendVideoArray: [VideoNewsModel]?
    
    var recommendTableView: UITableView?
    
    lazy var controlView = {
        return NSBundle.mainBundle().loadNibNamed("PlayerControlView", owner: nil, options: nil).last as! PlayerControlView
    }()
    
    var playerView: WLVideoPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGestureRecognizer()
        self.setupContainerScrollView()
        self.loadReplyData()
        self.loadRecommendData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    override func viewWillDisappear(animated: Bool) {
       self.playerView?.removeFromSuperview()
        self.playerView = nil
    }
    deinit {
        print("MediaDetailController===deinit")
    }
    
    
    func setupGestureRecognizer() {
        let replyLabelTap = UITapGestureRecognizer(target: self, action: "replyLabelTap")
        self.replyLabel.addGestureRecognizer(replyLabelTap)
        
        let recommendLabelTap = UITapGestureRecognizer(target: self, action: "recommendLabelTap")
        self.recommendLabel.addGestureRecognizer(recommendLabelTap)
    }
    
    func setupVideoPlayer() {
        if self.playerView == nil {
            self.playerView = WLVideoPlayerView(url: NSURL(string: self.currentVideoModel.mp4_url))
            self.playerView?.customControlView = controlView
            self.playerView?.placeholderView = UIImageView(image: UIImage(named: "placeholder"))
            self.playerView?.playInView(self.videoView)
        }
    }
    
    func loadReplyData() {
        
        let hotUrl = "http://comment.api.163.com/api/json/post/list/new/hot/\(currentVideoModel.replyBoard)/\(currentVideoModel.replyid)/0/10/10/2/2"
        let newUrl = "http://comment.api.163.com/api/json/post/list/new/normal/\(currentVideoModel.replyBoard)/\(currentVideoModel.replyid)/desc/0/10/10/2/2"
        
        DataTool.loadReplyData((hotUrl, newUrl)) { (hotResponse, newResponse) -> Void in
            guard let hotReplyArray = hotResponse, newReplyArray = newResponse else {
                return
            }
            
            self.setupReplyTableView()
            self.setupVideoPlayer()
            
            self.hotReplyArray = hotReplyArray
            self.newReplyArray = newReplyArray
            self.replyCellProvider.hotReplyArray = hotReplyArray
            self.replyCellProvider.newReplyArray = newReplyArray
            self.replyTableView?.reloadData()
        }
    }
    
    func loadRecommendData() {
        DataTool.loadVideoNewsData("http://c.3g.163.com/nc/video/detail/\(currentVideoModel.vid).html") { (response) -> Void in
            
            guard let recommendVideoArray = response else {
                return
            }
            
            self.setupRecommendTableView()
            
            self.recommendVideoArray = recommendVideoArray
            self.recommendTableView?.reloadData()
        }
    }
    
    func setupContainerScrollView() {

        self.containerScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * 2, 0)
        self.containerScrollView.pagingEnabled = true
        self.containerScrollView.delegate = self

    }
    
    func setupReplyTableView() {
        
        if self.replyTableView == nil {
            
            let replyTableView = UITableView()
            replyTableView.registerNib(UINib(nibName: "ReplyCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ReplyCell")
            replyTableView.estimatedRowHeight = 100
            replyTableView.rowHeight = UITableViewAutomaticDimension
            replyTableView.dataSource = replyCellProvider
            replyTableView.delegate = replyCellProvider
            replyCellProvider.tableView = replyTableView
            replyTableView.frame = self.containerScrollView.bounds
            self.containerScrollView.addSubview(replyTableView)
            
            self.replyTableView = replyTableView
        }
        
        
        self.replyLabel.text = "\(self.currentVideoModel.replyCount)跟帖"
    }
    
    
    func setupRecommendTableView() {
        
        if self.recommendTableView == nil {
            
            let recommendTableView = UITableView()
            
            recommendTableView.registerNib(UINib(nibName: "RecommendCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RecommendCell")
            recommendTableView.rowHeight = 80
            recommendTableView.dataSource = self
            recommendTableView.delegate = self
            recommendTableView.frame = CGRect(x: self.containerScrollView.bounds.width, y: 0, width: self.containerScrollView.bounds.width, height: self.containerScrollView.bounds.size.height)
            self.containerScrollView.addSubview(recommendTableView)
            
            self.recommendTableView = recommendTableView
        }
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
extension MediaDetailController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendVideoArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendCell") as! RecommendCell
        
        let model = self.recommendVideoArray![indexPath.row]
        
        cell.videoNewsModel = model
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let newVideoModel = self.recommendVideoArray![indexPath.row]
        
        self.replyLabel.text = "\(newVideoModel.replyCount)跟帖"
        self.playerView?.contentURL = NSURL(string: newVideoModel.mp4_url)
        self.playerView?.play()
        self.currentVideoModel = newVideoModel
        self.loadReplyData()
    }
}

extension MediaDetailController: UIScrollViewDelegate {
    /**
     每次滑动newsContainerView都会调用，用来制造频道label的动画效果
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.isKindOfClass(UITableView.self) {
            return
        }
        
        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
        let leftIndex = Int(currentIndex)
        let rightIndex = leftIndex + 1
        guard currentIndex == 0 || rightIndex == 1 else {
            return
        }
        let rightScale = currentIndex - CGFloat(leftIndex)
        let leftScale = CGFloat(rightIndex) - currentIndex
        
        self.recommendLabel.scale = rightScale
        self.replyLabel.scale = leftScale
    }
}