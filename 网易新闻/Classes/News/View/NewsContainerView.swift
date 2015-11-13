//
//  NewsContainerView.swift
//  网易新闻
//
//  Created by wl on 15/11/13.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class NewsContainerView: UIScrollView, CycleCacheProtocol {

    var buffer: [Int : UIView] = [:]
    var maxBufferCount: Int = 3
    
}

/**
*  缓存协议，用来优化scrollView的显示
*
*/
protocol CycleCacheProtocol {
    /// 存储所有可能显示的view
    var buffer: [Int : UIView] {get set}
    /// 缓存的数量(包括正在显示的view)
    var maxBufferCount: Int {get set}
    
    mutating func showViewInScrollView(showView: UIView, showViewIndex: Int)
    
}

extension CycleCacheProtocol where Self : UIScrollView {

    
    mutating func showViewInScrollView(showView: UIView, showViewIndex: Int) {

        showView.frame = self.bounds

        self.buffer[showViewIndex] = showView
        // 先移除所有的view，还有优化的空间
        for (_, view) in buffer {
            view.removeFromSuperview()
        }
        
        // 将缓存的view添加到视图
        let cacheCount = (self.maxBufferCount - 1) / 2
        for var i = showViewIndex - cacheCount; i <= showViewIndex + cacheCount; i++ {
            if let view = buffer[i] {
                self.addSubview(view)
            }
        }
 
    }
}

