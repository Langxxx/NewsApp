//
//  DataTool.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DataTool {
    
    static let imageUrlKey = "imageUrlKey"
    
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
                print("getLuanchImageUrl error")
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
}


extension NSDate {
    class func TimeIntervalSince1970() -> NSTimeInterval{
        let nowTime = NSDate()
        return nowTime.timeIntervalSince1970
    }

}





