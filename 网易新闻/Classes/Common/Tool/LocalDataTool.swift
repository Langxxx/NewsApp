//
//  LocalDataTool.swift
//  网易新闻
//
//  Created by wl on 15/11/26.
//  Copyright © 2015年 wl. All rights reserved.
//  本地缓存

/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/

import Foundation

struct LocalDataTool {
    static let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    static let fileURL = documents.URLByAppendingPathComponent("News.sqlite")
    static let database = FMDatabase(path: fileURL.path)
    
    /**
    将新闻列表数据保存到本地,是将模型数组转化
    成NSData进行保存
    - parameter channelID:      新闻频道的id，用于以后查找
    - parameter newsModelArray: 新闻的模型
    */
    static func saveNewsList(channelID: String, newsModelArray: [NewsModel]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            if !database.open() {
                print("Unable to open database")
                return
            }
            
            do {
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(newsModelArray)
                             
                try database.executeUpdate("create table if not exists t_NewsList(channelID text primary key, NewsListData blob not null)", values: nil)
                try database.executeUpdate("replace into t_NewsList (channelID, NewsListData) values (?, ?)", values: [channelID, data])
                
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
        
    }
    /**
    从本地取出新闻列表数据的模型数组
    
    - parameter channelID: 频道的id，用于查找对应的数据
    
    - returns: 查找到的数据,可以为nil
    */
    static func getNewsList(channelID: String) -> [NewsModel]? {
        
        if !database.open() {
            print("Unable to open database")
            return nil
        }
        
        var array: [NewsModel]?

        do {
            let result = try database.executeQuery("select * from t_NewsList where channelID = ?", values: [channelID])
            while result.next() {
                let data = result.dataForColumn("NewsListData")
                array = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [NewsModel]
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        return array
    }
    
    /**
     将新闻详情保存到本地
     
     - parameter key:      新闻对应的唯一标识
     - parameter anyModel: 新闻模型
     */
    static func saveNewsDetailInfo<T: NSObject> (key: String, anyModel: T) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            () -> Void in
            if !database.open() {
                print("Unable to open database")
                return
            }
            
            do {
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(anyModel)
                
                try database.executeUpdate("create table if not exists t_NewsDetail(key text primary key, NewsDetailData blob not null)", values: nil)
                try database.executeUpdate("replace into t_NewsDetail (key, NewsDetailData) values (?, ?)", values: [key, data])
                
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
    }
    
    /**
     从本地获取缓存的新闻详情
     
     - parameter key: 新闻对应的唯一标识
     
     - returns: 新闻模型
     */
    static func getNewsDetailInfo<T: NSObject> (key: String) -> T? {
        
        if !database.open() {
            print("Unable to open database")
            return nil
        }
        
        var anyModel: T?
        
        do {
            let result = try database.executeQuery("select * from t_NewsDetail where key = ?", values: [key])
            while result.next() {
                let data = result.dataForColumn("NewsDetailData")
                anyModel = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? T
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        return anyModel
    }
}



