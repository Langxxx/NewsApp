//
//  DetaillNewsController.swift
//  网易新闻
//
//  Created by wl on 15/11/16.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class DetaillNewsController: UIViewController, UIWebViewDelegate {

    var newsModel: NewsModel?
    var newsDetailModel: NewsDetailModel? {
        didSet {
            self.loadNewsDetail()
            self.setupSubView()
        }
    }
    
    @IBOutlet weak var replyCountBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false

        assert(self.newsModel?.docid != nil)
        DataTool.loadNewsDetailData(self.newsModel!.docid!) { (newsModel) -> Void in
            guard newsModel != nil else {
                return
            }
            self.newsDetailModel = newsModel
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
    
    @IBAction func backBtnClik() {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
     // MARK: - UIWebView代理
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let str = request.URL?.absoluteString
        if let temp = str?.componentsSeparatedByString("=") where temp.count > 1{
            DetailPictureView.showAtWindow(self.newsDetailModel!, index: Int(temp.last!)!)
        }
        return true
    }
}
