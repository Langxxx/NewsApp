//
//  PlayerControlViewAuxiliary.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/3/3.
//  Copyright © 2016年 wl. All rights reserved.
//
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

protocol UpdateProgressProtocol {
    var timeText: String {get}
    func updateSliderViewWhenPlaying(currentPlaybackTime: NSTimeInterval, duration: NSTimeInterval, playableDuration: NSTimeInterval, updateConstant: ((finishPercent: CGFloat, playablePercent: CGFloat) -> Void)?)
    func updateSliderViewWhenSlide(inView: UIView, sender: UIPanGestureRecognizer, updateConstant: (point: CGPoint) -> Void)
}

extension UpdateProgressProtocol where Self : WLBasePlayerControlView {
    
    var timeText: String {
        return String(format: "%02d:%02d / %02d:%02d", Int(currentTime)/60, Int(currentTime)%60, Int(totalDuration)/60, Int(totalDuration)%60)
    }
    
    func updateSliderViewWhenPlaying(currentPlaybackTime: NSTimeInterval, duration: NSTimeInterval, playableDuration: NSTimeInterval, updateConstant: ((finishPercent: CGFloat, playablePercent: CGFloat) -> Void)?) {
        
        totalDuration = duration // 记录视频总长度
        currentTime = currentPlaybackTime
        
        let finishPercent = CGFloat(currentPlaybackTime / duration)
        let playablePercent = CGFloat(playableDuration / duration)
        updateConstant?(finishPercent: finishPercent, playablePercent: playablePercent)
    }
    
    func updateSliderViewWhenSlide(inView: UIView, sender: UIPanGestureRecognizer, updateConstant: (point: CGPoint) -> Void) {
        let point = sender.translationInView(inView)
        
        //相对位置清0
        sender.setTranslation(CGPointZero, inView: inView)
        updateConstant(point: point)
        if sender.state == .Began { //开始拖动
            delegate?.beganSlideOnPlayerControlView?(self)
        }else if sender.state == .Ended { //拖动结束
            delegate?.playerControlView?(self, endedSlide: currentTime)
        }
    }
    

}


