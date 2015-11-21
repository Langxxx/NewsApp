//
//  DataTool.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//  获得数据的工具

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
                print("getLuanchImageUrl error\(response.request?.URLString)")
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
    加载新闻数据
    
    - parameter urlStr:            请求地址
    - parameter completionHandler: 回调闭包
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

}


/*
    这个扩展是无奈之举，目的是为了将JSON数据中的数组转化成
swift中的数组，这是仿照oc中的实现，如果你有更好或者合理的方式
请一定要联系我。
*/
extension Array {
    
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
    // 这个是探索中的第一个版本，留给需要的人参考
//    static func arrayModel<T: NewsModelInitProtocol>(model: T, json: JSON) -> [T]? {
//        guard json != nil else {
//            return nil
//        }
//        var array = [T]()
//        for (_, dict) in json {
//            array.append(model.dynamicType.init(json: dict))
//        }
//        return array
//    }

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

extension NSDate {
    class func TimeIntervalSince1970() -> NSTimeInterval{
        let nowTime = NSDate()
        return nowTime.timeIntervalSince1970

    }

}





