//
//  NewsModels.swift
//  网易新闻
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit
import SwiftyJSON

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

/*
 这个是新闻轮播器的数据模型
 */
class Ads {
    var title: String
    var tag: String
    var imgsrc: String
    var subtitle: String
    var url: String
    
    required init(json: JSON) {
        title = json["title"].stringValue
        tag = json["tag"].stringValue
        imgsrc = json["imgsrc"].stringValue
        subtitle = json["subtitle"].stringValue
        url = json["url"].stringValue
    }
}
/*
  这个是新闻数据模型，每一个模型对应一个cell。
这些属性只是暂时提取出来的一小部分，以后会有添加
 */
class NewsModel {
    
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
    
    var imgType: Int?
    var hasHead: Int?
    
    required init(json: JSON) {
        
        tname = json["tname"].stringValue
        title = json["title"].stringValue
        ptime = json["ptime"].stringValue
        imgsrc = json["imgsrc"].stringValue
        digest = json["digest"].string
        imgextra = [String].arrayWithJson(json["imgextra"])
        replyCount = json["replyCount"].int
        url_3w = json["url_3w"].string
        ads = [Ads].arrayWithJson(json["ads"])
        specialID = json["specialID"].string
        tags = json["TAGS"].string
        imgType = json["imgType"].int
        hasHead = json["hasHead"].int
        docid = json["docid"].string
        
        self.judgeCellType()
    }

}

enum CellType: String{
    case ScrollPictureCell =  "ScrollPictureCell"
    case NormalNewsCell = "NormalNewsCell"
    case ThreePictureCell = "ThreePictureCell"
    case BigPictureCell = "BigPictureCell"
    case TopBigPicture = "TopBigPicture"
}

extension NewsModel {
    
    func judgeCellType() {
        if self.ads != nil {
            self.cellType = .ScrollPictureCell
        }else if self.hasHead != nil {
            self.cellType = .TopBigPicture
        }else if let imgType = self.imgType where imgType > 0 {
            self.cellType = .BigPictureCell
        }else if self.imgextra != nil {
            self.cellType = .ThreePictureCell
        }else {
            self.cellType = .NormalNewsCell
        }
    }
}


class NewsDetailImgModel {
    /// 图片的位置
    var ref: String
    /// 图片大小
    var pixel: String
    /// 图片的描述信息
    var alt: String
    /// 图片位置
    var src: String
    
    init(json: JSON) {
        ref = json["ref"].stringValue
        pixel = json["pixel"].stringValue
        alt = json["alt"].stringValue
        src = json["src"].stringValue
    }
}
/*
    新闻详情模型
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
        img = [NewsDetailImgModel].arrayWithJson(json["img"])
    }
    
}

/*
    专题内的子话题模型
*/
class Topic {
    /// 话题名
    var tname: String
    /// 索引
    var index: Int
    /// 话题内的新闻
    var docs: [NewsModel]
    
    init(json: JSON) {
        tname = json["tname"].stringValue
        index = json["index"].intValue
        docs = [NewsModel].arrayWithJson(json["docs"])
    }
}
/*
    专题新闻模型
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
        topics = [Topic].arrayWithJson(json["topics"])
    }
}
