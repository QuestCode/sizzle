//
//  MealPreviewView.swift
//  FUDI
//
//  Created by Devontae Reid on 11/7/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import MealFramework
import UIKit
import Koloda

public class MealPreviewView: UIView {
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView: UIView = UIView()
    private let infoView: UIView = UIView()
    
    private var mealImageForCard: UIImageView = UIImageView()
    private var mealTitleLabel: UILabel = UILabel()
    public let favButton: ZFRippleButton = ZFRippleButton()
    
    private func setupView()
    {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.freshEggplant(0.8)
        self.addSubview(backgroundView)
        self.addConstraints([
            NSLayoutConstraint(item: backgroundView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = infoView.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
        
        // MARK: Info View Settings
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = UIColor.whiteColor()
        infoView.layer.insertSublayer(gradient, atIndex: 10)
        backgroundView.addSubview(infoView)
        backgroundView.addConstraints([
            NSLayoutConstraint(item: infoView, attribute: .Top, relatedBy: .Equal, toItem: backgroundView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Left, relatedBy: .Equal, toItem: backgroundView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Right, relatedBy: .Equal, toItem: backgroundView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 180)
            ])
        
        // MARK: Meal Title Settings
        mealTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mealTitleLabel.font = UIFont.LatoRegular(15)
        mealTitleLabel.textColor = UIColor.blackColor()
        mealTitleLabel.textAlignment = .Center
        infoView.addSubview(mealTitleLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: mealTitleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealTitleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: mealTitleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: mealTitleLabel, attribute: .Left, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealTitleLabel, attribute: .Right, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        
        // Effort and time Label
        effortAndTimerLabelsSetup()
        
        // MARK: Meal Image Settings
        
        
        mealImageForCard.translatesAutoresizingMaskIntoConstraints = false
        mealImageForCard.backgroundColor = UIColor.blackColor()
        backgroundView.addSubview(mealImageForCard)
        backgroundView.addConstraints([
            NSLayoutConstraint(item: mealImageForCard, attribute: .Left, relatedBy: .Equal, toItem: backgroundView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageForCard, attribute: .Right, relatedBy: .Equal, toItem: backgroundView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageForCard, attribute: .CenterX, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageForCard, attribute: .Top, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterY, multiplier: 1.0, constant: -50),
            NSLayoutConstraint(item: mealImageForCard, attribute: .Bottom, relatedBy: .Equal, toItem: backgroundView, attribute: .Bottom, multiplier: 1.0, constant: -40)
            ])
        
        // MARK: Favorites Button Settings
        
        // Resize heart image to fit in button
        
        let size = CGSizeMake(30, 30)
        
        // heart image for favorite button
        var heartImage: UIImage = UIImage(named: "heart-outline")!
        heartImage = imageResize(image: heartImage, sizeChange: size)
        
        
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.backgroundColor = UIColor.peachColor()
        favButton.setTitle("  ADD TO FAVORITES", forState: .Normal)
        favButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        favButton.setImage(heartImage, forState: .Normal)
        favButton.titleLabel?.font = UIFont.LatoBigBold(15)
        
        self.addSubview(favButton)
        self.addConstraints([
            NSLayoutConstraint(item: favButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: favButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: favButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: favButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        
        mealTitleLabel.text = mealTitle
        mealImageForCard.image = mealImage
        
        
        // MARK: Meal Info Settings
    }
    
    private let effortLabel: UILabel = UILabel()
    private let timerLabel: UILabel = UILabel()
    private let numOfPersonLabel: UILabel = UILabel()
    
    private func effortAndTimerLabelsSetup()
    {
        let chefHat: UIImageView = UIImageView()
        chefHat.image = UIImage(named: "chefHat")
        chefHat.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(chefHat)
        infoView.addConstraints([
            NSLayoutConstraint(item: chefHat, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: chefHat, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: chefHat, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 80),
            NSLayoutConstraint(item: chefHat, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -55)
            ])
        
        effortLabel.font = UIFont.LatoRegular(10)
        effortLabel.textColor = UIColor.blackColor()
        effortLabel.translatesAutoresizingMaskIntoConstraints = false
        effortLabel.textAlignment = .Center
        infoView.addSubview(effortLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: effortLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: effortLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: effortLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 78),
            NSLayoutConstraint(item: effortLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10)
            ])
        
        
        let person: UIImageView = UIImageView()
        person.image = UIImage(named: "person")
        person.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(person)
        infoView.addConstraints([
            NSLayoutConstraint(item: person, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: person, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: person, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: person, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -55)
            ])
        
        numOfPersonLabel.font = UIFont.LatoRegular(10)
        numOfPersonLabel.textColor = UIColor.blackColor()
        numOfPersonLabel.translatesAutoresizingMaskIntoConstraints = false
        numOfPersonLabel.textAlignment = .Center
        infoView.addSubview(numOfPersonLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10)
            ])
        
        let timer: UIImageView = UIImageView()
        timer.image = UIImage(named: "stopwatch")
        timer.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(timer)
        infoView.addConstraints([
            NSLayoutConstraint(item: timer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: timer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: timer, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: -80),
            NSLayoutConstraint(item: timer, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -55)
            ])
        
        timerLabel.font = UIFont.LatoRegular(10)
        timerLabel.textColor = UIColor.blackColor()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .Center
        infoView.addSubview(timerLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: timerLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: timerLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: timerLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant:-80),
            NSLayoutConstraint(item: timerLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -10)
            ])
        
        effortLabel.text = effort.getEffortInfo()
        numOfPersonLabel.text = servingSize.getTitle()
        timerLabel.text = time.getTitle()
        
        
    }
    
    

}

// MARK: FUCNTIONS TO RESIZE IMAGES FOR BUT

extension MealPreviewView
{
    /**
    Resize UIImageView
    :param: UImage
    :param: new size CGSize
    :return: new UImage rezised
    */
    private func imageResize (image image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
}
