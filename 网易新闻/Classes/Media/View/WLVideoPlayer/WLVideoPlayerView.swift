//
//  WLVideoPlayerView.swift
//  WLVideoPlayer(MP)
//
//  Created by wl on 16/2/24.
//  Copyright © 2016年 wl. All rights reserved.
//

/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit
import MediaPlayer

let WLPlayerCustomControlViewStateDidChangeNotification = "WLPlayerCustomControlViewStateDidChangeNotiffication"
let WLPlayerWillEnterFullscreenNotification = "WLPlayerWillEnterFullscreenNotification"
let WLPlayerWillExitFullscreenNotification = "WLPlayerWillExitFullscreenNotification"
let WLPlayerDidEnterFullscreenNotification = "WLPlayerDidEnterFullscreenNotification"
let WLPlayerDidExitFullscreenNotification = "WLPlayerDidExitFullscreenNotification"
let WLPlayerDidPlayToEndTimeNotification = "WLPlayerDidPlayToEndTimeNotification"

enum WLVideoPlayerViewFullscreenModel {
    /// 当设备旋转、全屏按钮点击就进入全屏且横屏的状态
    case AwaysLandscape
    /// 全屏按钮点击进入全屏状态，在全屏状态下旋转才进入横屏
    case LandscapeWhenInFullscreen
}

class WLVideoPlayerView: UIView {
    
    // MARK: - 属性

    //========================================================
    // MARK: 接口属性
    //========================================================
    
    var player: MPMoviePlayerController
    /// 播放地址
    var contentURL: NSURL? {
        didSet {
            player.contentURL = contentURL
        }
    }
    /// 视频等待的占位图片
    var placeholderView: UIView?
    
    // ps: 因为swift中暂时不支持(或者作者本人没找到)像oc中这样的写法:UIView<someProtocol> *obj
    // 也就是说不支持定义一个变量，让他是UIView的子类，并且这个View必须遵守某个协议,妥协之下，便设置了一个类似于接口的一个父类
    /// 用户自定义控制界面
    var customControlView: WLBasePlayerControlView? {
        didSet {
            player.controlStyle = .None
        }
    }
    /// 用户自定义视频控制面板自动隐藏的时间
    var customControlViewAutoHiddenInterval: NSTimeInterval = 3 {
        didSet {
            playerControlHandler.customControlViewAutoHiddenInterval = customControlViewAutoHiddenInterval
        }
    }
    /// 进入全屏的模式
    var fullscreenModel: WLVideoPlayerViewFullscreenModel = .AwaysLandscape
    
    //========================================================
    // MARK: 私有属性
    //========================================================
    
    /// 自定义控制界面事件处理者
    lazy var playerControlHandler: WLPlayerHandler = WLPlayerHandler()
    
    private let defaultFrame = CGRectMake(0,0,0,0)
    /// 1秒调用一次，用来更新用户自定义视频控制面板上进度条以及时间的显示
    private var progressTimer: NSTimer?
    
    private var isFullscreen: Bool = false {
        didSet {
            // 为了隐藏状态栏必须在info.plist中View controller-based status bar appearance 设置为NO
            UIApplication.sharedApplication().setStatusBarHidden(isFullscreen, withAnimation: .Slide)
        }
    }
    
    /// WLVideoPlayerView这个对象的父视图
    private weak var inView: UIView!
  

    // MARK: - 方法
    
    //========================================================
    // MARK: 初始化方法
    //========================================================
    init(url : NSURL?) {
        contentURL = url
        player = MPMoviePlayerController(contentURL: contentURL)
        
        super.init(frame: defaultFrame)
        
        self.addSubview(player.view)
        setupNotification()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WLVideoPlayerView===deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /**
     为了防止定制器造成循环引用
     */
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview == nil {
            removeProgressTimer()
        }
    }
    
    /**
     添加视频通知事件
     */
    private func setupNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlaybackStateDidChange"), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deviceOrientationDidChange"), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerWillEnterFullscreen"), name: WLPlayerWillEnterFullscreenNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerWillExitFullscreen"), name: WLPlayerWillExitFullscreenNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerDidPlayToEndTime"), name: WLPlayerDidPlayToEndTimeNotification, object: nil)

    }
    /**
     当播放视频进入播放状态且用户自定义了视频控制面板的时候调动，
     添加一个定时器，为了更新用户自定义视频控制面板
     */
    private func addProgressTimer() {
        
        guard let customControlView = self.customControlView else {
            return
        }
        
        removeProgressTimer()
        let timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.progressTimer = timer
        // 立即更新控制面板显示内容
        playerControlHandler.updateProgress(customControlView)
    }
    /**
     当任何事件导致视频进入停止、暂停状态的时候调用
     移除更新自定义视频控制面板的那个定时器
     */
    private func removeProgressTimer() {
        self.progressTimer?.invalidate()
        self.progressTimer = nil
    }
    
    /**
     在用户点击播放按钮后调用(第一次播放某视频，一个视频只会调用一次)
     设置用户自定义视频控制器一些属性，
     起初是隐藏的，当视频真正播放的时候才展示
     */
    private func setupCustomControlView() {
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这
        player.controlStyle = .None
        customControlView.frame = self.bounds
        self.addSubview(customControlView)
        customControlView.hidden = true
        // 让playerControlHandler 处理视频控制事件
        customControlView.delegate = playerControlHandler
        playerControlHandler.player = player
        playerControlHandler.customControlView = customControlView
        
    }
    //========================================================
    // MARK: 功能方法
    //========================================================
    func play() {
        player.play()
        if let placeholderView = self.placeholderView {
            placeholderView.frame = self.bounds
            self.addSubview(placeholderView)
            self.bringSubviewToFront(placeholderView)
        }
        setupCustomControlView()
        player.view.frame = self.bounds
    }
    
    func playInView(inView: UIView) {
        self.inView = inView
        self.removeFromSuperview()
        self.frame = inView.bounds
        inView.addSubview(self)
        play()
    }
    
    func playInview(inView: UIView, withURL url: NSURL) {
        contentURL = url
        playInView(inView)
    }
    
    /**
     判断当前view是否显示在屏幕上
     */
    func isDisplayedInScreen() -> Bool {
        
        if self.hidden {
            return false
        }
        
        // self对应window的坐标
        let rect = self.convertRect(self.frame, toView: nil)
        let screenRect = UIScreen.mainScreen().bounds
        
        let intersectionRect = CGRectIntersection(rect, screenRect)
        if CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect) {
            return false;
        }
        
        return true
    }
    
    /**
     视频进入播放状态的时候进行调用(可能重复调用)
     */
    func readyToPlayer() {
        
        placeholderView?.removeFromSuperview()
        guard let customControlView = self.customControlView else {
            return
        }
        // 只有用户使用了自定义视频控制面板才会运行到这,开启自动更新面板的定时器
        customControlView.hidden = false
        customControlView.setVirtualHidden(false)
        addProgressTimer()
        
        NSNotificationCenter.defaultCenter().postNotificationName(WLPlayerCustomControlViewStateDidChangeNotification, object: nil)
    }
    
    //========================================================
    // MARK: 旋转\全屏控制方法
    //========================================================
    
    /**
    每当设备横屏的时候调用
    让视频播放器进入横屏的全屏播放状态
    - parameter angle: 旋转的角度
    */
    func toLandscape(angle: CGFloat) {
        if fullscreenModel == .LandscapeWhenInFullscreen && !isFullscreen {
            return
        }else {
            enterFullscreen(angle);
        }
    }
    /**
     每当设备进入竖屏的时候调用
     退出全屏播放状态
     */
    func toPortrait() {

        if fullscreenModel == .LandscapeWhenInFullscreen && isFullscreen  {
            
            changePlayerScreenState(UIApplication.sharedApplication().keyWindow!, needRotation: nil, isfullscreen: nil)
            
        }else if fullscreenModel == .AwaysLandscape {
            exitFullscreen()
        }
    }
    
    func enterFullscreen(angle: CGFloat?) {
        changePlayerScreenState(UIApplication.sharedApplication().keyWindow!, needRotation: angle, isfullscreen: true)
    }
    
    func exitFullscreen() {
        changePlayerScreenState(self.inView, needRotation: nil, isfullscreen: false)
    }
    /**
     用来改变播放器的显示状态(是否全屏、是否竖屏等)
     
     - parameter inView:       播放器处于的父视图
     - parameter angle:        是否需要旋转，nil代表不需要
     - parameter isfullscreen: 是否将要全屏显示，nil代表保存原状
     */
    func changePlayerScreenState(inView: UIView, needRotation angle: CGFloat?, isfullscreen: Bool?) {
        
        guard let customControlView = self.customControlView else {
            return
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            inView.addSubview(self)
            
            self.transform = CGAffineTransformIdentity
            self.transform = CGAffineTransformMakeRotation(angle ?? 0)
            
            self.frame = inView.bounds
            self.player.view.frame = self.bounds
            customControlView.relayoutSubView()
            
            }) { (finish) -> Void in
                if isfullscreen != nil {
                    self.isFullscreen = isfullscreen!
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        isfullscreen! ? WLPlayerDidEnterFullscreenNotification : WLPlayerDidExitFullscreenNotification, object: nil)
                }
            }
    }
    
    //========================================================
    // MARK: - 监听方法/回调方法
    //========================================================
    
    /**
    定时器回调方法，在视频播放的时候，每一秒调用一次，
    用来更新进度条以及播放的时间
    */
    func updateProgress() {
        playerControlHandler.updateProgress(customControlView!)
    }
    
    /**
     当视频状态发生改变的时候调用
     */
    func moviePlaybackStateDidChange() {
        switch player.playbackState {
        case .Stopped:
            removeProgressTimer()
            break
        case .Playing:
            readyToPlayer()
            break
        case .Paused:
            removeProgressTimer()
            break
        case .Interrupted:
            print("Interrupted")
            break
        default:
            removeProgressTimer()
            break
        }
    }
    
    /**
     当设备发生旋转的时候调用
     */
    func deviceOrientationDidChange() {
        guard isDisplayedInScreen() else {
            return
        }
        let orientation = UIDevice.currentDevice().orientation
        switch orientation {
        case .LandscapeLeft:
            toLandscape(CGFloat(M_PI_2))
            break
        case .LandscapeRight:
            toLandscape(CGFloat(-M_PI_2))
            break
        case .Portrait:
            toPortrait()
            break
        default:
            break
        }
    }
    
    /**
     即将进入全屏模式的时候调用
     */
    func playerWillEnterFullscreen() {
        switch fullscreenModel {
        case .AwaysLandscape:
            UIDevice.currentDevice().setValue(NSNumber(integer: UIDeviceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
            break
        case .LandscapeWhenInFullscreen:
            enterFullscreen(nil)
            break
        }
    }
    /**
     即将退出全屏模式的时候调用
     */
    func playerWillExitFullscreen() {
        switch fullscreenModel {
        case .AwaysLandscape:
            UIDevice.currentDevice().setValue(NSNumber(integer: UIDeviceOrientation.Portrait.rawValue), forKey: "orientation")
            break
        case .LandscapeWhenInFullscreen:
            UIDevice.currentDevice().setValue(NSNumber(integer: UIDeviceOrientation.Portrait.rawValue), forKey: "orientation")
            exitFullscreen()
            break
        }
    }
    
    func playerDidPlayToEndTime() {
        self.removeFromSuperview()
    }
}
