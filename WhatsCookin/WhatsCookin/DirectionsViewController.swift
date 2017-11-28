//
//  ViewController.swift
//  Practice
//
//  Created by Devontae Reid on 6/2/16.
//  Copyright © 2016 SoloStack. All rights reserved.
//

import UIKit
import MealFramework
import FoldingTabBar
import FirebaseDatabase
import Firebase

var userMeals = [Meal]()

class DirectionsViewController: AccordionViewController {

    var stringIngredients : String!
    var meal : Meal!
    var timer = NSTimer()
    var totalMinutes = 0
    var secs = 0
    var finished = false
    var step = 1
    var timeElapsed = 0
    
    let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/Made-Meals")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Setup: Such as background color and setting up tableView
        self.view.backgroundColor = UIColor.peachColor(0.8)
        self.tableView.registerClass(DirectionCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .Done, target: self, action: "finishedCookingMeal")

        
        // Open Ingredients Cell
        self.expandCell(0)
        
        
        // Set up directions for tableview
        self.meal = Meal(name: mealTitle, ingredients: ingredients, directions: directions, calories: calories, effort: effort, size: servingSize, website: Website(url: mealWebsiteURL, websiteTitle: mealWebsiteTitle))
        self.meal.key = mealKey
        self.stringIngredients = concatArrayOfIngredients(ingredients)
        
        // Set the total mins and sec to the first time in array
        totalMinutes = meal.directions[step].getDirectionTime().getTotalMin()
        secs = secsConverter(totalMinutes)
        
        // Expand the first cell at start
        self.expandCell(step)
        self.startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Helpers
    
    func expandCell(index: Int) {
        finished = false
        let cellIndexPath = NSIndexPath(forRow: index, inSection: 0)
        expandedIndexPaths.append(cellIndexPath)
    }
    
    
    // Function to add an alert when finished
    private func displayAlert(title: String,message: String)
    {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController
        
        let alert = JSSAlertView()
        alert.success(
            rootViewController!,
            title: title,
            text: message
        )
        
        alert.addAction { () -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    // Add ingredients to string so that it could be added to first cell of tableview
    func concatArrayOfIngredients(ingredients: Ingredients) -> String {
        var stringOfIngredients = ""
        for i in ingredients.getIngredientList() {
            stringOfIngredients += "\(i) \n"
        }
        return stringOfIngredients
    }
    
    func addMealPost(date:String,var numOfTimes:Int,key:String) {
        // Increment num of times made
        numOfTimes++
        var directionList = [String]()
        var directionsTimes = [Int]()
        for direction in directions {
            directionList.append(direction.getDirectionInfo())
            directionsTimes.append(direction.getDirectionTime().getTotalMin())
        }
        
        let mealPost: [String : AnyObject] = [
            "username" : userName,
            "uid" : userID,
            "date" : date,
            "meal-name" : mealTitle,
            "ingredients" : ingredients.getIngredientList() as NSArray,
            "directions" : ["info" : directionList as NSArray, "time" : directionsTimes as NSArray],
            "size" : servingSize.getSize(),
            "effort" : effort.getEffortInfo(),
            "time" : time.getTotalMin(),
            "carbs" : calories.getCarbs(),
            "fat" : calories.getFat(),
            "protein" : calories.getProtein(),
            "isFav" : false,
            "numOfTimes" : numOfTimes,
            "website" : ["url": mealWebsiteURL.absoluteString, "title" : mealWebsiteTitle]
        ]
        
        ref.child(key).updateChildValues(mealPost)

    }
    
    func updateMealPost(date: String,var numOfTimes: Int,favorite: Bool,key: String) {
        // Increment num of times made
        numOfTimes++
        
        var directionList = [String]()
        var directionsTimes = [Int]()
        for direction in directions {
            directionList.append(direction.getDirectionInfo())
            directionsTimes.append(direction.getDirectionTime().getTotalMin())
        }
        
        let mealPost: [String : AnyObject] = [
            "username" : userName,
            "uid" : userID,
            "date" : date,
            "meal-name" : mealTitle,
            "ingredients" : ingredients.getIngredientList() as NSArray,
            "directions" : ["info" : directionList as NSArray, "time" : directionsTimes as NSArray],
            "size" : servingSize.getSize(),
            "effort" : effort.getEffortInfo(),
            "time" : time.getTotalMin(),
            "carbs" : calories.getCarbs(),
            "fat" : calories.getFat(),
            "protein" : calories.getProtein(),
            "isFav" : favorite,
            "numOfTimes" : numOfTimes,
            "website" : ["url": mealWebsiteURL.absoluteString, "title" : mealWebsiteTitle]
        ]
        ref.child(key).updateChildValues(mealPost)
    }
    
    
    func finishedCookingMeal() {
        
        // MARK : Date
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter.localizedStringFromDate(currentDate, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let date : String = dateFormatter
        
        
        timer.invalidate()
        
        // Validation Propeties
        var valid = false
        var index = 0
        
        // Search through meals made by user to see if it was made before
        for meal in userMeals {
            // If a meal was made already give meal the update properies and validate
            if self.meal.name == meal.name || self.meal.key == meal.key {
                valid = true
                self.meal.key = meal.key
                self.meal.isFav = meal.isFav
                self.meal.numOfTime = meal.numOfTime
                break
            } else {
                valid = false
            }
            index++
        }
        
        // Display a message prompting the user that there meal is finished
        self.displayAlert("Congratulations", message: "You have finished your meal!")
        // Send to the backend
        
        if !valid {
            self.addMealPost(date, numOfTimes: numOfTimes, key: ref.childByAutoId().key)
        } else {
            self.updateMealPost(date, numOfTimes: self.meal.numOfTime, favorite: self.meal.isFav, key: self.meal.key)
        }
    }
    
    
    
    // MARK: Tableview Delegate and Database
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DirectionCell
        
        if indexPath.row < 1 {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.headerView.stepLabel.text = "Ingredients"
            cell.directionView.detailView.text = stringIngredients
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.headerView.stepLabel.text = "Step \(indexPath.row)"
            cell.directionView.detailView.text = meal.directions[indexPath.row - 1].getDirectionInfo()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meal.directions.count + 1
    }

    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let expand : CGFloat = expandedIndexPaths.contains(indexPath) ? 180.0 : 50.0
        
        return expand
    }
    

}


// MARK: Timer Setup
extension DirectionsViewController {
    // Create a timer for each direction
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    // Timer action
    func updateTimer() {
        //Create a cell
        let cellIndexPath = NSIndexPath(forRow: step, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(cellIndexPath) as! DirectionCell
        cell.headerView.timerLabel.hidden = false
        cell.headerView.timerLabel.text = self.timeOuput(secs)
        secs -= 1
        if secs < 1
        {
            cell.headerView.timerLabel.hidden = true
            // Stop Timer
            timer.invalidate()
            
            // Close the previous step
            closeOpen(finished, index: step)
            finished = true
            
            // Open the next step
            if step < directions.count {
                step++
                closeOpen(finished, index: step)
                finished = false
                if step == directions.count {
                    self.finishedCookingMeal()
                }
            }
        }
    }
    
    func closeOpen(isOpen: Bool,index:Int) {
        // Make sure you don't excede the array
        if index <= directions.count  {
            
            //Create a cell
            let cellIndexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(cellIndexPath) as! DirectionCell
            
            // Check if the cell is open
            if !isOpen {
                toggleCell(cell, animated: true)
            } else {
                toggleCell(cell, animated: true)
                totalMinutes = directions[cellIndexPath.row].getDirectionTime().getTotalMin()
                secs = secsConverter(totalMinutes)
                self.startTimer()
            }
        }
    }
    
    // Convert mins tp secs
    func secsConverter(mins: Int) -> Int {
        let secs: Int = mins * 60
        return secs
    }
    
    func timeOuput(secs:Int) -> String {
        var output = ""
        var seconds = secs
        
        if (seconds > 3600) {
            let hour = seconds / 3600
            seconds -= hour * 3600
            let minute = seconds / 60
            seconds -= minute * 60
            if hour == 0 && minute == 0 {
                output = String(format: ":%02d", seconds)
            } else {
                output = String(format: "%02d:%02d:%02d", arguments: [hour,minute,seconds])
            }
        } else {
            let minute = seconds / 60
            seconds -= minute * 60
            if minute == 0 {
                output = String(format: ":%02d", seconds)
            } else {
                output = String(format: "%02d:%02d", arguments: [minute,seconds])
            }
        }
        
        return output
    }
    
}

