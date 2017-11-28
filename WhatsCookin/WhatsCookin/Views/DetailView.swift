//
//  DetailView.swift
//  FUDI
//
//  Created by Devontae Reid on 11/10/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class DetailView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var scrollView: UIScrollView = UIScrollView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties for Details
    var mealImage: UIImage = UIImage(named: "dinner")!
    var mealText: String = "Dinner"
    var userImage: UIImage = UIImage(named: "Darnell")!
    var effortText: String = "Advanced"
    var numOfPerson: Int = 4
    var time: Int = 0
    
    var ingredients: String = ""
    var directions: String = ""

    private func setupView()
    {
        
        //scrollView = UIScrollView(frame: self.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        
        
        let mealImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height/3))
        mealImageView.backgroundColor = UIColor.skyBlueColor()
        mealImageView.image = mealImage
        scrollView.addSubview(mealImageView)
        

        
        let infoView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: self.frame.height/12))
        infoView.backgroundColor = UIColor.whiteColor()
        infoView.alpha = 0.9
        mealImageView.addSubview(infoView)
        
        let mealTitleLabel = UILabel(frame: CGRect(x: infoView.frame.width/4, y: infoView.frame.height/12, width: infoView.frame.width - 50, height: 20))
        mealTitleLabel.font = UIFont.LatoRegular(15)
        mealTitleLabel.textColor = UIColor.blackColor()
        mealTitleLabel.text = mealText
        infoView.addSubview(mealTitleLabel)
        
        var x: CGFloat = infoView.frame.width/4
        let y: CGFloat = infoView.frame.height/2
        let width: CGFloat = 50
        var imageX: CGFloat = 67
        
        
        let userImageView: UIImageView = UIImageView(frame: CGRect(x: 10, y: y - 5, width: 45, height: 45))
        userImageView.image = userImage
        userImageView.layer.cornerRadius = 22.5
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.clipsToBounds = true
        infoView.addSubview(userImageView)
        
        
        let effortImage: UIImageView = UIImageView(frame: CGRect(x: imageX, y: y + 5, width: 10, height: 10))
        effortImage.image = UIImage(named: "chefHat")
        infoView.addSubview(effortImage)
        imageX += width

        let effortLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: 20))
        effortLabel.font = UIFont.LatoLight(8)
        effortLabel.textColor = UIColor.blackColor()
        effortLabel.text = effortText
        infoView.addSubview(effortLabel)
        
        x += width
        
        let personImage: UIImageView = UIImageView(frame: CGRect(x: imageX, y: y + 3, width: 10, height: 15))
        personImage.image = UIImage(named: "person")
        infoView.addSubview(personImage)
        imageX += width
        
        let numOfPersonLabel = UILabel(frame: CGRect(x: x, y: infoView.frame.height/2, width: width, height: 20))
        numOfPersonLabel.font = UIFont.LatoLight(8)
        numOfPersonLabel.textColor = UIColor.blackColor()
        numOfPersonLabel.text = String(numOfPerson) + " person"
        infoView.addSubview(numOfPersonLabel)
        
        x += width
        
        let timerImage: UIImageView = UIImageView(frame: CGRect(x: imageX, y: y + 5, width: 10, height: 10))
        timerImage.image = UIImage(named: "stopwatch")
        infoView.addSubview(timerImage)
        
        let timeLimitLabel = UILabel(frame: CGRect(x: x, y: infoView.frame.height/2, width: width, height: 20))
        timeLimitLabel.font = UIFont.LatoLight(8)
        timeLimitLabel.textColor = UIColor.blackColor()
        timeLimitLabel.text = String(time) + " minutes"
        infoView.addSubview(timeLimitLabel)

        
        let timeline: TimelineView = TimelineView(bulletType: .Circle, timeFrames:
            [
                InfoSection(text: "INGREDIENTS",info:ingredients,image: UIImage(named: "cheese")),
                InfoSection(text: "DIRECTIONS", info:directions,image: UIImage(named: "list")),
                InfoSection(text: "STATISTICS",info:ingredients,image: UIImage(named: "stats")),
                InfoSection(text: "COMMENTS", info:directions,image: UIImage(named: "comments"))
        ])
        
//        let mealInfo: InfoOfMeal = InfoOfMeal(ingredients: ["1/3 cup of sugar\n1 cup of coconut milk\n2 scoops of choclate powder\n1 Teaspoon of vanilla abstract\n1/3 cup of sugar\n1 cup of coconut milk\n2 scoops of choclate powder\n1 Teaspoon of vanilla abstract\n1/3 cup of sugar\n1 cup of coconut milk\n2 scoops of choclate powder\n1 Teaspoon of vanilla abstract\n1/3 cup of sugar\n1 cup of coconut milk\n2 scoops of choclate powder\n1 Teaspoon of vanilla abstract"],directions: ["Set up ingredients to prepare meal","In a small bow, stir together soy sauce,brown sugar, and water, and vegetable oil untile sugar is dissolved.","Add the sugar. Make sure you don't a more sugar than need","Pour in milk", "Stir in mix","Serve to guess"])
//        timeline.mealInfo = mealInfo
      
        
        
        
        scrollView.addSubview(timeline)
        scrollView.addConstraints([
            NSLayoutConstraint(item: timeline, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: -80),
            NSLayoutConstraint(item: timeline, attribute: .Top, relatedBy: .Equal, toItem: mealImageView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
        
       // self.sendSubviewToBack(scrollView)
        
        
        
        
        let comments: CommentsTableView = CommentsTableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/2.2))
        comments.registerClass(CommentsTableViewCell.self, forCellReuseIdentifier: "commentCell")
        comments.delegate = self
        comments.dataSource = self
        timeline.commentView.addSubview(comments)
        
        let commentTextFieldBackground: UIView = UIView()
        commentTextFieldBackground.backgroundColor = UIColor.lightGrayColor()
        commentTextFieldBackground.translatesAutoresizingMaskIntoConstraints = false
        commentTextFieldBackground.sizeToFit()
        scrollView.addSubview(commentTextFieldBackground)
        scrollView.addConstraints([
            
            NSLayoutConstraint(item: commentTextFieldBackground, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: commentTextFieldBackground, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: commentTextFieldBackground, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: commentTextFieldBackground, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 60)
            ])
        
        let commentTextField: JOTextField = JOTextField()
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.font  = UIFont.LatoRegular(12)
        commentTextFieldBackground.addSubview(commentTextField)
        commentTextFieldBackground.addConstraints([
            
            NSLayoutConstraint(item: commentTextField, attribute: .Bottom, relatedBy: .Equal, toItem: commentTextFieldBackground, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: commentTextField, attribute: .Left, relatedBy: .Equal, toItem: commentTextFieldBackground, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: commentTextField, attribute: .Right, relatedBy: .Equal, toItem: commentTextFieldBackground, attribute: .Right, multiplier: 1.0, constant: -70),
            NSLayoutConstraint(item: commentTextField, attribute: .Top, relatedBy: .Equal, toItem: commentTextFieldBackground, attribute: .Top, multiplier: 1.0, constant: 15)
            ])
        
        let sendButton: ZFRippleButton = ZFRippleButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = UIColor.skyBlueColor()
        sendButton.setImage(UIImage(named: "comments"), forState: .Normal)
        commentTextFieldBackground.addSubview(sendButton)
        commentTextFieldBackground.addConstraints([
            
            NSLayoutConstraint(item: sendButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25),
            NSLayoutConstraint(item: sendButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25),
            NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: commentTextFieldBackground, attribute: .Right, multiplier: 1.0, constant: -30),
            NSLayoutConstraint(item: sendButton, attribute: .Top, relatedBy: .Equal, toItem: commentTextFieldBackground, attribute: .Top, multiplier: 1.0, constant: 20)
            ])
        
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.frame.height/8
    }
}
