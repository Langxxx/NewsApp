//
//  WLPlayerHandler.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/25.
//  Copyright © 2016年 wl. All rights reserved.
//  处理用户自定义控制面板逻辑的对象
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit
import MediaPlayer

class WLPlayerHandler: NSObject {
    
    weak var player: MPMoviePlayerController!
    weak var customControlView: WLBasePlayerControlView!
    var customControlViewAutoHiddenInterval: NSTimeInterval = 3
    
    /// customControlViewAutoHiddenInterval秒调用一次，用来隐藏自定义控制面板
    private var autoHiddenTimer: NSTimer?
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("customControlViewStateDidChange"), name: WLPlayerCustomControlViewStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerDidExitFullscreen"), name: WLPlayerDidExitFullscreenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerDidEnterFullscreen"), name: WLPlayerDidEnterFullscreenNotification, object: nil)
    }
    deinit {
        //        print("WLPlayerHandler===deinit")
    }
    
    /**
     自定义控制面板显示的时候变会调用,
     用来添加一个定时器，为了在适合的时候隐藏控制面板
     */
    private func addAutoHiddenTimer() {
        removeAutoHiddenTimer()
        let timer = NSTimer(timeInterval: customControlViewAutoHiddenInterval, target: self, selector: Selector("hiddenCustomControlView"), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        autoHiddenTimer = timer
    }
    
    private func removeAutoHiddenTimer() {
        autoHiddenTimer?.invalidate()
        autoHiddenTimer = nil
    }
    
    /**
     更新自定义控制面板的进度条以及时间
     */
    func updateProgress(playerControlView: WLBasePlayerControlView) {
        playerControlView.updateProgress(player.currentPlaybackTime, duration: player.duration, playableDuration: player.playableDuration)
    }
    
    // MARK: - 回调方法
    
    /**
    定时器回调方法,自定义控制面板显示且customControlViewAutoHiddenInterval秒对其没有操作时候调用
    用来隐藏自定义视频控制面板
    */
    func hiddenCustomControlView() {
        customControlView.setVirtualHidden(true)
        removeAutoHiddenTimer()
    }
    /**
     当自定义控制面板上发生任何交互事件被调用，
     重置自动隐藏面板的定时器
     */
    func customControlViewStateDidChange() {
        removeAutoHiddenTimer()
        addAutoHiddenTimer()
    }
    
    
    func playerDidExitFullscreen() {
        customControlView.getEnterFullscreenBtn()?.selected = false
        addAutoHiddenTimer()
    }
    
    func playerDidEnterFullscreen() {
        customControlView.getEnterFullscreenBtn()?.selected = true
        addAutoHiddenTimer()
    }
}

// MARK: - WLPlayerControlViewDelegate代理
extension WLPlayerHandler: WLPlayerControlViewDelegate {
    /**
     WLBasePlayerControlView的代理方法，
     当点击视频控制View的空白处调用
     主要是用来显示\隐藏视频控制View
     */
    func didClikOnPlayerControlView(playerControlView: WLBasePlayerControlView) {
        playerControlView.setVirtualHidden()
        addAutoHiddenTimer()
    }
    /**
     WLBasePlayerControlView的代理方法，
     当点击暂停/播放的时候调用
     用来暂停/播放视频
     - parameter playerControlView: 用户自定义的那个控制面板
     - parameter pauseBtn:          暂停/播放按钮
     */
    func playerControlView(playerControlView: WLBasePlayerControlView, pauseBtnDidClik pauseBtn: UIButton) {
        assert(player != nil, "player is nil")
        if pauseBtn.selected { //暂停==>播放
            player.play()
        }else {
            player.pause()
        }
        pauseBtn.selected = !pauseBtn.selected
        addAutoHiddenTimer()
    }
    
    
    /**
     WLBasePlayerControlView的代理方法，
     当点击进入/退出全屏的时候调用
     用来进入/退出全屏
     - parameter playerControlView: 用户自定义的那个控制面板
     - parameter pauseBtn:          全屏/退出全屏按钮
     */
    func playerControlView(playerControlView: WLBasePlayerControlView, enterFullScreenBtnDidClik enterFullScreenBtn: UIButton) {
        
        assert(player != nil, "player is nil")
        
        if enterFullScreenBtn.selected { //全屏==>退出全屏
            NSNotificationCenter.defaultCenter().postNotificationName(WLPlayerWillExitFullscreenNotification, object: nil)
        }else {
            NSNotificationCenter.defaultCenter().postNotificationName(WLPlayerWillEnterFullscreenNotification, object: nil)
        }
        
        enterFullScreenBtn.selected = !enterFullScreenBtn.selected
        addAutoHiddenTimer()
    }
    /**
     WLBasePlayerControlView的代理方法，
     当playerControlView开始滑动的时候调用
     */
    func beganSlideOnPlayerControlView(playerControlView: WLBasePlayerControlView) {
        assert(player != nil, "player is nil")
        player.pause()
        removeAutoHiddenTimer()
    }
    /**
     WLBasePlayerControlView的代理方法，
     当playerControlView滑动结束的时候调用
     设置视频播放的时间
     - parameter playerControlView: 视频新的播放时间
     */
    func playerControlView(playerControlView: WLBasePlayerControlView, endedSlide currentTime: NSTimeInterval) {
        
        assert(player != nil, "player is nil")
        player.currentPlaybackTime = currentTime
        player.play()
    
        addAutoHiddenTimer()
    }
}
