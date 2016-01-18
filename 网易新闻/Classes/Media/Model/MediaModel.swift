//
//  MediaModel.swift
//  网易新闻
//
//  Created by wl on 16/1/17.
//  Copyright © 2016年 wl. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 *  视听列表的表头模型(模型内容是固定的)
 */
class VideoSidModel {
    
    var sid: String
    /// 标题
    var title: String
    /// 图片地址
    var imgsrc: String
    
    init(json: JSON) {
        sid = json["sid"].stringValue
        title = json["title"].stringValue
        imgsrc = json["imgsrc"].stringValue
    }
    
}

class VideoNewsModel: NewsModelInitProtocol {
 /// 回帖数
    var replyCount: Int
 /// 图片
    var cover: String
 /// 播放次数
    var playCount: Int
 /// 题目
    var title: String
 /// 来源
    var videosource: String
 /// 暂时不知道干啥
    var replyBoard: String
 /// 简单描述信息
    var description: String
    
    var replyid: String
 /// 播放地址
    var mp4_url: String
 /// 发布时间
    var ptime: String
    ///  视频时长(秒)
    var length: Int
    
    required init(json: JSON) {
        replyCount = json["replyCount"].intValue
        cover = json["cover"].stringValue
        playCount = json["playCount"].intValue
        title = json["title"].stringValue
        videosource = json["videosource"].stringValue
        replyBoard = json["replyBoard"].stringValue
        description = json["description"].stringValue
        replyid = json["replyid"].stringValue
        mp4_url = json["mp4_url"].stringValue
        ptime = json["ptime"].stringValue
        length = json["length"].intValue
    }
}


