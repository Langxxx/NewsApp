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

class NewsModel {
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
 /// 头部滚动视图
    var ads: [Ads]?
 /// 跟帖人数
    var replyCount: Int?
 /// 网址链接
    var url_3w: String?
    
    init(json: JSON) {
        tname = json["tname"].stringValue
        title = json["title"].stringValue
        ptime = json["ptime"].stringValue
        imgsrc = json["imgsrc"].stringValue
        digest = json["tname"].string
        imgextra = [String].arrayWithJson(json["imgextra"])
        replyCount = json["replyCount"].int
        url_3w = json["url_3w"].string
        ads = [Ads].arrayWithJson(json["ads"])
    }
}


