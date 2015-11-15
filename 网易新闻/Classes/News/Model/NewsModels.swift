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
    
    init(json: JSON) {
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
    
    var imgType: Int?
    var hasHead: Int?
    
    init(json: JSON) {
        
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
        }else if self.imgType != nil {
            self.cellType = .BigPictureCell
        }else if self.imgextra != nil {
            self.cellType = .ThreePictureCell
        }else {
            self.cellType = .NormalNewsCell
        }
    }
}

