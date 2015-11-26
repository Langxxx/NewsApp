//
//  CitiModel.swift
//  网易新闻
//
//  Created by wl on 15/11/24.
//  Copyright © 2015年 wl. All rights reserved.
//  用于显示天气数据的各种模型

import Foundation
import SwiftyJSON

class WeatherDetailModel: NewsModelInitProtocol{
    /// 风向
    var fengxiang: String
    /// 风力
    var fengli: String
    /// 最高温度
    var high: String
    /// 天气
    var type: String
    /// 最低温度
    var low: String
    /// 日期
    var date: String
    required init(json: JSON) {
        
        let change: (String) -> String = {
            (temp: String) -> String in
             return (temp as NSString).substringFromIndex(2)
            }
        
        fengxiang = json["fengxiang"].stringValue
        fengli = json["fengli"].stringValue
        high = change(json["high"].stringValue)
        type = json["type"].stringValue
        low = change(json["low"].stringValue)
        date = json["date"].stringValue
    }
}

/**
    网络返回的天气模型,单例对象。目的
    是为了保证整个系统只有一个天气，方便数据更新
*/
class WeatherModel {
    /// 应该是实时温度
    var wendu: String
    /// 应该是一些建议
    var ganmao: String
    /// 今天以及后4天的天气数据
    var forecast: [WeatherDetailModel]
    /// 这个是前一天的数据，如果你看了返回的json格式就知道为啥被我省略(反正也用不上)
    //    var yesterday: WeatherDetailModel
    /// 空气质量指数
    var aqi: Int
    /// 当前城市
    var city: String
    
    var json: JSON! {
        didSet {
            wendu = json["wendu"].stringValue
            ganmao = json["ganmao"].stringValue
            aqi = json["aqi"].intValue
            city = json["city"].stringValue
            forecast = ModelArrayProvider.arrayModel(WeatherDetailModel.self, json: json["forecast"])!
        }
    }
    static let sharedInstance = WeatherModel()
    
    private init() {

        wendu = ""
        ganmao = ""
        aqi = 0
        city = ""
        forecast = []
    }
    
    static func sharedWeatherModel() -> WeatherModel {
        return sharedInstance
    }
}

extension WeatherModel {
    func getAirQuality() -> String {
        if self.aqi > 0 && self.aqi <= 50 {
            return "优"
        }else if self.aqi > 50 && self.aqi <= 100 {
            return "良"
        }else if self.aqi > 100 && self.aqi <= 150 {
            return "轻微污染"
        }else if self.aqi > 150 && self.aqi <= 200 {
            return "轻度污染"
        }else if self.aqi > 200 && self.aqi <= 250 {
            return "中度污染"
        }else if self.aqi > 250 && self.aqi <= 300 {
            return "中度重污染"
        }else if self.aqi > 250 {
            return "重污染"
        }else {
            return "无数据"
        }
    }
}

extension WeatherDetailModel {
    func getWeatherTypeImage(needColorImage: Bool) -> String {
        let type: NSString = self.type as NSString
        if type.containsString("雾") {
            return "biz_pc_plugin_weather_wu"
        }else if type.containsString("雷") {
            return needColorImage ? "color_leizhenyu" : "biz_pc_plugin_weather_leizhenyu"
        }else if type.containsString("雨") {
            return needColorImage ? "color_yu" : "biz_pc_plugin_weather_baoyu"
        }else if type.containsString("雪") {
            return needColorImage ? "color_xue" : "biz_pc_plugin_weather_daxue"
        }else if type.containsString("云") {
            return needColorImage ? "color_duoyun" : "biz_pc_plugin_weather_duoyun"
        }else {
            return needColorImage ? "color_qing" : "biz_pc_plugin_weather_qing"
        }
    }

}

/**
    城市模型
*/
class CityModel {
    var cityName: String = ""
    var cityUrl: String = ""
    init() {
        
    }
}
/**
    城市类别模型
*/
class CityTypeModel {
    /// 这个属性是指第一个汉字的拼音
    var type: String = ""
    var cities: [CityModel] = []
    init(){
    }
}

struct CityBox {
    
    var cityGroup: [CityTypeModel]
    
    init() {
        let path = NSBundle.mainBundle().pathForResource("city.plist", ofType: nil)!
        let cityInfo = NSDictionary(contentsOfFile: path)
        
        var tempGroup: [CityTypeModel] = []
        for (key, value) in cityInfo! {
            let cityType: CityTypeModel = CityTypeModel()
            cityType.type = key as! String
            for dict in value as! [[String : String]] {
                let cityModel = CityModel()
                cityModel.cityName = dict["city"]! as String
                cityModel.cityUrl = dict["cityID"]! as String
                cityType.cities.append(cityModel)
            }
            tempGroup.append(cityType)
        }
        cityGroup = tempGroup.sort({$0.type < $1.type})
    }
    
    subscript (index: Int) -> CityTypeModel {
        get {
            return cityGroup[index]
        }
    }
    
    subscript (indexPath: NSIndexPath) -> CityModel {
        get {
            return self.cityGroup[indexPath.section].cities[indexPath.row]
        }
    }
    
}