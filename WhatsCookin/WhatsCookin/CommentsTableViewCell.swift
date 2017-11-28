//
//  CommentsTableViewCell.swift
//  FUDI
//
//  Created by Devontae Reid on 11/14/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let userImage: UIImageView = UIImageView()
    let userName: UILabel = UILabel()
    let comment: UILabel = UILabel()
    
    private func setupCell()
    {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 12.5
        contentView.addSubview(userImage)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: userImage, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 25),
            NSLayoutConstraint(item: userImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 25),
            NSLayoutConstraint(item: userImage, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: userImage, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0)
            ])
       
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.textColor = UIColor.freshEggplant()
        userName.font = UIFont.LatoRegular(12)
        contentView.addSubview(userName)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: userName, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 25),
            NSLayoutConstraint(item: userName, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 100),
            NSLayoutConstraint(item: userName, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: -60),
            NSLayoutConstraint(item: userName, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: -10)
            ])
        
        
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.textColor = UIColor.lightGrayColor()
        comment.font = UIFont.LatoLight(10)
        comment.sizeToFit()
        contentView.addSubview(comment)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: comment, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 25),
            NSLayoutConstraint(item: comment, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 100),
            NSLayoutConstraint(item: comment, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: -60),
            NSLayoutConstraint(item: comment, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 5)
            ])
    }
}
