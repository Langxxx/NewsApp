//
//  NewsListContorller.swift
//  网易新闻
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class NewsListContorller: UITableViewController {

    var channel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return 20
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsNormalCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "\(self.channel)\(indexPath.row)"
        return cell
    }
    
}
