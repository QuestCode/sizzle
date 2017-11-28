//
//  CabinetCollectionViewCell.swift
//  FUDI
//
//  Created by Devontae Reid on 11/28/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class CabinetCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let itemImage: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let quantityLabel: UILabel = UILabel()
    
    func setup()
    {
        contentView.backgroundColor = UIColor.peachColor()
        contentView.clipsToBounds = true
        
        itemImage.frame = contentView.frame
        itemImage.clipsToBounds = true
        itemImage.backgroundColor = UIColor.redColor()
        contentView.addSubview(itemImage)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.whiteColor()
        titleLabel.font = UIFont.LatoRegular(10)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Center
        titleLabel.sizeToFit()
        titleLabel.clipsToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 20)
            ])
        
        let tint = UIView()
        tint.translatesAutoresizingMaskIntoConstraints = false
        tint.backgroundColor = UIColor.lightGrayColor()
        tint.clipsToBounds = true
        tint.alpha = 0.4
        contentView.addSubview(tint)
        contentView.addConstraints([
            NSLayoutConstraint(item: tint, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: tint, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tint, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tint, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0)
            ])
        
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.textAlignment = .Center
        quantityLabel.numberOfLines = 1
        quantityLabel.textColor = UIColor.blackColor()
        quantityLabel.font = UIFont.LatoBigBold(50)
        quantityLabel.clipsToBounds = true
        tint.addSubview(quantityLabel)
        tint.addConstraints([
            NSLayoutConstraint(item: quantityLabel, attribute: .Bottom, relatedBy: .Equal, toItem: tint, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: quantityLabel, attribute: .Left, relatedBy: .Equal, toItem: tint, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: quantityLabel, attribute: .Right, relatedBy: .Equal, toItem: tint, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: quantityLabel, attribute: .Top, relatedBy: .Equal, toItem: tint, attribute: .Top, multiplier: 1.0, constant: 0)
            ])
    }
}
