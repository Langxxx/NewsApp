//
//  CellProvider.swift
//  网易新闻
//
//  Created by wl on 15/11/19.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit


struct CellProvider {
    
    static func provideCellHeight(newsModelArray: [NewsModel], indexPath: NSIndexPath) -> CGFloat {
       
        let newsModel = newsModelArray[indexPath.row]
        switch newsModel.cellType! {
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
    
    static func provideCell(tableView: UITableView, newsModelArray: [NewsModel], indexPath: NSIndexPath) -> NewsCell {
        let newsModel = newsModelArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(newsModel.cellType.rawValue, forIndexPath: indexPath) as! NewsCell
        cell.newsModel = newsModel
        
        return cell
    }
    
    // TODO: 为了方便当前的测试，先暂时这样设置，以后肯定要改
    static func provideSelectedNewsVc(newsModelArray: [NewsModel], indexPath: NSIndexPath) -> UIViewController? {
        
        let newsModel = newsModelArray[indexPath.row]

        switch newsModel.cellType! {
        case .ScrollPictureCell, .TopBigPicture:
            return nil
        case .NormalNewsCell:
            
            if let _ = newsModel.specialID {
                let sb = UIStoryboard(name: "NewsList", bundle: nil)
                let vc = sb.instantiateViewControllerWithIdentifier("SpecialNewsController") as! SpecialNewsController
                vc.newsModel = newsModel
                return vc
            }else {
                let sb = UIStoryboard(name: "NewsList", bundle: nil)
                let vc = sb.instantiateViewControllerWithIdentifier("DetaillNewsController") as! DetaillNewsController
                vc.newsModel = newsModel
                return vc
            }
            
        case .ThreePictureCell:
            let sb = UIStoryboard(name: "NewsList", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("PictureNewsController") as! PictureNewsController
            vc.newsModel = newsModel
            return vc
        case .BigPictureCell:
            return nil
        }
        
    }

}



