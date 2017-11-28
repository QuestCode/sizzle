//
//  CommentsTableView.swift
//  FUDI
//
//  Created by Devontae Reid on 11/14/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class CommentsTableView: UITableView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        
        cell.userName.text = "Darren"
        cell.userImage.image = UIImage(named: "Darnell")
        cell.comment.text = "Hey that looks good"
        
        // Configure the cell...
        
        return cell
    }
}
