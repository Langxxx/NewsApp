//
//  ReplyCell.swift
//  网易新闻
//
//  Created by wl on 15/12/9.
//  Copyright © 2015年 wl. All rights reserved.
//  显示评论内容的cell，其子评论用tableview实现
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class ReplyCell: UITableViewCell {

    

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var supposeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subReplyTableView: UITableView!
    
 
    @IBOutlet weak var tableViewHeightConstrant: NSLayoutConstraint!
    
    var replyModelArray: [ReplyModel]! {
        didSet {
            let model = self.replyModelArray.last
            nameLabel.text = model?.name
            addressLabel.text = model?.userAddress.componentsSeparatedByString("&nbsp").first
            supposeLabel.text = model?.suppose
            messageLabel.text = model?.message
            self.replyModelArray.removeLast()
            self.subReplyModelArray = self.replyModelArray
        }
    }
    
    var subReplyModelArray: [ReplyModel]? {
        didSet {
            self.subReplyTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        subReplyTableView.delegate = self
        subReplyTableView.dataSource = self
        subReplyTableView.bounces = false
          subReplyTableView.separatorStyle = .None
        subReplyTableView.registerNib(UINib(nibName: "SubReplyCell", bundle: nil), forCellReuseIdentifier: "SubReplyCell")
    }
}

extension ReplyCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return tableView.fd_heightForCellWithIdentifier("SubReplyCell", configuration: { (obj) -> Void in
            let cell = obj as! SubReplyCell
            let model = self.subReplyModelArray![indexPath.row]
            cell.replyModel = model
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subReplyModelArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SubReplyCell") as! SubReplyCell
        let model = self.subReplyModelArray![indexPath.row]
        cell.replyModel = model
        return cell
    }
    

}
