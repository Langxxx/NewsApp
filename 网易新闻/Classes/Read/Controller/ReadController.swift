//
//  ReadController.swift
//  网易新闻
//
//  Created by wl on 15/12/27.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ReadController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    /// 用于本地存储的key
    let ChannelKey = "ReadChannel"
    var readNewsArray: [ReadNewsModel] = [] {
        didSet {
            self.tableView.reloadData()
            // 存入本地,只存最新的20个
            LocalDataTool.saveNewsList(ChannelKey, newsModelArray: Array(readNewsArray[0..<20]))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headView = ReadHeadView.readHeadView()
        self.tableView.tableHeaderView = headView

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionHeaderHeight = 5
        self.tableView.sectionFooterHeight = 5
        
        //集成上拉与下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("requestInfo"))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("requestMoreInfo"))
        
        //先从本地加载缓存的数据
        if let readNewsArray = LocalDataTool.getNewsList(ChannelKey) as? [ReadNewsModel] {
            self.readNewsArray = readNewsArray
        }
        self.tableView.mj_header.beginRefreshing()
    }
    
    /**
     下拉刷新回调方法
     */
    func requestInfo() {
        DataTool.loadReadNewsData { response -> Void in
            self.tableView.mj_header.endRefreshing()
            guard let modelArray = response else {
                return
            }
            self.readNewsArray = modelArray +  self.readNewsArray
        }
    }
    /**
     上拉刷新回调方法
     */
    func requestMoreInfo() {
        // 其实上拉加载数据的请求有点不同，这里偷懒就不区分了^_^
        DataTool.loadReadNewsData { response -> Void in
            self.tableView.mj_footer.endRefreshing()
            guard let modelArray = response else {
                return
            }
            self.readNewsArray += modelArray
        }
    }
    
}

extension ReadController: UITableViewDataSource, UITableViewDelegate, CellAttributeProtocol {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.readNewsArray.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let newsModel = self.readNewsArray[indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier(newsModel.cellType.rawValue, forIndexPath: indexPath) as! NewsCell
        cell.newsModel = newsModel
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let newsModel = self.readNewsArray[indexPath.section]
        let vc = provideVcWithNewsModel(newsModel)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    }

}

