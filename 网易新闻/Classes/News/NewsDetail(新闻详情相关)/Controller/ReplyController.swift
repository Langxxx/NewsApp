//
//  ReplyController.swift
//  网易新闻
//
//  Created by wl on 15/12/5.
//  Copyright © 2015年 wl. All rights reserved.
//  显示跟帖的控制器

import UIKit

// TODO: 子评论没有做
class ReplyController: UIViewController {
    var replyBoard: String!
    var requestID: String!
    
    var hotReplyArray: [[ReplyModel]]?
    var newReplyArray: [[ReplyModel]]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.hidden = true
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        let hotUrl = "http://comment.api.163.com/api/json/post/list/new/hot/\(replyBoard)/\(requestID)/0/10/10/2/2"
        let newUrl = "http://comment.api.163.com/api/json/post/list/new/normal/\(replyBoard)/\(requestID)/desc/0/10/10/2/2"

        DataTool.loadReplyData((hotUrl, newUrl)) { (hotResponse, newResponse) -> Void in
            guard let hotReplyArray = hotResponse, newReplyArray = newResponse else {
                return
            }
           
            self.hotReplyArray = hotReplyArray
            self.newReplyArray = newReplyArray
            self.tableView.hidden = false
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

}

extension ReplyController: UITableViewDelegate, UITableViewDataSource{
    
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
