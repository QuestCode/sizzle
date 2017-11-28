//
//  DetailViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 11/15/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import MealFramework

// Global Variables
var directions: [Direction] = [Direction]()
var ingredients: Ingredients = Ingredients(ingredientList: [])
var mealWebsiteURL = NSURL()
var mealWebsiteTitle = ""
var mealTitle = ""
var mealImage = UIImage()
var time = Time(minutes: 0)
var servingSize = ServingSize(size: 0)
var effort = Effort(effort: .Easy)
var calories = Calories(protein: 0, carbs: 0, fat: 0)
var mealKey = ""
var toAnyObject: AnyObject!
var numOfTimes = 0
var mealFav = false


class DetailViewController: UIViewController {
    
    // Propeties
    private var scrollView: UIScrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(scrollView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MAM", style: .Done, target: self, action: "makeThisMeal")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       self.setupView()
    }
    
    var mealImageView: UIImageView = UIImageView()
    var mealTitleLabel: UILabel = UILabel()
    var userImageView: UIImageView = UIImageView()

    // Direction and Ingredient Propeties
    private let directionsText: String = "Directions"
    private let ingredientsText: String = "Ingredients"
    
    private func setupView()
    {
        
        //scrollView = UIScrollView(frame: self.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        self.view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
        let imageContainer: UIView = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageContainer)
        scrollView.addConstraints([
            NSLayoutConstraint(item: imageContainer, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: imageContainer, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: imageContainer, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: imageContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 180)
            ])
        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.image = mealImage
        mealImageView.backgroundColor = UIColor.skyBlueColor()
        imageContainer.addSubview(mealImageView)
        imageContainer.addConstraints([
            NSLayoutConstraint(item: mealImageView, attribute: .Top, relatedBy: .Equal, toItem: imageContainer, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Left, relatedBy: .Equal, toItem: imageContainer, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Right, relatedBy: .Equal, toItem: imageContainer, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealImageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageContainer, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
        let infoView: UIView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = UIColor.whiteColor()
        infoView.alpha = 0.9
        imageContainer.addSubview(infoView)
        imageContainer.addConstraints([
            NSLayoutConstraint(item: infoView, attribute: .Top, relatedBy: .Equal, toItem: imageContainer, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Left, relatedBy: .Equal, toItem: imageContainer, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Right, relatedBy: .Equal, toItem: imageContainer, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .Bottom, relatedBy: .Equal, toItem: imageContainer, attribute: .CenterY, multiplier: 1.0, constant: -40)
            ])
        
    
        mealTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mealTitleLabel.text = mealTitle
        mealTitleLabel.font = UIFont.LatoRegular(15)
        mealTitleLabel.textColor = UIColor.blackColor()
        mealTitleLabel.textAlignment = .Center
        infoView.addSubview(mealTitleLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: mealTitleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mealTitleLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 300),
            NSLayoutConstraint(item: mealTitleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 0)
            ])

        let width: CGFloat = 100
        
        let effortImage: UIImageView = UIImageView()
        effortImage.translatesAutoresizingMaskIntoConstraints = false
        effortImage.image = UIImage(named: "chefHat")
        infoView.addSubview(effortImage)
        infoView.addConstraints([
            NSLayoutConstraint(item: effortImage, attribute: .Left, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 55),
            NSLayoutConstraint(item: effortImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: effortImage, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -3),
            NSLayoutConstraint(item: effortImage, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 5)
            ])
        
        
        let effortLabel = UILabel()
        effortLabel.translatesAutoresizingMaskIntoConstraints = false
        effortLabel.font = UIFont.LatoRegular(12)
        effortLabel.textColor = UIColor.blackColor()
        effortLabel.textAlignment = .Center
        effortLabel.text = effort.getEffortInfo()
        infoView.addSubview(effortLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: effortLabel, attribute: .Left, relatedBy: .Equal, toItem: infoView, attribute: .Left, multiplier: 1.0, constant: 45),
            NSLayoutConstraint(item: effortLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: effortLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: effortLabel, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 5)
            ])
        
        
        
        let personImage: UIImageView = UIImageView()
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.image = UIImage(named: "person")
        infoView.addSubview(personImage)
        infoView.addConstraints([
            NSLayoutConstraint(item: personImage, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: -30),
            NSLayoutConstraint(item: personImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: personImage, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: personImage, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 4)
            ])
        
        
        let numOfPersonLabel = UILabel()
        numOfPersonLabel.translatesAutoresizingMaskIntoConstraints = false
        numOfPersonLabel.font = UIFont.LatoRegular(12)
        numOfPersonLabel.textColor = UIColor.blackColor()
        numOfPersonLabel.textAlignment = .Center
        numOfPersonLabel.text = servingSize.getTitle()
        infoView.addSubview(numOfPersonLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .CenterX, relatedBy: .Equal, toItem: infoView, attribute: .CenterX, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: numOfPersonLabel, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 5)
            ])
        
        
        let timerImage: UIImageView = UIImageView()
        timerImage.translatesAutoresizingMaskIntoConstraints = false
        timerImage.image = UIImage(named: "stopwatch")
        infoView.addSubview(timerImage)
        infoView.addConstraints([
            NSLayoutConstraint(item: timerImage, attribute: .Right, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: -110),
            NSLayoutConstraint(item: timerImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 15),
            NSLayoutConstraint(item: timerImage, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: -3),
            NSLayoutConstraint(item: timerImage, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 5)
            ])
        
        let timeLimitLabel = UILabel()
        timeLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLimitLabel.font = UIFont.LatoRegular(12)
        timeLimitLabel.textColor = UIColor.blackColor()
        timeLimitLabel.textAlignment = .Center
        timeLimitLabel.text = time.getTitle()
        infoView.addSubview(timeLimitLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: timeLimitLabel, attribute: .Right, relatedBy: .Equal, toItem: infoView, attribute: .Right, multiplier: 1.0, constant: -45),
            NSLayoutConstraint(item: timeLimitLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: timeLimitLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeLimitLabel, attribute: .Top, relatedBy: .Equal, toItem: infoView, attribute: .CenterY, multiplier: 1.0, constant: 5)
            ])
        
        let websiteTitle = UILabel()
        websiteTitle.translatesAutoresizingMaskIntoConstraints = false
        websiteTitle.textAlignment = .Center
        websiteTitle.backgroundColor = UIColor.whiteColor()
        websiteTitle.alpha = 0.8
        websiteTitle.font = UIFont.LatoRegular(10)
        websiteTitle.text = "Website: \(mealWebsiteTitle)"
        imageContainer.addSubview(websiteTitle)
        imageContainer.addConstraints([
            NSLayoutConstraint(item: websiteTitle, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: websiteTitle, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 120),
            NSLayoutConstraint(item: websiteTitle, attribute: .Right, relatedBy: .Equal, toItem: imageContainer, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: websiteTitle, attribute: .Bottom, relatedBy: .Equal, toItem: imageContainer, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])

        
        // MARK: Just in case I want to go directly to the website
//        let websiteButton = UIButton()
//        websiteButton.addTarget(self, action: "mealButton", forControlEvents: .TouchUpInside)
//        websiteButton.translatesAutoresizingMaskIntoConstraints = false
//        imageContainer.addSubview(websiteButton)
//        imageContainer.addConstraints([
//            NSLayoutConstraint(item: websiteButton, attribute: .Top, relatedBy: .Equal, toItem: imageContainer, attribute: .Top, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: websiteButton, attribute: .Left, relatedBy: .Equal, toItem: imageContainer, attribute: .Left, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: websiteButton, attribute: .Right, relatedBy: .Equal, toItem: imageContainer, attribute: .Right, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: websiteButton, attribute: .Bottom, relatedBy: .Equal, toItem: imageContainer, attribute: .Bottom, multiplier: 1.0, constant: 0)
//            ])
        
        // MARK Timeline View
        let timeline: TimelineView = TimelineView(bulletType: BulletType.Circle, timeFrames:
            [
                InfoSection(text: "INGREDIENTS",info:ingredientsText,image: UIImage(named: "cheese")),
                InfoSection(text: "DIRECTIONS", info:directionsText,image: UIImage(named: "list")),
                InfoSection(text: "STATISTICS",info:ingredientsText,image: UIImage(named: "stats")),
                //InfoSection(text: "COMMENTS", info:directionsText,image: UIImage(named: "comments"))
            ])
        
        
        // For storing ingredients and direction to the proper array
        let mealInfo: InfoOfMeal = InfoOfMeal(ingredients: ingredients,directions: directions)
        timeline.mealInfo = mealInfo
        
        // For the meal attribute
        let mealAttributes : MealAttributes = MealAttributes(carbs: Double(calories.getCarbs()), protein: Double(calories.getProtein()), fat: Double(calories.getFat()))
        timeline.mealAttributes = mealAttributes
        
        
        scrollView.addSubview(timeline)
        scrollView.addConstraints([
            NSLayoutConstraint(item: timeline, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: -60),
            NSLayoutConstraint(item: timeline, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 170),
            NSLayoutConstraint(item: timeline, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
        
        // self.sendSubviewToBack(scrollView)
        
        
    }
    
    func makeThisMeal() {
        
        let dVC = DirectionsViewController()
        dVC.image = mealImageView.image!
        
        self.navigationController?.pushViewController(dVC, animated: true)
    }
    
    
    // If I want to go directly to the website
    func mealButton() {
        
//        let webVC = WebsiteViewController()
//        webVC.website = mealWebsite
//
//        self.navigationController?.pushViewController(webVC, animated: true)
        
    }

}
