//
//  MakeAMealTableViewCell.swift
//  FUDI
//
//  Created by Devontae Reid on 12/30/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class MakeAMealTableViewCell: UITableViewCell {

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
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let background = UIView()
    var backgroundViewForImage: UIImageView = UIImageView()
    let mealTitleView: UILabel = UILabel()
    
//    var favButton: DOFavoriteButton = DOFavoriteButton()
    
    
    // MARK: Main Setup
    func setup()
    {
        background.translatesAutoresizingMaskIntoConstraints = false
        background.sizeToFit()
        contentView.addSubview(background)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: background, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 120),
            NSLayoutConstraint(item: background, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: background, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: background, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        backgroundViewForImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewForImage.sizeToFit()
        contentView.addSubview(backgroundViewForImage)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: backgroundViewForImage, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundViewForImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 120),
            NSLayoutConstraint(item: backgroundViewForImage, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundViewForImage, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
//        favButton.translatesAutoresizingMaskIntoConstraints = false
//        favButton.image = UIImage(named: "heart")
//        favButton.imageColorOn = UIColor.redColor()
//        favButton.imageColorOff = UIColor.deepPink()
//        favButton.circleColor = UIColor.redColor()
//        favButton.lineColor = UIColor.deepPink()
//        contentView.addSubview(favButton)
//        contentView.addConstraints([
//            
//            NSLayoutConstraint(item: favButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30),
//            NSLayoutConstraint(item: favButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30),
//            NSLayoutConstraint(item: favButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 10),
//            NSLayoutConstraint(item: favButton, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: -20)
//            ])
        
        setupInfoView()
    }
    
    
    let servingSizeLabel: UILabel = UILabel()
    let caloriesLabel: UILabel = UILabel()
    let effortLabel: UILabel = UILabel()
    
    private func setupInfoView()
    {
        
        mealTitleView.translatesAutoresizingMaskIntoConstraints = false
        mealTitleView.sizeToFit()
        mealTitleView.numberOfLines = 0
        mealTitleView.font = UIFont.LatoRegular(15)
        mealTitleView.textAlignment = .Center
        background.addSubview(mealTitleView)
        background.addConstraints([
            
            NSLayoutConstraint(item: mealTitleView, attribute: .Left, relatedBy: .Equal, toItem: background, attribute: .Left, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: mealTitleView, attribute: .Right, relatedBy: .Equal, toItem: background, attribute: .Right, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: mealTitleView, attribute: .Top, relatedBy: .Equal, toItem: background, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: mealTitleView, attribute: .Bottom, relatedBy: .Equal, toItem: background, attribute: .CenterY, multiplier: 1.0, constant: 20)
            ])
        
        effortLabel.translatesAutoresizingMaskIntoConstraints = false
        effortLabel.sizeToFit()
        effortLabel.numberOfLines = 0
        effortLabel.font = UIFont.LatoRegular(10)
        effortLabel.textAlignment = .Center
        background.addSubview(effortLabel)
        background.addConstraints([
            NSLayoutConstraint(item: effortLabel, attribute: .Left, relatedBy: .Equal, toItem: background, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: effortLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 120),
            NSLayoutConstraint(item: effortLabel, attribute: .Top, relatedBy: .Equal, toItem: background, attribute: .CenterY, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: effortLabel, attribute: .Bottom, relatedBy: .Equal, toItem: background, attribute: .Bottom, multiplier: 1.0, constant: -20)
            ])

        
        servingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        servingSizeLabel.sizeToFit()
        servingSizeLabel.numberOfLines = 0
        servingSizeLabel.font = UIFont.LatoRegular(10)
        servingSizeLabel.textAlignment = .Center
        background.addSubview(servingSizeLabel)
        background.addConstraints([
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Left, relatedBy: .Equal, toItem: background, attribute: .Left, multiplier: 1.0, constant: 90),
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 120),
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Top, relatedBy: .Equal, toItem: background, attribute: .CenterY, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: background, attribute: .Bottom, multiplier: 1.0, constant: -20)
            ])
        
        
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.sizeToFit()
        caloriesLabel.numberOfLines = 0
        caloriesLabel.font = UIFont.LatoRegular(10)
        caloriesLabel.textAlignment = .Center
        background.addSubview(caloriesLabel)
        background.addConstraints([
            NSLayoutConstraint(item: caloriesLabel, attribute: .Right, relatedBy: .Equal, toItem: background, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: caloriesLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 120),
            NSLayoutConstraint(item: caloriesLabel, attribute: .Top, relatedBy: .Equal, toItem: background, attribute: .CenterY, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: caloriesLabel, attribute: .Bottom, relatedBy: .Equal, toItem: background, attribute: .Bottom, multiplier: 1.0, constant: -20)

            ])
        
    }

}
