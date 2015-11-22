//
//  NewsModels.swift
//  网易新闻
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 wl. All rights reserved.
//  数据模型

import UIKit
import SwiftyJSON

//========================================================
// MARK: - 频道所用模型
//========================================================
struct ChannelModel {
    var channelName: String
    var channelUrl: String
}
struct ChannelBox {
    
    var channels: [ChannelModel]
    
    init() {
        let path = NSBundle.mainBundle().pathForResource("channels.plist", ofType: nil)!
        let array = NSArray(contentsOfFile: path)
    
        channels = []
        for dict in array! {
            let channelName = dict["tname"] as! String
            let channelUrl = dict["url"] as! String
            let channelModel = ChannelModel(channelName: channelName, channelUrl: channelUrl)
            channels.append(channelModel)
        }
    }
    
    subscript (index: Int) -> ChannelModel {
        get {
            return channels[index]
        }
    }
}
//========================================================
// MARK: - 新闻所用模型
//========================================================
/**
*  新闻的基础协议
*/
protocol NewsModelInitProtocol {
    init(json: JSON)
}
/**
*  为遵守NewsModelInitProtocol的模型类便捷创建
* 对应的模型的数组
*/
struct ModelArrayProvider {
    static func arrayModel<T: NewsModelInitProtocol>(anyClass: AnyClass,json: JSON) -> [T]? {
        guard json != nil else {
            return nil
        }
        if anyClass is T.Type {
            let model = anyClass as! T.Type
            var array = [T]()
            for (_, dict) in json {
                array.append(model.init(json: dict))
            }
            return array
        }else {
            return nil
        }
    }
    
    static func arrayWithJson(json: JSON) -> [String]?{
        
        guard json != nil else {
            return nil
        }
        
        var array: [String] = []
        
        for (_, dict) in json {
            array.append(dict["imgextra"].stringValue)
        }
        return array
    }
}

//========================================================
// MARK: 新闻列表所用模型
//========================================================
/**
*  这个是新闻轮播器的数据模型
*/
class Ads: NewsModelInitProtocol {
    var title: String
    var tag: String
    var imgsrc: String
    var subtitle: String
    var url: String
    /// 新闻id，用来链接新闻详情
    var docid: String?
    /// 专题新闻
    var specialID: String?
    
    required init(json: JSON) {
        title = json["title"].stringValue
        tag = json["tag"].stringValue
        imgsrc = json["imgsrc"].stringValue
        subtitle = json["subtitle"].stringValue
        url = json["url"].stringValue
        docid = json["docid"].string
        specialID = json["specialID"].string
    }
}
/**
*  这个是新闻数据模型，每一个模型对应一个cell。
*/
class NewsModel: NewsModelInitProtocol{
    // 这个模型对应cell的种类，自定义的数据，不是接受自网络
    var cellType: CellType!
    
 /// 新闻所属于频道(类别)
    var tname: String
 /// 新闻标题
    var title: String
 /// 新闻发布的时间
    var ptime: String
 /// 图片地址
    var imgsrc: String
 /// 新闻的简介
    var digest: String?
 /// 多组图片
    var imgextra: [String]?
 /// 头部滚动视图的模型
    var ads: [Ads]?
 /// 跟帖人数
    var replyCount: Int?
 /// 网址链接
    var url_3w: String?
 /// 专题新闻
    var specialID: String?
 /// 一些新闻的类别
    var tags: String?
    /// 新闻id，用来链接新闻详情
    var docid: String?
    /// 图片新闻id
    var photosetID: String?
    
    var imgType: Int?
    var hasHead: Int?
    
    required init(json: JSON) {
        
        tname = json["tname"].stringValue
        title = json["title"].stringValue
        ptime = json["ptime"].stringValue
        imgsrc = json["imgsrc"].stringValue
        digest = json["digest"].string
        imgextra = ModelArrayProvider.arrayWithJson(json["imgextra"])
        replyCount = json["replyCount"].int
        url_3w = json["url_3w"].string
        ads = ModelArrayProvider.arrayModel(Ads.self, json: json["ads"])
        specialID = json["specialID"].string
        tags = json["TAGS"].string
        imgType = json["imgType"].int
        hasHead = json["hasHead"].int
        docid = json["docid"].string
        photosetID = json["photosetID"].string
        
        self.judgeCellType()
    }

}
extension NewsModel {
    func judgeCellType() {
        if self.ads != nil {
            self.cellType = .ScrollPictureCell
        }else if self.hasHead != nil {
            self.cellType = .TopBigPictureCell
        }else if let imgType = self.imgType where imgType > 0 {
            self.cellType = .BigPictureCell
        }else if self.imgextra != nil {
            self.cellType = .ThreePictureCell
        }else {
            self.cellType = .NormalNewsCell
        }
    }
}
/**
每一种类型的新闻对应的应该展示的cell的种类

- ScrollPictureCell: 滚动新闻
- NormalNewsCell:    一般新闻(普通新闻、专题新闻、直播等等，这种cell主要特征是只有一张图片)
- ThreePictureCell:  多图新闻(这种新闻cell有三张图片)
- BigPictureCell:    大图新闻(这种cell主要特征是有一大张图片)
- TopBigPictureCell: 顶部的大图(这种cell主要特征是有一大张图片)
*/
enum CellType: String{
    
    case ScrollPictureCell, NormalNewsCell, ThreePictureCell, BigPictureCell, TopBigPictureCell

    func cellHeight() -> CGFloat {
        switch self {
        case .ScrollPictureCell, .TopBigPictureCell:
            return 222
        case .NormalNewsCell:
            return 90
        case .ThreePictureCell:
            return 108
        case .BigPictureCell:
            return 177
        }
    }
}
