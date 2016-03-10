//
//  CellProvider.swift
//  网易新闻
//
//  Created by wl on 15/11/19.
//  Copyright © 2015年 wl. All rights reserved.
//  一些辅助TableView的工具类
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

/**
*  新闻列表协议，目的是为了将需要显示新闻列表的控制器的
*数据源与控制器分离，优化代码。
*/
protocol NewsListProtocol: UITableViewDataSource {
    var newsSpecialModel: NewsSpecialModel? {get set}
    var newsModelArray: [NewsModel]? {get set}
    weak var tableView: UITableView! {get set}
}

protocol CellAttributeProtocol {
    /**
     提供对应新闻类型cell的高度
     */
    func provideCellHeight(newsModelArray: [NewsModel], indexPath: NSIndexPath) -> CGFloat
    /**
     提供对应新闻类型cell
     */
    func provideCell(tableView: UITableView, newsModelArray: [NewsModel], indexPath: NSIndexPath) -> NewsCell
    
    // TODO: 为了方便当前的测试，先暂时这样设置，以后肯定要改
    /**
    提供对被点击cell对应的需要跳转的控制器
    */
    func provideSelectedNewsVc(newsModelArray: [NewsModel], indexPath: NSIndexPath) -> UIViewController
    func provideVcWithNewsModel(newsModel: NewsModel) -> UIViewController
}

/**
*  遵守了新闻列表协议的类，主要用来充当数据源的功能
*/
class NewsListProvider:NSObject, NewsListProtocol{
    
    var newsModelArray: [NewsModel]? {
        didSet {
            assert(newsModelArray != nil)
            assert(tableView != nil)
            self.tableView.reloadData()
        }
    }
    var newsSpecialModel: NewsSpecialModel? {
        didSet {
            assert(newsSpecialModel != nil)
            assert(tableView != nil)
            self.tableView.reloadData()
        }
    }
    
    weak var tableView: UITableView!
}
/**
*  NewsListProvider数据源的实现
*/
extension NewsListProvider: UITableViewDataSource, CellAttributeProtocol {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections: Int = 0
        if let newsSpecialModel = self.newsSpecialModel {
            sections = newsSpecialModel.topics.count
        }else {
            sections = 1
        }
        return sections
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        if let newsSpecialModel = self.newsSpecialModel {
            count = newsSpecialModel.topics[section].docs.count
        }else if let newsModelArray = self.newsModelArray {
            count = newsModelArray.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var newsModelArray: [NewsModel] = []
        if let newsSpecialModel = self.newsSpecialModel {
            newsModelArray = newsSpecialModel.topics[indexPath.section].docs
        }else if let array = self.newsModelArray {
            newsModelArray = array
        }
        
        return provideCell(tableView, newsModelArray: newsModelArray, indexPath: indexPath)
    }
    
}



/**
*  一些cell属性的提供工具
*/
extension CellAttributeProtocol {
    /**
    提供对应新闻类型cell的高度
    */
    func provideCellHeight(newsModelArray: [NewsModel], indexPath: NSIndexPath) -> CGFloat {
       
        let newsModel = newsModelArray[indexPath.row]
        return newsModel.cellType!.cellHeight()
    }
    /**
    提供对应新闻类型cell
    */
    func provideCell(tableView: UITableView, newsModelArray: [NewsModel], indexPath: NSIndexPath) -> NewsCell {
        let newsModel = newsModelArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(newsModel.cellType.rawValue, forIndexPath: indexPath) as! NewsCell
        cell.newsModel = newsModel

        return cell
    }
    
    // TODO: 为了方便当前的测试，先暂时这样设置，以后肯定要改
    /**
    提供对被点击cell对应的需要跳转的控制器
    */
    func provideSelectedNewsVc(newsModelArray: [NewsModel], indexPath: NSIndexPath) -> UIViewController {

        let newsModel = newsModelArray[indexPath.row]
        return provideVcWithNewsModel(newsModel)
       
    }
    func provideVcWithNewsModel(newsModel: NewsModel) -> UIViewController {
        if newsModel.specialID != nil {
            let sb = UIStoryboard(name: "NewsList", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("SpecialNewsController") as! SpecialNewsController
            vc.newsModel = newsModel
            return vc
        }else if newsModel.photosetID != nil {
            let sb = UIStoryboard(name: "NewsList", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("PictureNewsController") as! PictureNewsController
            vc.newsModel = newsModel
            return vc
        }else {
            let sb = UIStoryboard(name: "NewsList", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("DetaillNewsController") as! DetaillNewsController
            vc.newsModel = newsModel
            return vc
        }
    }

}



