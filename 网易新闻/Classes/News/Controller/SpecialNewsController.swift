//
//  SpecialNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/18.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class SpecialNewsController: UIViewController, UITableViewDelegate, UITableViewDataSource, SpecialNewsHeardViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    
    var newsModel: NewsModel?
    var newsSpecialModel: NewsSpecialModel? {
        didSet {
            self.setupTableView()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor(red: 212 / 255.0, green: 25 / 255.0, blue: 38 / 255.0, alpha: 1.0)
        
        DataTool.loadSpecialNewsData(self.newsModel!.specialID!) { (newsSpecialModel) -> Void in
            guard newsSpecialModel != nil else {
                return
            }
            self.newsSpecialModel = newsSpecialModel
        }
    }

    func setupTableView() {
        
        guard let newsSpecialModel = self.newsSpecialModel else {
            return
        }
        
        self.titleLabel.text = newsSpecialModel.sname
        self.tableView.tableHeaderView = SpecialNewsHeardView(topics: newsSpecialModel.topics, topImageStr: self.newsSpecialModel!.banner,  delegate: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.newsSpecialModel?.topics.count ?? 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let topic = self.newsSpecialModel?.topics[section]
        return topic?.docs.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        let newsModel = topics?.docs[indexPath.row]
        assert(newsModel != nil)
        switch newsModel!.cellType! {
        case .ScrollPictureCell, .TopBigPicture:
            return 222
        case .NormalNewsCell:
            return 90
        case .ThreePictureCell:
            return 108
        case .BigPictureCell:
            return 177
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topics = self.newsSpecialModel?.topics[section]
        let str =  "   \(section+1)/\(self.newsSpecialModel!.topics.count) \(topics!.tname)"
        let attriStr = NSMutableAttributedString(string: str)
        let redStrAttr = [NSForegroundColorAttributeName : UIColor.redColor()]
        let redStr = "   \(section+1)" as NSString

        attriStr.addAttributes(redStrAttr, range: NSMakeRange(0, redStr.length))
        
        let label = UILabel()
        label.attributedText = attriStr
        label.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        label.font = UIFont.systemFontOfSize(13)
        return label
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        let newsModel = topics?.docs[indexPath.row]
        
        assert(newsModel != nil)
        let cell = tableView.dequeueReusableCellWithIdentifier(newsModel!.cellType.rawValue, forIndexPath: indexPath) as! NewsCell
        cell.newsModel = newsModel
        
        return cell
    }
    
     // MARK: - tableView代理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let topics = self.newsSpecialModel?.topics[indexPath.section]
        let newsModel = topics!.docs[indexPath.row]
        
        switch newsModel.cellType! {
        case .ScrollPictureCell, .TopBigPicture:
            break
        case .NormalNewsCell:
            
            if let _ = newsModel.specialID {
                let vc = storyboard?.instantiateViewControllerWithIdentifier("SpecialNewsController") as! SpecialNewsController
                vc.newsModel = newsModel
                self.navigationController?.pushViewController(vc, animated: true)
                
                if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
                    interactivePopGestureRecognizer.delegate = nil
                }
            }else {
                let vc = storyboard?.instantiateViewControllerWithIdentifier("DetailPictureView") as! DetaillNewsController
                vc.newsModel = newsModel
                self.navigationController?.pushViewController(vc, animated: true)
                if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
                    interactivePopGestureRecognizer.delegate = nil
                }
            }
            
        case .ThreePictureCell:
            break
        case .BigPictureCell:
            break
        }
        
    }

     // MARK: - SpecialNewsHeardViewDelegate
    func specialNewsTopicBtnClik(index: Int) {

        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .Top, animated: true)
    }
    
}
