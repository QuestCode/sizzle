//
//  MealPreviewViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 11/16/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class MealPreviewViewController: UIViewController {

    private let infoView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 20
        self.view.backgroundColor = UIColor.peachColor()
        self.view.clipsToBounds = true
        self.setupView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        mealImageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func handlePan(sender: UIPanGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Ended){
            self.dismissViewControllerAnimated(true , completion: nil);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var mealImageView: UIImageView = UIImageView()
    var mealTitleLabel: UILabel = UILabel()
    
    private func setupView()
    {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = infoView.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
        
        // MARK: Info View Settings
        
        infoView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3)
        infoView.backgroundColor = UIColor.whiteColor()
        infoView.layer.insertSublayer(gradient, atIndex: 10)
        view.addSubview(infoView)

        
        // MARK: Meal Title Settings
        
        mealTitleLabel.frame = CGRect(x: view.frame.width/4, y: infoView.frame.height/2, width: infoView.frame.width/2, height: 30)
        mealTitleLabel.font = UIFont.LatoRegular(15)
        mealTitleLabel.textColor = UIColor.blackColor()
        mealTitleLabel.textAlignment = .Center
        mealTitleLabel.text = mealTitle
        
        view.addSubview(mealTitleLabel)
        
        
        // Effort and time Label
        effortAndTimerLabelsSetup()
        
        // Back and Forward Buttons
        guideFunctions()
        
        // MARK: Meal Image Settings
        
        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mealImageView)
        view.addConstraints([
            
            NSLayoutConstraint(item: mealImageView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -40)
            ])
        
        // MARK: Favorites Button Settings
        
        // Resize heart image to fit in button
        
        let size = CGSizeMake(30, 30)
        
        // heart image for favorite button
        var heartImage: UIImage = UIImage(named: "heart-outline")!
        heartImage = imageResize(image: heartImage, sizeChange: size)
        
        let addToFavoriteButton: ZFRippleButton = ZFRippleButton()
        
        addToFavoriteButton.frame = CGRect(x: 0, y: view.frame.height - (view.frame.height/10), width: view.frame.width, height: view.frame.height/10)
        addToFavoriteButton.backgroundColor = UIColor.peachColor()
        addToFavoriteButton.setTitle("  ADD TO FAVORITES", forState: .Normal)
        addToFavoriteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addToFavoriteButton.setImage(heartImage, forState: .Normal)
        addToFavoriteButton.titleLabel?.font = UIFont.LatoBigBold(15)
        addToFavoriteButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(addToFavoriteButton)
        
        // MARK: Meal Info Settings
        
        
        
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = UIColor.redColor()
        closeButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        mealImageView.addSubview(closeButton)
        mealImageView.addConstraints([
            NSLayoutConstraint(item: closeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: closeButton, attribute: .Right, relatedBy: .Equal, toItem: mealImageView, attribute: .Right, multiplier: 1.0, constant: -50),
            NSLayoutConstraint(item: closeButton, attribute: .Top, relatedBy: .Equal, toItem: mealImageView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: closeButton, attribute: .Bottom, relatedBy: .Equal, toItem: mealImageView, attribute: .CenterY, multiplier: 1.0, constant: -50)
            ])
        
    }

    
    
    // MARK: Back and Forward Buttons and Swipes Gestures
    
    let backButton: UIButton = UIButton()
    
    let forwardButton: UIButton = UIButton()
    
    let backSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    let forwardSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    func guideFunctions()
    {
        let size = CGSize(width: 40, height: 40)
        
        var back = UIImage(named: "arrow-back")
        back = imageResize(image: back!, sizeChange: size)
        
        var forward = UIImage(named: "arrow-forward")
        forward = imageResize(image: forward!, sizeChange: size)
        
        backButton.frame = CGRect(x: 5, y: infoView.frame.height/2, width: 30, height: 30)
        backButton.setImage(back, forState: .Normal)
        
        forwardButton.frame = CGRect(x: infoView.frame.width - (infoView.frame.width/10), y: infoView.frame.height/2, width: 30, height: 30)
        forwardButton.setImage(forward, forState: .Normal)
        
        infoView.addSubview(backButton)
        infoView.addSubview(forwardButton)
    }
    
    
    
    let effortLabel: UILabel = UILabel()
    let timerLabel: UILabel = UILabel()
    let numOfPersonLabel: UILabel = UILabel()
    
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
            NSLayoutConstraint(item: chefHat, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -35)
            ])
        
        
        effortLabel.font = UIFont.LatoLight(10)
        effortLabel.textColor = UIColor.blackColor()
        effortLabel.text = effort.getEffortInfo()
        effortLabel.translatesAutoresizingMaskIntoConstraints = false
        effortLabel.textAlignment = .Center
        infoView.addSubview(effortLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: effortLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: effortLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: effortLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 78),
            NSLayoutConstraint(item: effortLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
        let person: UIImageView = UIImageView()
        person.image = UIImage(named: "person")
        person.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(person)
        infoView.addConstraints([
            NSLayoutConstraint(item: person, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: person, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: person, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: person, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -35)
            ])
        
        numOfPersonLabel.font = UIFont.LatoLight(10)
        numOfPersonLabel.textColor = UIColor.blackColor()
        numOfPersonLabel.text = servingSize.getTitle()
        numOfPersonLabel.translatesAutoresizingMaskIntoConstraints = false
        numOfPersonLabel.textAlignment = .Center
        infoView.addSubview(numOfPersonLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        let timer: UIImageView = UIImageView()
        timer.image = UIImage(named: "stopwatch")
        timer.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(timer)
        infoView.addConstraints([
            NSLayoutConstraint(item: timer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: timer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: timer, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: -80),
            NSLayoutConstraint(item: timer, attribute: .CenterY, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -35)
            ])
        
        
        timerLabel.font = UIFont.LatoLight(10)
        timerLabel.textColor = UIColor.blackColor()
        timerLabel.text = time.getTitle()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .Center
        infoView.addSubview(timerLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: timerLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: timerLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: timerLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant:-80),
            NSLayoutConstraint(item: timerLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
    }
    
    
    
}

// MARK: FUCNTIONS TO RESIZE IMAGES FOR BUT

extension MealPreviewViewController
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


