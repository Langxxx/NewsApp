//
//  DataTool.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//  获得网络数据的工具

import Foundation
import Alamofire
import SwiftyJSON

struct DataTool {
    
    static let imageUrlKey = "imageUrlKey"
    
    /**
    网络请求启动图片的url，并保存在本地
    */
    static func requestLuanchImageUrl() {

        let urlStr = "http://g1.163.com/madr"
        let parameter: [String : AnyObject] = [
            "app" : "7A16FBB6",
            "platform" : "ios",
            "category" : "startup",
            "location" : 1,
            "timestamp":NSDate.TimeIntervalSince1970()
        ]
        Alamofire.request(.GET, urlStr, parameters: parameter).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("getLuanchImageUrl error:\(response.result.error)")
                return
            }
            let data = JSON(response.result.value!)
            let ads = data["ads"]
            
            var imageArray: [String] = []
            for (_, ad) in ads {
                for (_, imageUrlJSOn) in ad["res_url"] {
                    if let imageUrl = imageUrlJSOn.string where imageUrl != "" {
                        imageArray.append(imageUrl)
                        break
                    }
                }
            }
            // 将url存到本地
            NSUserDefaults.standardUserDefaults().setObject(imageArray, forKey: imageUrlKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    /**
    从本地获得启动图片的url(可能不存在)，
    更新下一次需要的启动图片
    */
    static func getLuanchImageUrl() -> String? {
        
        //从本地取出
        let obj = NSUserDefaults.standardUserDefaults().objectForKey(imageUrlKey) as? [String]
        // 存储下一次启动所需要的图片
        self.requestLuanchImageUrl()
        
        guard let imageArray = obj  where imageArray.count != 0 else {
            return nil
        }
        // 因为图片可以能有多张，随机取一张
        let i = arc4random_uniform(UInt32(imageArray.count))
        
        return imageArray[Int(i)]
    }
    
    /**
    加载新闻数据，主要是新闻列表数据
    
    - parameter urlStr:            请求地址
    - parameter newsKey:           获得数据的key
    - parameter completionHandler: 返回数据的回调闭包
    */
    static func loadNewsData(urlStr: String, newsKey: String, completionHandler: [NewsModel]? -> Void) {

        
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("load news error!")
                completionHandler(nil)
                return
            }
            
            let data = JSON(response.result.value!)
            let news = data[newsKey]
            var array: [NewsModel] = []
            for (_, dict) in news {
                
                array.append(NewsModel(json: dict))
            }
            
            completionHandler(array)
        }
    }
    
    /**
    获得某一个新闻数据的详情内容
    
    - parameter docid:             代表这条新闻的id
    - parameter completionHandler: 返回数据的回调闭包
    */
    static func loadNewsDetailData(docid: String, completionHandler: NewsDetailModel? -> Void) {
        let urlStr = "http://c.m.163.com/nc/article/\(docid)/full.html"
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("loadNewsDetailData error!")
                completionHandler(nil)
                return
            }
            let data = JSON(response.result.value!)
            let news = data[docid]
            
            let newsDetailModel = NewsDetailModel(json: news)
            completionHandler(newsDetailModel)
        }
    }
    
    /**
    获得一个专题新闻的数据列表
    
    - parameter specialID:         专题新闻的唯一id
    - parameter completionHandler: 返回数据的回调闭包
    */
    static func loadSpecialNewsData(specialID: String, completionHandler: NewsSpecialModel? -> Void) {
        let urlStr = "http://c.3g.163.com/nc/special/\(specialID).html"
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("loadSpecialNewsData error!")
                completionHandler(nil)
                return
            }
            let data = JSON(response.result.value!)
            let news = data[specialID]
            
            let newsSpecialModel = NewsSpecialModel(json: news)
            completionHandler(newsSpecialModel)
        }
    }
    /**
    获得图片新闻数据
    
    - parameter photosetID:        专题新闻的唯一id
    - parameter completionHandler: 返回数据的回调闭包
    */
    static func loadPictureNewsData(photosetID: String, completionHandler: NewsPictureModel? -> Void) {
        
        let subStr = (photosetID as NSString).substringFromIndex(4)
        let strArray = subStr.componentsSeparatedByString("|")
        
        let urlStr = "http://c.m.163.com/photo/api/set/\(strArray.first!)/\(strArray.last!).json"
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("loadPictureNewsData error!")
                completionHandler(nil)
                return
            }
            let data = JSON(response.result.value!)
            
            let newsPictureModel = NewsPictureModel(json: data)
            completionHandler(newsPictureModel)
        }
    }
    /**
    加载天气数据，数据来源是“中华万年历”
    
    - parameter cityID:            城市id
    - parameter completionHandler: 返回数据的回调闭包
    */
    static func loadWeatherData(cityID: String, completionHandler: WeatherModel? -> Void) {
        let urlStr = "http://wthrcdn.etouch.cn/weather_mini"
        let parameter: [String : AnyObject] = ["citykey" : cityID]
        
        Alamofire.request(.GET, urlStr, parameters: parameter).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("loadWeatherData error:\(response.request?.URLString)")
                completionHandler(nil)
                return
            }
            
            let data = JSON(response.result.value!)
            // 获得单例对象
            let weatherModel = WeatherModel.sharedWeatherModel()
            weatherModel.json = data["data"]
            completionHandler(weatherModel)
        }
    }
    /**
     加载评论数据
     
     - parameter urlStr:            url的元组
     - parameter newUrl:            最新跟帖
     - parameter completionHandler: 返回数据的回调闭包
     */
    static func loadReplyData(urlStr: (hotUrl: String,newUrl: String), completionHandler: ([[ReplyModel]]?, [[ReplyModel]]?) -> Void) {
        // 内嵌函数，用于解析json,并按照评论楼层排序
        func analyzeData(response: Response<AnyObject, NSError>, key: String) -> [[ReplyModel]]{
            let data = JSON(response.result.value!)
            let posts = data[key]
            var array: [[ReplyModel]] = []
            for (_, dict) in posts {
                
                if dict["NON"].string != nil {
                    break;
                }
                var temp: [ReplyModel] = []
                for (key, value) in dict {
//                    print(value)
//                    print(value["NON"])
                    temp.append(ReplyModel(key: key, json: value))
                }
                // 按照评论的楼层排序
                array.append(temp.sort({$0.floor < $1.floor}))

            }

            return array
        }
        
        Alamofire.request(.GET, urlStr.hotUrl).responseJSON { (hotResponse) -> Void in
            guard hotResponse.result.error == nil else {
                print("loadReplyData error:\(hotResponse.request?.URLString)")
                completionHandler(nil, nil)
                return
            }
            print(hotResponse.request?.URLString)
            Alamofire.request(.GET, urlStr.newUrl).responseJSON { (newResponse) -> Void in
                guard newResponse.result.error == nil else {
                    print("loadReplyData error:\(newResponse.request?.URLString)")
                    completionHandler(nil, nil)
                    return
                }

                //解析最热跟帖
                completionHandler(analyzeData(hotResponse, key: "hotPosts"), analyzeData(newResponse, key: "newPosts"))
            }
            
        }
        
    }
    
    /**
     加载阅读模块数据
     
     - parameter completionHandler: 返回数据的回调闭包
     */
    static func loadReadNewsData(completionHandler: [ReadNewsModel]? -> Void) {
        
        let urlStr = "http://c.3g.163.com/recommend/getSubDocPic"
        let parameter: [String : AnyObject] = [
            "from" : "yuedu",
            "size" : 20,
            "timestamp":NSDate.TimeIntervalSince1970()
        ]
        
        Alamofire.request(.GET, urlStr, parameters: parameter).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("load news error!")
                completionHandler(nil)
                return
            }
            let data = JSON(response.result.value!)
            let news = data["推荐"]
            var array: [ReadNewsModel] = []
            for (_, dict) in news {
                
                array.append(ReadNewsModel(json: dict))
            }
            
            completionHandler(array)
        }
    }
    
    /**
     加载视听模块数据
     
     - parameter completionHandler: 返回数据的回调闭包
     */
    static func loadMediaNewsData(urlStr:String, completionHandler: ([VideoSidModel]?, [VideoNewsModel]?) -> Void) {

        
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("load news error!")
                completionHandler(nil, nil)
                return
            }
            let data = JSON(response.result.value!)
            
            let videoSidJSON = data["videoSidList"]
            var videoSidArray: [VideoSidModel] = []
            for (_, dict) in videoSidJSON {
                
                videoSidArray.append(VideoSidModel(json: dict))
            }
            
            let videoNewsJSON = data["videoList"]
            var videoNewsArray: [VideoNewsModel] = []
            for (_, dict) in videoNewsJSON {
                
                videoNewsArray.append(VideoNewsModel(json: dict))
            }
            
            completionHandler(videoSidArray, videoNewsArray)
        }
    }
    
    static func loadVideoNewsData(urlStr:String, completionHandler: [VideoNewsModel]? -> Void) {
        
        
        Alamofire.request(.GET, urlStr).responseJSON { (response) -> Void in
            guard response.result.error == nil else {
                print("load news error!")
                completionHandler(nil)
                return
            }
            let data = JSON(response.result.value!)
            
            let videoNewsJSON = data["recommend"]
            var videoNewsArray: [VideoNewsModel] = []
            for (_, dict) in videoNewsJSON {
                
                videoNewsArray.append(VideoNewsModel(json: dict))
            }
            
            completionHandler(videoNewsArray)
        }
    }


}

extension NSDate {
    class func TimeIntervalSince1970() -> NSTimeInterval{
        let nowTime = NSDate()
        return nowTime.timeIntervalSince1970
    }
}





