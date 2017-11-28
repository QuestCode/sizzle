//
//  MenuTableViewCell.swift
//  FUDI
//
//  Created by Devontae Reid on 11/14/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import MealFramework

class MenuTableViewCell: UITableViewCell {

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
    
    
    let mealImageView: UIImageView = UIImageView()
    let mealTitleView: UILabel = UILabel()
    
    var favButton: DOFavoriteButton = DOFavoriteButton()
    
    
    // MARK: Main Setup
    func setup() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.removeFromSuperview()
        contentView.addSubview(mealImageView)
        contentView.addConstraints([

            NSLayoutConstraint(item: mealImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.image = UIImage(named: "heart")
        favButton.imageColorOn = UIColor.redColor()
        favButton.imageColorOff = UIColor.deepPink()
        favButton.circleColor = UIColor.redColor()
        favButton.lineColor = UIColor.deepPink()
        contentView.addSubview(favButton)
        contentView.addConstraints([
            
            NSLayoutConstraint(item: favButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: favButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: favButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: favButton, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: -20)
            ])
        
        setupInfoView()
    }
    
    let servingSizeLabel: UILabel = UILabel()
    let effortLabel: UILabel = UILabel()
    let timeLabel: UILabel = UILabel()
    let datelabel = UILabel()
    
    private func setupInfoView() {
        let infoView: UIView = UIView()
        infoView.backgroundColor = UIColor.whiteColor()
        infoView.alpha = 0.7
        infoView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.addSubview(infoView)
        mealImageView.addConstraints([
            
            NSLayoutConstraint(item: infoView, attribute: .Left, relatedBy: .Equal, toItem: mealImageView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Right, relatedBy: .Equal, toItem: mealImageView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Bottom, relatedBy: .Equal, toItem: mealImageView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60)
            ])
        
        mealTitleView.translatesAutoresizingMaskIntoConstraints = false
        mealTitleView.textColor = UIColor.blackColor()
        mealTitleView.textAlignment = .Center
        mealTitleView.font = UIFont.LatoRegular(15)
        infoView.addSubview(mealTitleView)
        infoView.addConstraints([
            NSLayoutConstraint(item: mealTitleView, attribute: .Right, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealTitleView, attribute: .Left, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealTitleView, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealTitleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30)
            
            ])
        
        
        // MARK: Effort Label
        let chefhat: UIImageView = UIImageView(image: UIImage(named: "chefHat"))
        chefhat.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(chefhat)
        infoView.addConstraints([
            
            NSLayoutConstraint(item: chefhat, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -13),
            NSLayoutConstraint(item: chefhat, attribute: .Left, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 70),
            NSLayoutConstraint(item: chefhat, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: chefhat, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 10)
            ])
       
        
        
        effortLabel.translatesAutoresizingMaskIntoConstraints = false
        effortLabel.textColor = UIColor.blackColor()
        effortLabel.font = UIFont.LatoRegular(12)
        infoView.addSubview(effortLabel)
        infoView.addConstraints([
            
            NSLayoutConstraint(item: effortLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: effortLabel, attribute: .Left, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 90),
            NSLayoutConstraint(item: effortLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: effortLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 60)
            ])
        
        // MARK: Serving Size Label
        let personImage: UIImageView = UIImageView(image: UIImage(named: "person"))
        personImage.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(personImage)
        infoView.addConstraints([
            
            NSLayoutConstraint(item: personImage, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: personImage, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: personImage, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: personImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 10)
            ])
        
        
        servingSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        servingSizeLabel.textColor = UIColor.blackColor()
        servingSizeLabel.font = UIFont.LatoRegular(12)
        infoView.addSubview(servingSizeLabel)
        infoView.addConstraints([
            
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: servingSizeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: servingSizeLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 60)
            ])
        
        
        //MARK: Timer Label
        let timer: UIImageView = UIImageView(image: UIImage(named: "stopwatch"))
        timer.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(timer)
        infoView.addConstraints([
            
            NSLayoutConstraint(item: timer, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -11),
            NSLayoutConstraint(item: timer, attribute: .Right, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: -92),
            NSLayoutConstraint(item: timer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: timer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 10)
            ])
    
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor.blackColor()
        timeLabel.font = UIFont.LatoRegular(12)
        infoView.addSubview(timeLabel)
        infoView.addConstraints([
            
            NSLayoutConstraint(item: timeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: timeLabel, attribute: .Right, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: -30),
            NSLayoutConstraint(item: timeLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: timeLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 60)
            ])
        

        datelabel.translatesAutoresizingMaskIntoConstraints = false
        datelabel.textColor = UIColor.blackColor()
        datelabel.font = UIFont.LatoRegular(13)
        mealImageView.addSubview(datelabel)
        mealImageView.addConstraints([
            NSLayoutConstraint(item: datelabel, attribute: .Top, relatedBy: .Equal, toItem: mealImageView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: datelabel, attribute: .Left, relatedBy: .Equal, toItem: mealImageView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: datelabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: datelabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 150)
            ])
    }

    
    
}
