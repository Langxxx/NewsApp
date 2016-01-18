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
        }
    }
    
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

}

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
        
        return cell
    }
}
