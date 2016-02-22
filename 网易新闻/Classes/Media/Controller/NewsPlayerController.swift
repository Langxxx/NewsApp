//
//  NewsPlayerController.swift
//  网易新闻
//
//  Created by wl on 16/2/21.
//  Copyright © 2016年 wl. All rights reserved.
//  MPMoviePlayerController在ios9已经被废弃，先暂时使用这个框架，过段时间再使用AVKit框架

import UIKit
import MediaPlayer

class NewsPlayerController: MPMoviePlayerController{
    
    lazy var controlView = {
        return NSBundle.mainBundle().loadNibNamed("PlayerControlView", owner: nil, options: nil).last as! UIView
    }()
    
    
    deinit {
        print("NewsPlayerController-----deinit")
    }
    
    func playWithUrl(url: NSURL, inView: UIView) {

        //添加到视图
        self.view.frame = inView.bounds
        inView.addSubview(self.view)

        self.contentURL = url
        self.play()
        
        self.controlStyle = .None
        //添加通知事件
        
        //播放的视频"可以播放"的时候调用
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerReadyForDisplayDidChange"), name: MPMoviePlayerReadyForDisplayDidChangeNotification, object: nil)
        
    }
    
     // MARK: - 回调方法
    
    /**
    播放的视频"可以播放"的时候调用,设置播放的控制面板
    */
    func playerReadyForDisplayDidChange() {
        //设置播放控制视图
        self.controlView.frame = self.view.bounds
        self.view.addSubview(self.controlView)
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.controlView.hidden = true
        }
    }
    
}
