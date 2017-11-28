//
//  CustomCell.swift
//  Practice
//
//  Created by Devontae Reid on 6/12/16.
//  Copyright © 2016 SoloStack. All rights reserved.
//

import UIKit

class DirectionCell: AEAccordionTableViewCell {

    
    var headerView: HeaderView! {
        didSet{
            self.headerView.imageView.tintColor = UIColor.white
        }
    }
    
    var directionView: DirectionCellView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupDirectionCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setExpanded(expanded: Bool, animated: Bool) {
        super.setExpanded(expanded: expanded, animated: animated)
        
        if !animated {
            self.toggleCell()
        } else {
            let alwaysOptions: UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState, .TransitionCrossDissolve]
            let expandedOptions: UIViewAnimationOptions = [.TransitionFlipFromTop, .CurveEaseOut]
            let collapsedOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .CurveEaseIn]
            let options: UIViewAnimationOptions = expanded ? alwaysOptions.union(expandedOptions) : alwaysOptions.union(collapsedOptions)
            
            UIView.transitionWithView(directionView, duration: 0.1, options: options, animations: { () -> Void in
                self.toggleCell()
                }, completion: nil)
        }
    }
    
    private func toggleCell() {
        directionView.hidden = !expanded
        headerView.imageView.transform = expanded ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
    }
    
    private func setupDirectionCell() {
        headerView = HeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.peachColor()
        contentView.addSubview(headerView)
        contentView.addConstraints([
            NSLayoutConstraint(item: headerView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: headerView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        directionView = DirectionCellView()
        directionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(directionView)
        contentView.addConstraints([
            NSLayoutConstraint(item: directionView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: directionView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
    }

}

/*----------------------------MARK: HeaderView----------------------*/
class HeaderView : AEXibceptionView {
    
    var stepLabel = UILabel()
    var timerLabel = UILabel()
    var imageView = UIImageView()
    
    override init() {
        super.init()
        self.setupHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHeaderView()
    }
    
    private func setupHeaderView() {
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.font = UIFont.LatoBigBold(20)
        stepLabel.textColor = UIColor.blackColor()
        self.addSubview(stepLabel)
        self.addConstraints([
            NSLayoutConstraint(item: stepLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: stepLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: -60),
            NSLayoutConstraint(item: stepLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: stepLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -20)
            ])
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.font = UIFont.LatoRegular(16)
        timerLabel.textColor = UIColor.blackColor()
        timerLabel.textAlignment = .Center
        self.addSubview(timerLabel)
        self.addConstraints([
            NSLayoutConstraint(item: timerLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 70),
            NSLayoutConstraint(item: timerLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60),
            NSLayoutConstraint(item: timerLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timerLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -10)
            ])
    }
}


/*----------------------------MARK: DirectionView----------------------*/
class DirectionCellView : AEXibceptionView {
    var detailView: UITextView!

    override init() {
        super.init()
        self.setupDirectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupDirectionView()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDirectionView(){
        detailView = UITextView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.backgroundColor =  UIColor.peachColor(0.7)
        detailView.font = UIFont.LatoRegular(14)
        detailView.textAlignment = .Center
        detailView.editable = false
        self.addSubview(detailView)
        self.addConstraints([
            NSLayoutConstraint(item: detailView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: detailView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 130)
            ])
    }
}
