//
//  WeatherDetailController.swift
//  网易新闻
//
//  Created by wl on 15/11/25.
//  Copyright © 2015年 wl. All rights reserved.
//
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class WeatherDetailController: UIViewController {

    
    // MARK: - 属性
    
    var weatherModel: WeatherModel?
    var cityModel: CityModel? {
        didSet {
            
            todayContainerView.hidden = true
            bottomView.hidden = true
            DataTool.loadWeatherData(cityModel!.cityUrl) { (respond) -> Void in
                guard let weathermodel = respond else {
                    return
                }
                self.todayContainerView.hidden = false
                self.bottomView.hidden = false
                self.weatherModel = weathermodel
                self.setupWeatherInfo()
            }
        }
    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var todayContainerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: 今天天气显示控件
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var windPowerLabel: UILabel!
    
    // MARK: 明天天气显示控件
    @IBOutlet weak var oneDayAfterDateLabel: UILabel!
    @IBOutlet weak var oneDayAferTemperatureLabel: UILabel!
    @IBOutlet weak var oneDayAfterWeatherTypeLabel: UILabel!
    @IBOutlet weak var oneDayAfterWindLabel: UILabel!
    @IBOutlet weak var oneDayAfterWeatherImageView: UIImageView!
    // MARK: 后天天气显示控件
    @IBOutlet weak var twoDayAfterDateLabel: UILabel!
    @IBOutlet weak var twoDayAferTemperatureLabel: UILabel!
    @IBOutlet weak var twoDayAfterWeatherTypeLabel: UILabel!
    @IBOutlet weak var twoDayAfterWindLabel: UILabel!
    @IBOutlet weak var twoDayAfterWeatherImageView: UIImageView!
    // MARK: 大后天天气显示控件
    @IBOutlet weak var threeDayAfterDateLabel: UILabel!
    @IBOutlet weak var threeDayAferTemperatureLabel: UILabel!
    @IBOutlet weak var threeDayAfterWeatherTypeLabel: UILabel!
    @IBOutlet weak var threeDayAfterWindLabel: UILabel!
    @IBOutlet weak var threeDayAfterWeatherImageView: UIImageView!
    
     // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWeatherInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupWeatherInfo() {
        guard let weatherModel = self.weatherModel else {
            return
        }
        // TODO: 很恶心的代码，不知道有没有办法优化
        let todayModel = weatherModel.forecast[0]
        self.cityLabel.text = weatherModel.city
        self.dateLabel.text = NSDate.currentDateFormatter("MM月dd")
        self.weatherImageView.image = UIImage(named: todayModel.getWeatherTypeImage(true))
        self.temperatureLabel.text = "\(todayModel.low)/\(todayModel.high)".stringByReplacingOccurrencesOfString("℃", withString: "°")
        self.weatherTypeLabel.text = todayModel.type
        self.windPowerLabel.text = todayModel.fengli
        self.aqiLabel.text = "PM2.5 \(weatherModel.aqi) \(weatherModel.getAirQuality())"
        
        let oneDayAfterModel = weatherModel.forecast[1]
        self.oneDayAfterDateLabel.text = (oneDayAfterModel.date as NSString).substringFromIndex(3)
        self.oneDayAfterWeatherImageView.image = UIImage(named: oneDayAfterModel.getWeatherTypeImage(true))
        self.oneDayAferTemperatureLabel.text = "\(oneDayAfterModel.low)/\(oneDayAfterModel.high)".stringByReplacingOccurrencesOfString("℃", withString: "°")
        self.oneDayAfterWeatherTypeLabel.text = oneDayAfterModel.type
        self.oneDayAfterWindLabel.text = oneDayAfterModel.fengxiang
        
        let twoDayAfterModel = weatherModel.forecast[2]
        self.twoDayAfterDateLabel.text = (twoDayAfterModel.date as NSString).substringFromIndex(3)
        self.twoDayAfterWeatherImageView.image = UIImage(named: twoDayAfterModel.getWeatherTypeImage(true))
        self.twoDayAferTemperatureLabel.text = "\(twoDayAfterModel.low)/\(twoDayAfterModel.high)".stringByReplacingOccurrencesOfString("℃", withString: "°")
        self.twoDayAfterWeatherTypeLabel.text = twoDayAfterModel.type
        self.twoDayAfterWindLabel.text = twoDayAfterModel.fengxiang
        
        let threeDayAfterModel = weatherModel.forecast[3]
        self.threeDayAfterDateLabel.text = (threeDayAfterModel.date as NSString).substringFromIndex(3)
        self.threeDayAfterWeatherImageView.image = UIImage(named: threeDayAfterModel.getWeatherTypeImage(true))
        self.twoDayAferTemperatureLabel.text = "\(threeDayAfterModel.low)/\(threeDayAfterModel.high)".stringByReplacingOccurrencesOfString("℃", withString: "°")
        self.threeDayAfterWeatherTypeLabel.text = threeDayAfterModel.type
        self.threeDayAfterWindLabel.text = threeDayAfterModel.fengxiang
    }
    deinit {
//        print("weather===deinit")
    }
     // MARK: - 监听方法
    @IBAction func backBtnCik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func selectCityBtnClik() {
        let vc = CitySelectController()
        let nav = UINavigationController(rootViewController: vc)
        vc.title = "您所在的城市"
        vc.delegate = self
        self.navigationController?.presentViewController(nav, animated: true, completion: nil)
    }
    
}

// MARK: - CitySelectController的代理方法
extension WeatherDetailController: CitySelectControllerDelegate{
    
    func didSelectCity(citymodel: CityModel) {
        self.cityModel = citymodel
    }
}