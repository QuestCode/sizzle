//
//  ViewsForTimeline.swift
//  FUDI
//
//  Created by Devontae Reid on 11/11/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

public class DirectionView: UIView {
    
    let numberView: UILabel = UILabel()
    let detailView: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        // MARK: Container View for the two views
        
        let containerView: UIView = UIView(frame: self.bounds)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.blueColor()
        self.addSubview(containerView)
        self.addConstraints([
            
            NSLayoutConstraint(item: containerView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        numberView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        numberView.backgroundColor = UIColor.redColor()
        numberView.textAlignment = .Center
        numberView.font = UIFont.LatoBigBold(25)
        numberView.text = "1"
        containerView.addSubview(numberView)
        
        
        
        detailView.frame = CGRect(x: 40, y: 0, width: self.frame.width/2, height: 40)
        detailView.backgroundColor = UIColor.purpleColor()
        detailView.font = UIFont.LatoLight(10)
        detailView.numberOfLines = 0
        detailView.text = "HEY THEYRE FINISH"
        containerView.addSubview(detailView)
        
        
    }
}

public class StatisticView: UIView
{
    public let progressionView: KDCircularProgress = KDCircularProgress()
    public let percentageLabel: UILabel = UILabel()
    public let textLabel: UILabel = UILabel()
    var num: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        progressionView.translatesAutoresizingMaskIntoConstraints = false
        progressionView.frame = self.frame
        progressionView.startAngle = -90
        progressionView.progressThickness = 0.2
        progressionView.trackThickness = 0.1
        progressionView.clockwise = true
        progressionView.gradientRotateSpeed = 2
        progressionView.roundedCorners = false
        progressionView.glowMode = .Reverse
        progressionView.glowAmount = 0.3
        progressionView.angle = Int(num * 3.6)
        progressionView.setColors(UIColor.skyBlueColor() )
        self.addSubview(progressionView)
        self.addConstraints([
            
            NSLayoutConstraint(item: progressionView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progressionView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progressionView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: progressionView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.font = UIFont.LatoBold(20)
        percentageLabel.textAlignment = .Center
        //percentageLabel.frame = CGRect(x: 0, y: self.frame.height/2, width: self.frame.width, height: 40)
        percentageLabel.text = String(Int(num)) + "%"
        percentageLabel.layer.borderColor = UIColor.blackColor().CGColor
        progressionView.addSubview(percentageLabel)
        progressionView.addConstraints([
            
            NSLayoutConstraint(item: percentageLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: percentageLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 80),
            NSLayoutConstraint(item: percentageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: progressionView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: percentageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: progressionView, attribute: .CenterY, multiplier: 1.0, constant: -5)
            ])
        
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.LatoRegular(10)
        //textLabel.frame = CGRect(x: 0, y: self.frame.height/2.1, width: self.frame.width, height: 40)
        textLabel.textAlignment = .Center
        textLabel.text = "Protein".uppercaseString
        textLabel.textColor = UIColor.lightGrayColor()
        progressionView.addSubview(textLabel)
        progressionView.addConstraints([
            
            NSLayoutConstraint(item: textLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: textLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 70),
            NSLayoutConstraint(item: textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: progressionView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: progressionView, attribute: .CenterY, multiplier: 1.0, constant: 15)
            ])
        
        
    }
}