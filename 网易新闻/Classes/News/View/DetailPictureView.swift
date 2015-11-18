//
//  DetailPictureView.swift
//  网易新闻
//
//  Created by wl on 15/11/17.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class DetailPictureView: UIView, CyclePictureViewDelegate {
    
    @IBOutlet weak var cycPictureView: CyclePictureView!
    @IBOutlet weak var countLabel: UILabel!
    var imageDetail: [String] = []
    
    static func showAtWindow(newsDetailModel: NewsDetailModel, index: Int) {

        let window = UIApplication.sharedApplication().keyWindow
        let detailPictureView = NSBundle.mainBundle().loadNibNamed("DetailPictureView", owner: nil, options: nil).first as! DetailPictureView
        
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
        detailPictureView.cycPictureView.pictureContentMode = .ScaleAspectFit
        window?.addSubview(detailPictureView)
        
        detailPictureView.countLabel.text = "\(index + 1)/\(detailPictureView.imageDetail.count) \(detailPictureView.imageDetail[index])"
        
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
