//
//  NewsListContorller.swift
//  网易新闻
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class NewsListContorller: UITableViewController {

    var channel: String!
    var channelUrl: String!
    
    var newsModelArray: [NewsModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("requestInfo"))
        self.tableView.mj_header.beginRefreshing()
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("requestMoreInfo"))

    }
    
    /**
    下拉刷新，加载最新数据
    */
    func requestInfo() {
        if self.channel == "热点" {
            DataTool.loadNewsData(self.getUrlStrByType(RequestType.Recommend), newsKey: "推荐") { (newsArray) -> Void in
                self.tableView.mj_header.endRefreshing()
                self.newsModelArray = newsArray
            }
        }else {
            DataTool.loadNewsData(self.getUrlStrByType(RequestType.Default), newsKey: channelUrl.channelKey()) { (newsArray) -> Void in
                self.tableView.mj_header.endRefreshing()
                self.newsModelArray = newsArray
            }
        }
    }
    /**
    上拉刷新，加载更多数据
    */
    func requestMoreInfo() {
        if self.channel == "热点" {
            DataTool.loadNewsData(self.getUrlStrByType(RequestType.Recommend), newsKey: "推荐") { (newsArray) -> Void in
                self.tableView.mj_footer.endRefreshing()
                guard let newDataes = newsArray else {
                    return
                }
                self.newsModelArray! += newDataes
            }
        }else {
            DataTool.loadNewsData(self.getUrlStrByType(RequestType.MoreInfo), newsKey: channelUrl.channelKey()) { (var newsArray) -> Void in
                self.tableView.mj_footer.endRefreshing()
                newsArray?.removeFirst()
                guard let newDataes = newsArray else {
                    return
                }
                self.newsModelArray! += newDataes
            }
        }
    }
    
    func getUrlStrByType(type: RequestType) -> String{
        var str = ""
        
        switch type {
        case .Default:
            str = "http://c.m.163.com/nc/article/\(channelUrl)/0-20.html"
        case .Recommend:
            str = "http://c.3g.163.com/recommend/getSubDocPic?size=20&spever=false&ts=\(NSDate.TimeIntervalSince1970())&encryption=1"
        case .MoreInfo:
            str = "http://c.m.163.com/nc/article/\(channelUrl)/\(self.newsModelArray!.count - self.newsModelArray!.count%10)-20.html"
        }
        
        return str
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.newsModelArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return CellProvider.provideCell(tableView, newsModelArray: self.newsModelArray!, indexPath: indexPath)

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return CellProvider.provideCellHeight(self.newsModelArray!, indexPath: indexPath)
    }
    
    // MARK: - Table view 代理
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = CellProvider.provideSelectedNewsVc(self.newsModelArray!, indexPath: indexPath)
        guard vc != nil else {
            return
        }
        self.navigationController?.pushViewController(vc!, animated: true)
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    
    }
    
}

enum RequestType {
    case Default //上拉加载数据
    case Recommend // 热点数据
    case MoreInfo  // 下拉加载数据
}

extension String {
    
    func channelKey() -> String {
        let index = self.rangeOfString("/")
        let key = self.substringFromIndex(index!.endIndex)
        return key
    }
}
