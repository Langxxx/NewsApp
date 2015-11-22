//
//  DetailPictureView.swift
//  网易新闻
//
//  Created by wl on 15/11/17.
//  Copyright © 2015年 wl. All rights reserved.
//  用于新闻详情页面，类似于图片查看器当点击
//  webVIew中某一张图片的时候显示

import UIKit

class DetailPictureView: UIView, CyclePictureViewDelegate {
    
    /// 用来显示图片的图片查看器
    @IBOutlet weak var cycPictureView: CyclePictureView!
    /// 用来显示图片介绍的label(也展示了页数)
    @IBOutlet weak var countLabel: UILabel!
    /// 图片的描述
    var imageDetail: [String] = []
    /**
    点击webVIew中某一张图片的时候被调用,
    展示webView中所有的图片。
    - parameter newsDetailModel: 装有图片地址的新闻模型
    - parameter index:           被点击图片索引
    */
    static func showAtWindow(newsDetailModel: NewsDetailModel, index: Int) {

        let window = UIApplication.sharedApplication().keyWindow
        let detailPictureView = NSBundle.mainBundle().loadNibNamed("DetailPictureView", owner: nil, options: nil).first as! DetailPictureView
        // 取出所有图片的url字符串
        var urlArrya: [String] = []
        for model in newsDetailModel.img {
            urlArrya.append(model.src)
            detailPictureView.imageDetail.append(model.alt)
        }
        
        detailPictureView.cycPictureView.autoScroll = false
        detailPictureView.cycPictureView.needEndlessScroll = false
        detailPictureView.cycPictureView.showPageControl = false
        detailPictureView.cycPictureView.delegate = detailPictureView
        detailPictureView.cycPictureView.imageURLArray =  urlArrya
        detailPictureView.cycPictureView.placeholderImage = UIImage(named: "placeholder")
        detailPictureView.cycPictureView.pictureContentMode = .ScaleAspectFit
        window?.addSubview(detailPictureView)
        
        detailPictureView.countLabel.text = "\(index + 1)/\(detailPictureView.imageDetail.count) \(detailPictureView.imageDetail[index])"
        
        // 设置出现的动画效果,调用dispatch_after的原因是先让保证cycPictureView先布局完毕
        // 才能利用showPictureWithIndex显示用户所点击的哪一张图片
        detailPictureView.frame = window!.bounds
        detailPictureView.alpha = 0.0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(200 * NSEC_PER_MSEC)), dispatch_get_main_queue()) { () -> Void in
            detailPictureView.cycPictureView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            detailPictureView.cycPictureView.showPictureWithIndex(index)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                detailPictureView.alpha = 1
                detailPictureView.cycPictureView.transform = CGAffineTransformMakeScale(1, 1)
            })
        }
        
    }
    
    deinit {
//        print("DetailPictureView--deinit")
    }
    
    
    // TODO: 保存到相册,有时间再做
    @IBAction func saveBtnClik(sender: AnyObject) {


    }
    
     // MARK: - cyclePictureView代理
    /**
    当图片被点击的时候调用，直接移除当前页面
    */
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0.0
            self.cycPictureView.collectionView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }) { (finish) -> Void in
                self.removeFromSuperview()
        }
    }

    /**
    这个协议方法是自己修改源码添加的，原本是没有的
    */
    func cyclePictureViewDidEndDecelerating(cyclePictureView: CyclePictureView) {
        let index = cyclePictureView.getCurrentCellIndex()
        self.countLabel.text = "\(index + 1)/\(self.imageDetail.count) \(self.imageDetail[index])"
    }
    
}

extension CyclePictureView {
    
    func showPictureWithIndex(index: Int) {
        // 这里得把源码的私有限制给删除才不报错
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .None, animated: false)
    }
    
    func getCurrentCellIndex() -> Int{
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let currentIndex = Int(collectionView.contentOffset.x / flowLayout.itemSize.width)
        
        return currentIndex
    }
    

}
