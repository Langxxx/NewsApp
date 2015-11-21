//
//  SpecialNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/18.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class SpecialNewsController: UIViewController, UITableViewDelegate, UITableViewDataSource, SpecialNewsHeardViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    var newsModel: NewsModel?
    var newsSpecialModel: NewsSpecialModel? {
        didSet {
            self.setupTableView()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor(red: 212 / 255.0, green: 25 / 255.0, blue: 38 / 255.0, alpha: 1.0)
        
        DataTool.loadSpecialNewsData(self.newsModel!.specialID!) { (newsSpecialModel) -> Void in
            guard newsSpecialModel != nil else {
                return
            }
            self.newsSpecialModel = newsSpecialModel
        }
    }

    func setupTableView() {
        
        guard let newsSpecialModel = self.newsSpecialModel else {
            return
        }
        
        self.titleLabel.text = newsSpecialModel.sname
        self.tableView.tableHeaderView = SpecialNewsHeardView(topics: newsSpecialModel.topics, topImageStr: self.newsSpecialModel!.banner,  delegate: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.newsSpecialModel?.topics.count ?? 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let topic = self.newsSpecialModel?.topics[section]
        return topic?.docs.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        return CellProvider.provideCellHeight(topics!.docs, indexPath: indexPath)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topics = self.newsSpecialModel?.topics[section]
        let str =  "   \(section+1)/\(self.newsSpecialModel!.topics.count) \(topics!.tname)"
        let attriStr = NSMutableAttributedString(string: str)
        let redStrAttr = [NSForegroundColorAttributeName : UIColor.redColor()]
        let redStr = "   \(section+1)" as NSString

        attriStr.addAttributes(redStrAttr, range: NSMakeRange(0, redStr.length))
        
        let label = UILabel()
        label.attributedText = attriStr
        label.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        label.font = UIFont.systemFontOfSize(13)
        return label
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        return CellProvider.provideCell(tableView, newsModelArray: topics!.docs, indexPath: indexPath)
    }
    
     // MARK: - tableView代理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        let vc = CellProvider.provideSelectedNewsVc(topics!.docs, indexPath: indexPath)

        self.navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
        
    }

     // MARK: - SpecialNewsHeardViewDelegate
    func specialNewsTopicBtnClik(index: Int) {

        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .Top, animated: true)
    }
    
}
