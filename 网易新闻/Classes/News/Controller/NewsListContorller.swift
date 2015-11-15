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
    
    var urlStr: String {
        var str = ""
        if self.channel == "热点" {
            str = "http://c.3g.163.com/recommend/getSubDocPic?size=20&spever=false&ts=\(NSDate.TimeIntervalSince1970())&encryption=1"
        }else {
            str = "http://c.m.163.com/nc/article/\(channelUrl)/0-20.html"
        }
        return str
    }
    
    var newsModelArray: [NewsModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.channel == "热点" {
            DataTool.loadNewsData(urlStr, newsKey: "推荐") { (newsArray) -> Void in
                self.newsModelArray = newsArray
            }
        }else {
            DataTool.loadNewsData(urlStr, newsKey: channelUrl.channelKey()) { (newsArray) -> Void in
                self.newsModelArray = newsArray
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear")
    }
    

    override func viewDidDisappear(animated: Bool) {
//        print("viewDidDisappear\(self.channel)")
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print("tableView")
        return self.newsModelArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        assert(self.newsModelArray != nil)
        let newsModel = self.newsModelArray![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(newsModel.cellType.rawValue, forIndexPath: indexPath) as! NewsCell
            cell.newsModel = newsModel
        
        return cell

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsModel = self.newsModelArray![indexPath.row]
        switch newsModel.cellType! {
        case .ScrollPictureCell, .TopBigPicture:
            return 222
        case .NormalNewsCell:
            return 90
        case .ThreePictureCell:
            return 108
        case .BigPictureCell:
            return 177
        }
    }
    
}

extension String {
    
    func channelKey() -> String{
        let index = self.rangeOfString("/")
        let key = self.substringFromIndex(index!.endIndex)
        return key
    }
}
