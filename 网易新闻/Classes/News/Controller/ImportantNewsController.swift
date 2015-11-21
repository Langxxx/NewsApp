//
//  ImportantNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/21.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ImportantNewsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var title2subtitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var title2topviewConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    lazy var tableViewInsetTop: CGFloat = {
        return self.imageView.frame.height + 10
    }()
    
    lazy var maxOffsetY: CGFloat =  {
        return self.imageView.frame.height - self.topView.frame.height
    }()
    
    let maxScale: CGFloat = 1.5
    
    var newsModelArray: [NewsModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(tableViewInsetTop, 0, 0, 0)
        self.topView.clipsToBounds = false
        DataTool.loadNewsData("http://c.m.163.com/nc/article/list/T1429173683626/0-20.html", newsKey: "T1429173683626") { (newsArray) -> Void in
            guard newsArray != nil else {
                return
            }
            self.newsModelArray = newsArray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
     // MARK: - tableVIew 数据源
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.newsModelArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return CellProvider.provideCell(tableView, newsModelArray: self.newsModelArray!, indexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return CellProvider.provideCellHeight(self.newsModelArray!, indexPath: indexPath)
    }
    
    // MARK: - Table view 代理
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = CellProvider.provideSelectedNewsVc(self.newsModelArray!, indexPath: indexPath)
        
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
