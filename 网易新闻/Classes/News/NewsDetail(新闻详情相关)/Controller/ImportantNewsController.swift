//
//  ImportantNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/21.
//  Copyright © 2015年 wl. All rights reserved.
//  24小时要闻界面控制器
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import UIKit

class ImportantNewsController: UIViewController {
//========================================================
// MARK: - 一些属性
//========================================================
    @IBOutlet weak var tableView: UITableView!
    /// 顶部背景图
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    /// 24小时要闻标题
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    /// 顶部背景图距离顶部的约束(X)
    @IBOutlet weak var imageViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var title2subtitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var title2topviewConstraint: NSLayoutConstraint!
    
    lazy var tableViewInsetTop: CGFloat = {
        return self.imageView.frame.height + 10
    }()
    
    lazy var maxOffsetY: CGFloat =  {
        return self.imageView.frame.height - self.topView.frame.height
    }()
    
    let maxScale: CGFloat = 1.5
    let channelID = "T1429173683626"
    
    let newsListProvider = NewsListProvider()
    var newsModelArray: [NewsModel]? {
        didSet {
            self.newsListProvider.newsModelArray = self.newsModelArray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(tableViewInsetTop, 0, 0, 0)
        self.topView.clipsToBounds = false
        
        self.tableView.dataSource = self.newsListProvider
        self.newsListProvider.tableView = self.tableView
        // 加载本地缓存数据
        if let newsArray = LocalDataTool.getNewsList(channelID) {
            self.newsModelArray = newsArray
        }
        
        DataTool.loadNewsData("http://c.m.163.com/nc/article/list/T1429173683626/0-20.html", newsKey: channelID) { (newsArray) -> Void in
            guard newsArray != nil else {
                return
            }
            self.newsModelArray = newsArray
            //本地存储
            LocalDataTool.saveNewsList(self.channelID, newsModelArray: newsArray!)
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {

    }
    
}
// MARK: - Table view 代理
extension ImportantNewsController: UITableViewDelegate, CellAttributeProtocol {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return provideCellHeight(self.newsModelArray!, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = provideSelectedNewsVc(self.newsModelArray!, indexPath: indexPath)
        
        self.navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        var constant =  -(tableViewInsetTop + offsetY) < -maxOffsetY ? -maxOffsetY : -(tableViewInsetTop + offsetY)
        
        if constant >= 0 {
            constant = 0
            self.titleLabel.transform = CGAffineTransformMakeScale(maxScale, maxScale)
            self.subtitleLabel.alpha = 1
            self.title2subtitleConstraint.priority = 999
        }else if constant < 0 {
            let ratio = constant / -maxOffsetY
            
            let scale = maxScale - (maxScale - 1) * ratio
            self.subtitleLabel.alpha = 1 - ratio * 2
            // sb里需要将title2subtitleConstraint初始值设置为999(不能为1000)
            self.title2subtitleConstraint.priority = self.subtitleLabel.frame.origin.y - self.title2topviewConstraint.constant <= CGRectGetMaxY(self.topView.frame)  ? 500 : 999
            
            self.titleLabel.transform = CGAffineTransformMakeScale(scale, scale)
            
        }
        self.imageViewXConstraint.constant = constant
        
        
    }
}
