//
//  WeatherView.swift
//  网易新闻
//
//  Created by wl on 15/11/23.
//  Copyright © 2015年 wl. All rights reserved.
//  显示天气的view

import UIKit

protocol WeatherViewDelegate: class {
    func selectBtnClik()
    func detailBtnClik(weatherModel: WeatherModel)
}

class WeatherView: UIView {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var outlineBtn: UIButton!
    @IBOutlet weak var nightBtn: UIButton!
    @IBOutlet weak var sweepBtn: UIButton!
    @IBOutlet weak var invitationBtn: UIButton!
    
    @IBOutlet weak var weatherInfoView: UIView!
    @IBOutlet weak var selecBtn: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var lowHightLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    var btnArray: [UIButton] = []
    
    weak var delegate: WeatherViewDelegate?
    
    var cityModel: CityModel? {
        didSet {
            selecBtn.hidden = true
            weatherInfoView.hidden = false
            DataTool.loadWeatherData(cityModel!.cityUrl) { (respond) -> Void in
                guard let weathermodel = respond else {
                    return
                }
                
                self.weatherModel = weathermodel
            }
        }
    }
    
    var weatherModel: WeatherModel? {
        didSet {
            self.setupWeatherInfo()
        }
    }
    
    override func awakeFromNib() {
        self.btnArray.append(searchBtn)
        self.btnArray.append(topBtn)
        self.btnArray.append(outlineBtn)
        self.btnArray.append(nightBtn)
        self.btnArray.append(sweepBtn)
        self.btnArray.append(invitationBtn)
    }
    
    override func layoutSubviews() {
        
        if UIScreen.mainScreen().bounds.height == 480 {
            bottomViewHeightConstraint.constant = 200
        }
        
        for btn in self.btnArray {
            btn.layer.cornerRadius = btn.frame.width/2;
            btn.layer.masksToBounds = true;
        }
    }
    
    /**
    执行出现的动画效果
    */
    func show(){
        self.hidden = false
        let anima = CABasicAnimation(keyPath: "transform")
        anima.duration = 0.2;
        anima.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(0.2, 0.2, 1))
        anima.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.2, 1.2, 1))

        for btn in self.btnArray {
            btn.layer.addAnimation(anima, forKey: nil)
        }

        self.setupWeatherInfo()
    }
    /**
    设置天气信息
    */
    func setupWeatherInfo() {
        if let weatherModel = self.weatherModel {
            let todayModel = weatherModel.forecast.first!
            self.temperatureLabel.text = weatherModel.wendu
            self.lowHightLabel.text = "\(todayModel.low)/\(todayModel.high)"
            self.aqiLabel.text = "PM2.5 \(weatherModel.aqi) \(weatherModel.getAirQuality())"
            self.dataLabel.text = NSDate.currentDateFormatter("yyyy-MM-dd")
            self.weatherImageView.image = UIImage(named: todayModel.getWeatherTypeImage(false))
            self.weatherTypeLabel.text = todayModel.type
            self.windLabel.text = "\(todayModel.fengxiang) \(todayModel.fengli)"
            self.cityLabel.text = weatherModel.city
        }
    }
    /**
    快速创建WeatherView的类方法
    */
    static func weatherView() -> WeatherView {
        let weatherView = NSBundle.mainBundle().loadNibNamed("WeatherView", owner: nil, options: nil).first as! WeatherView
        return weatherView
    }
    
    @IBAction func selectBtnClik() {
        self.delegate?.selectBtnClik()
    }
    
    @IBAction func detailBtnClik() {
        guard let  weatherModel = self.weatherModel else {
            return
        }
        self.delegate?.detailBtnClik(weatherModel)
    }
    

    
}

extension NSDate {
    class func currentDateFormatter(format: String) -> String {
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = format
        let current = NSDate()
        let week = current.dayOfWeek()
        let date = dateFmt.stringFromDate(current)
        return "\(date) \(week)"
    }
    
    func dayOfWeek() -> String {
        let interval = self.timeIntervalSince1970
        let days = Int(interval / 86400)
        let intValue = (days - 3) % 7
        switch intValue {
        case 0:
            return "星期日"
        case 1:
            return "星期一"
        case 2:
            return "星期二"
        case 3:
            return "星期三"
        case 4:
            return "星期四"
        case 5:
            return "星期五"
        case 6:
            return "星期六"
        default:
            break
        }
        return "未取到数据"
        
    }

}
