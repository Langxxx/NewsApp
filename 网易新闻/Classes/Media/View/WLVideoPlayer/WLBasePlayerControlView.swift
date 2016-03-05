//
//  WLBasePlayerControlView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/25.
//  Copyright © 2016年 wl. All rights reserved.
//  WLBasePlayerControlView设置这一父类是无赖之举，
//  因为swift中暂时不支持(或者作者本人没找到)像oc中这样的写法:UIView<someProtocol> *obj
//  也就是说不支持定义一个变量，让他是UIView的子类，并且这个View必须遵守某个协议

import UIKit

@objc protocol WLPlayerControlViewDelegate: class {
    
    optional func didClikOnPlayerControlView(playerControlView: WLBasePlayerControlView)
    optional func playerControlView(playerControlView: WLBasePlayerControlView, pauseBtnDidClik pauseBtn: UIButton)
    optional func playerControlView(playerControlView: WLBasePlayerControlView, enterFullScreenBtnDidClik enterFullScreenBtn: UIButton)
    
    optional func beganSlideOnPlayerControlView(playerControlView: WLBasePlayerControlView)
    optional func playerControlView(playerControlView: WLBasePlayerControlView, endedSlide currentTime: NSTimeInterval)
}

class WLBasePlayerControlView: UIView {
    
    weak var delegate: WLPlayerControlViewDelegate?
    
    /// 让这个view变得透明但能够响应事件的透明度
    let HiddenAlpha: CGFloat = 0.02
    /// 视频总长度
    var totalDuration: NSTimeInterval = 0
    // 视频当前时间
    var currentTime: NSTimeInterval = 0 {
        didSet {
            if currentTime + 1 >= totalDuration {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(WLPlayerDidPlayToEndTimeNotification, object: nil)
                }
            }
        }
    }
    
    /**
     让这个view变得透明并且能够响应点击事件
     */
    func setVirtualHidden(isTrue: Bool) {
        if isTrue {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.alpha = self.HiddenAlpha
            })
        }else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.alpha = 1
            })
        }
    }
    /**
     让这个view变得透明并且能够响应点击事件,自动判断
     */
    func setVirtualHidden() {
        if (self.alpha - HiddenAlpha) < 0.001 { // 判断2个浮点数是否相等
            self.setVirtualHidden(false)
        }else {
            self.setVirtualHidden(true)
        }
    }
    
    
    /**
     自定义控制面板应该实现这个方法，
     实现此方法，将会自动更新面板上显示内容:时间、进度条等
     - parameter currentPlaybackTime: 当前时间
     - parameter duration:            视频总时长
     - parameter playableDuration:    已经缓冲的时长
     */
    func updateProgress(currentPlaybackTime: NSTimeInterval, duration: NSTimeInterval, playableDuration: NSTimeInterval) {
        fatalError("请子类实现相关方法")
    }
    /**
     每次播放器的播放模式发生变化的生活调用(进入\退出全屏\旋转等)
     发生旋转有可能对控制面板版原先的约束产生影响，在这里更新适合的约束
     */
    func relayoutSubView() {
        fatalError("请子类实现相关方法")
    }

    func getEnterFullscreenBtn() -> UIButton? {
        fatalError("请子类实现相关方法")
    }

}
extension WLBasePlayerControlView: UpdateProgressProtocol {
    
}

