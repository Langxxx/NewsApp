//
//  SpecialNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/18.
//  Copyright © 2015年 wl. All rights reserved.
//  专题新闻界面控制器

import UIKit

class SpecialNewsController: UIViewController, SpecialNewsHeardViewDelegate {
    
//========================================================
// MARK: - 一些属性
//========================================================
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    /// 顶部类似于导航栏的视图容器
    @IBOutlet weak var containerView: UIView!

    var newsModel: NewsModel?
    // 充当tableView的数据源
    let newsListProvider = NewsListProvider()
    var newsSpecialModel: NewsSpecialModel? {
        didSet {
            self.setupTableView()
            newsListProvider.newsSpecialModel = newsSpecialModel
        }
    }
//========================================================
// MARK: - 一些方法
//========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor(red: 212 / 255.0, green: 25 / 255.0, blue: 38 / 255.0, alpha: 1.0)
        
        self.tableView.dataSource =  self.newsListProvider
        self.newsListProvider.tableView = self.tableView
        // 加载本地缓存数据
        if let newsSpecialModel = LocalDataTool.getNewsDetailInfo(self.newsModel!.specialID!) as? NewsSpecialModel {
            self.newsSpecialModel = newsSpecialModel
        }
        DataTool.loadSpecialNewsData(self.newsModel!.specialID!) { (newsSpecialModel) -> Void in
            guard newsSpecialModel != nil else {
                return
            }
            self.newsSpecialModel = newsSpecialModel
            LocalDataTool.saveNewsDetailInfo(self.newsModel!.specialID!, anyModel: newsSpecialModel!)
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


     // MARK: - SpecialNewsHeardViewDelegate
    func specialNewsTopicBtnClik(index: Int) {

        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .Top, animated: true)
    }
    
}

// MARK: - tableView代理
extension SpecialNewsController: UITableViewDelegate, CellAttributeProtocol {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        return provideCellHeight(topics!.docs, indexPath: indexPath)
    }
    /**
    自定义HeaderSection，达到当前话题的索引颜色
    是红色
    */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let topics = self.newsSpecialModel?.topics[section] else {
            return nil
        }
        
        let str =  "   \(section+1)/\(self.newsSpecialModel!.topics.count) \(topics.tname)"
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        let vc = provideSelectedNewsVc(topics!.docs, indexPath: indexPath)
        
        self.navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
        
    }
}
