//
//  MediaController.swift
//  网易新闻
//
//  Created by wl on 16/1/17.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class MediaController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videoSidArray: [VideoSidModel]?
    
    var videoNewsArray: [VideoNewsModel]? {
        didSet {
            self.tableView.tableHeaderView = VideoListHeardView.videoListHeardView(self.videoSidArray!)
            self.tableView.reloadData()
            //重置播放器
            self.resetPlayer()
        }
    }
    /// 正在播放视频的URL
    var playingNewsUrl: String = ""
    /// 正在播放视频的播放器
    var playingPlayer: WLVideoPlayerView?
    /// 播放视频的那个cell，解决重用问题
    var playingCell: VideoCell?
    /// 播放视频的那个cell的索引，解决重用问题
    var playingCellIndexPath: NSIndexPath?
    
    lazy var controlView = {
        return NSBundle.mainBundle().loadNibNamed("PlayerControlView", owner: nil, options: nil).last as! PlayerControlView
    }()
    
 // MARK: - 方法
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 5
        self.tableView.sectionFooterHeight = 5
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //集成上拉与下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("requestInfo"))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("requestMoreInfo"))
        
        self.tableView.mj_header.beginRefreshing()
        
        // 监听播放视频的通知事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playNewsVideo:", name: PlayerButtonDidClikNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.resetPlayer()
    }
    
    func requestInfo() {
        DataTool.loadMediaNewsData("http://c.m.163.com/nc/video/home/0-10.html") { (sid, news) -> Void in
            self.tableView.mj_header.endRefreshing()
            guard let videoSidArray = sid, videoNewsArray = news else {
                return
            }
            self.videoSidArray = videoSidArray
            self.videoNewsArray = videoNewsArray
        }
    }
    
    func requestMoreInfo() {

        DataTool.loadMediaNewsData("http://c.m.163.com/nc/video/home/\(self.videoNewsArray!.count)-10.html") { (sid, news) -> Void in
            self.tableView.mj_footer.endRefreshing()
            guard let videoNewsArray = news else {
                return
            }

            self.videoNewsArray! += videoNewsArray
        }
    }
    
    /**
     析构方法
     */
    deinit {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     视频播放通知事件的回调函数，在点击某一个cell的播放按钮的时候调用，
     进行视频新闻播放
     - parameter notification: 一些播放视频所需要的信息
     */
    func playNewsVideo(notification: NSNotification) {

        let dict = notification.userInfo
        guard let urlStr = dict?["url"] as? String,
            let inView = dict?["inView"] as? UIView,
            let playingCell = dict?["cell"] as? VideoCell
            where urlStr != self.playingNewsUrl else {
            print("重复播放")
            return
        }
        
        self.playingPlayer?.removeFromSuperview()
        self.playingPlayer = nil
        
        self.playingCell = playingCell
        self.playingCellIndexPath = self.tableView.indexPathForCell(playingCell)
        
        self.playingPlayer = WLVideoPlayerView(url: NSURL(string: urlStr))
        self.playingPlayer?.customControlView = controlView
        self.playingPlayer?.placeholderView = UIImageView(image: UIImage(named: "placeholder"))
        self.playingPlayer?.playInView(inView)
        
    }
    /**
     重置播放器的一些参数,在重新刷新数据、当前控制器失去焦点的时候调用的时候调用
     */
    func resetPlayer() {
//        self.playingPlayer?.pause()
        self.playingPlayer?.removeFromSuperview()
        self.playingPlayer = nil
        self.playingCell = nil
        self.playingCellIndexPath = nil
    }
}

// MARK: - tablview的代理以及数据源
extension MediaController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.videoNewsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let newsModel = self.videoNewsArray![indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCell
        cell.newsModel = newsModel
        
        // 是否 是重用正在播放的那个cell
        if let playingCell = self.playingCell where playingCell == cell {
            // 是重用的正在播放的那个cell
            // 判断这个重用的cell是原本就应该播放视频的，还是其他行重用的
            if let playingCellIndexPath = self.playingCellIndexPath where playingCellIndexPath == indexPath {
                // 走到这里表示这个cell就是原本需要播放视频的那一行
                self.playingPlayer?.hidden = false
            }else {
                // 走到这里表示这个cell是重用的原本需要播放视频的那一行
                self.playingPlayer?.hidden = true
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("select")
    }
}

