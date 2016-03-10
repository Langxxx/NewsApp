//
//  NewsListContorller.swift
//  网易新闻
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 wl. All rights reserved.
//  新闻列表控制器，用来展示当前频道所有新闻
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class NewsListContorller: UITableViewController {
//========================================================
// MARK: - 一些属性
//========================================================
    /// 当前频道
    var channel: String!
    /// 当前频道的url
    var channelUrl: String!
    
    // 充当tableView的数据源
    let newsListProvider = NewsListProvider()
    var newsModelArray: [NewsModel]? {
        didSet {
            self.newsListProvider.newsModelArray = newsModelArray
            // 本地缓存
            LocalDataTool.saveNewsList(self.channelUrl, newsModelArray: self.newsModelArray!)
        }
    }
//========================================================
// MARK: - 一些方法
//========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.newsListProvider
        self.newsListProvider.tableView = self.tableView
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("requestInfo"))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("requestMoreInfo"))
        // 加载本地缓存数据
        if let newsModelArray = LocalDataTool.getNewsList(self.channelUrl) {
            self.newsModelArray = newsModelArray
        }
        self.tableView.mj_header.beginRefreshing()

    }
    
    /**
    下拉刷新，加载最新数据
    */
    func requestInfo() {
        if self.channel == "热点" {
            DataTool.loadNewsData(self.getUrlStrByType(RequestType.Recommend), newsKey: "推荐") { (newsArray) -> Void in
                self.tableView.mj_header.endRefreshing()
                guard let newDataes = newsArray else {
                    return
                }
                self.newsModelArray = newDataes
            }
        }else {
            DataTool.loadNewsData(self.getUrlStrByType(RequestType.Default), newsKey: channelUrl.channelKey()) { (newsArray) -> Void in
                self.tableView.mj_header.endRefreshing()
                guard let newDataes = newsArray else {
                    return
                }
                self.newsModelArray = newDataes
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

}

// MARK: - Table view 代理
extension NewsListContorller: CellAttributeProtocol {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return provideCellHeight(self.newsModelArray!, indexPath: indexPath)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = provideSelectedNewsVc(self.newsModelArray!, indexPath: indexPath)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
        
    }
}

    // MARK: - CyclePictureViewDelegate
extension NewsListContorller: CyclePictureViewDelegate {
    /**
    当头部滚动新闻点击的时候被调用
    */

    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        
        // 取出新闻模型
        let newsModel = self.newsModelArray![0]
        // 取出对应图片的模型
        if index == 0 {
            //do nothing
        }else if let ads = newsModel.ads?[index - 1] {
            newsModel.photosetID = ads.url
            newsModel.title = ads.title
            newsModel.docid = ads.docid
            newsModel.specialID = ads.specialID
        }
        
        let vc = provideVcWithNewsModel(newsModel)
        
        self.navigationController?.pushViewController(vc, animated: true)
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
