//
//  NewsDetailModels.swift
//  网易新闻
//
//  Created by wl on 15/11/22.
//  Copyright © 2015年 wl. All rights reserved.
//  一些新闻详情的数据模型

import Foundation
import SwiftyJSON

//========================================================
// MARK: 新闻详情所用模型
//========================================================
/**
*  新闻详情页面中，某一张图片的模型
*/
class NewsDetailImgModel: NewsModelInitProtocol{
    /// 图片的位置
    var ref: String
    /// 图片大小
    var pixel: String
    /// 图片的描述信息
    var alt: String
    /// 图片位置
    var src: String
    
    required init(json: JSON) {
        ref = json["ref"].stringValue
        pixel = json["pixel"].stringValue
        alt = json["alt"].stringValue
        src = json["src"].stringValue
    }
}
/**
*  新闻详情模型
*/
class NewsDetailModel {
    /// 新闻标题
    var title: String
    /// 新闻发布时间
    var ptime: String
    /// 新闻内容
    var body: String
    /// 新闻详情的图片模型
    var img: [NewsDetailImgModel]
    init(json: JSON) {
        title = json["title"].stringValue
        ptime = json["ptime"].stringValue
        body = json["body"].stringValue
        img = ModelArrayProvider.arrayModel(NewsDetailImgModel.self, json: json["img"])!
    }
    
}
//========================================================
// MARK: 专题新闻所用模型
//========================================================
/**
*  专题内的子话题模型
*/
class Topic: NewsModelInitProtocol{
    /// 话题名
    var tname: String
    /// 索引
    var index: Int
    /// 话题内的新闻
    var docs: [NewsModel]
    
    required init(json: JSON) {
        tname = json["tname"].stringValue
        index = json["index"].intValue
        docs = ModelArrayProvider.arrayModel(NewsModel.self, json: json["docs"])!
    }
}
/**
*  专题新闻模型
*/
class NewsSpecialModel {
    /// 新闻专题名
    var sname: String
    /// 发布时间
    var ptime: String
    /// 图片
    var banner: String
    /// 子话题
    var topics: [Topic]
    
    init(json: JSON) {
        sname = json["sname"].stringValue
        ptime = json["ptime"].stringValue
        banner = json["banner"].stringValue
        topics = ModelArrayProvider.arrayModel(Topic.self, json: json["topics"])!
    }
}

//========================================================
// MARK: 专题新闻所用模型
//========================================================
/**
*  图片新闻的图片模型
*/
class Photo: NewsModelInitProtocol{
    /// 描述
    var note: String
    var imgurl: String
    
    required init(json: JSON) {
        note = json["note"].stringValue
        imgurl = json["imgurl"].stringValue
    }
}
/**
*  图片新闻的模型
*/
class NewsPictureModel {
    /// 图片新闻内容
    var photos: [Photo]
    /// 名称
    var setname: String
    /// 数量
    var imgsum: Int
    
    init(json: JSON) {
        setname = json["setname"].stringValue
        imgsum = json["imgsum"].intValue
        photos = ModelArrayProvider.arrayModel(Photo.self, json: json["photos"])!
    }
    
}
