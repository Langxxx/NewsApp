//
//  DetaillNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/16.
//  Copyright © 2015年 wl. All rights reserved.
//  新闻详情界面看控制器

import UIKit

class DetaillNewsController: UIViewController, UIWebViewDelegate {
//========================================================
// MARK: - 一些属性
//========================================================
    var newsModel: NewsModel?
    var newsDetailModel: NewsDetailModel? {
        didSet {
            self.loadNewsDetail()
            self.setupSubView()
        }
    }
    /// 右上角的跟帖按钮，点击进入评论界面
    @IBOutlet weak var replyCountBtn: UIButton!
    /// 左上角返回按钮
    @IBOutlet weak var backBtn: UIButton!
    /// 展示新闻的view
    @IBOutlet weak var webView: UIWebView!
//========================================================
// MARK: - 一些方法
//========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false

        assert(self.newsModel?.docid != nil)
        // 加载本地缓存数据
        if let newsDetailModel = LocalDataTool.getNewsDetailInfo(self.newsModel!.docid!) as? NewsDetailModel {
            self.newsDetailModel = newsDetailModel
        }
        DataTool.loadNewsDetailData(self.newsModel!.docid!) { (newsModel) -> Void in
            guard newsModel != nil else {
                return
            }
            self.newsDetailModel = newsModel
            // 本地存储
            LocalDataTool.saveNewsDetailInfo(self.newsModel!.docid!, anyModel: newsModel!)
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupSubView() {
        
        if let replyCount = self.newsModel?.replyCount {
            if replyCount > 10000 {
                self.replyCountBtn.setTitle(String(format: "%.1f万跟帖", Float(replyCount)/10000.0), forState: .Normal)
            }else {
                self.replyCountBtn.setTitle("\(replyCount)跟帖", forState: .Normal)
            }
        }
        
    }
    /**
    加载描述界面
    */
    func loadNewsDetail() {
        assert(self.newsDetailModel != nil)
        let css = NSBundle.mainBundle().URLForResource("Details.css", withExtension: nil)!
        
        var html = "<html>"
        
        html += "<head>"
        html += "<link rel=\"stylesheet\" href="
        html += "\"\(css)\""
        html += ">"
        html += "</head>"

        html += self.getBody()
        html += "</html>"
        
        self.webView.loadHTMLString(html, baseURL: nil)

    }
    /**
    被loadNewsDetail方法调用，用来拼接<body>的内容
    */
    func getBody() -> String{
        
        var body = "<body>"
        
        body += "<div class=\"title\">"
        body += self.newsDetailModel!.title
        body += "</div>"
        

        body += "<div class=\"time\">"
        body += self.newsDetailModel!.ptime
        body += "</div>"
        
        body += self.newsDetailModel!.body
        
        for (index, detailImageModel) in self.newsDetailModel!.img.enumerate() {
            var imgTag = "<div class=\"image\">"
            
            imgTag += "<img id=\"\(index)\" "
            //用 * 符号切割字符串，"haha*hehe*xixi" ==>  "haha" "hehe" "xixi"
            let pixel = detailImageModel.pixel.componentsSeparatedByString("*")
            var width = Float(pixel.first!) ?? 0
            var height = Float(pixel.last!) ?? 0
            
            let maxWidth = Float(self.view.bounds.width * 0.95)
            if width > maxWidth {
                height =  height *  maxWidth / width
                width = maxWidth
            }
            
            // 这里是添加图片点击事件
            imgTag += "onload="
            imgTag += "\""
            imgTag += "this.onclick = function() {  window.location.href = 'sx:index=' +this.id;};"
            imgTag += "\""
           
            imgTag += "width=\(width) "
            imgTag += "height=\(height) "
            imgTag += "src=\(detailImageModel.src)>"
            
            imgTag += "<div class=\"imageDetail\">"
            imgTag += "\(detailImageModel.alt)"
            imgTag += "</div>"
            

            imgTag += "</div>"
            
            // 替换位置
            body = body.stringByReplacingOccurrencesOfString(detailImageModel.ref, withString: imgTag)
        }
        
        body += "</body>"
        
        return body
    }
     // MARK:  监听方法
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let newsDetailModel = self.newsDetailModel else {
            return
        }
        let vc = segue.destinationViewController as! ReplyController
        vc.replyBoard = newsDetailModel.replyBoard
        vc.requestID =  newsDetailModel.docid
    }
     // MARK: - UIWebView代理
    /**
    这里用来显示被点击的那一张图片
    */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let str = request.URL?.absoluteString
        if let temp = str?.componentsSeparatedByString("=") where temp.count > 1{
            DetailPictureView.showAtWindow(self.newsDetailModel!, index: Int(temp.last!)!)
        }
        return true
    }
}
