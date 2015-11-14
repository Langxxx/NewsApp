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
    var channelUrl: String! {
        didSet {
            urlStr = "http://c.m.163.com/nc/article/\(channelUrl)/0-20.html"
        }
    }
    var urlStr: String!
    var newsModelArray: [NewsModel]? {
        didSet {
            print(newsModelArray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataTool.loadNewsData(urlStr) { (newsArray) -> Void in
            self.newsModelArray = newsArray
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("tableView")
        return 20
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsNormalCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "\(self.channel)\(indexPath.row)"
        return cell
    }
    
}
