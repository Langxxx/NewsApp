//
//  ReplyCellProvider.swift
//  网易新闻
//
//  Created by wl on 16/3/6.
//  Copyright © 2016年 wl. All rights reserved.
//  用来充当MediaController数据源，为了将数据源代码进行分离

/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit



class ReplyCellProvider: NSObject {
    
    var hotReplyArray: [[ReplyModel]]?
    var newReplyArray: [[ReplyModel]]?
    
    weak var tableView: UITableView!
}

extension ReplyCellProvider: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.hotReplyArray == nil ? 0 : 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.hotReplyArray!.count : self.newReplyArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReplyCell") as! ReplyCell
        let model = indexPath.section == 0 ? self.hotReplyArray![indexPath.row] : self.newReplyArray![indexPath.row]
        cell.replyModelArray = model
        cell.tableViewHeightConstrant.constant = cell.subReplyTableView.contentSize.height
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let heardView = section == 0 ? ReplyHeardView.ReplyHeardViewWithTitle("热门评论") : ReplyHeardView.ReplyHeardViewWithTitle("最新评论")
        
        return heardView
    }
}