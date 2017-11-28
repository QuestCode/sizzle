//
//  AllMealsViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 1/21/16.
//  Copyright © 2016 Devontae Reid. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import HMSegmentedControl
import MealFramework
import Firebase
import FirebaseDatabase

class AllMealsViewController: UIViewController {
    
    var tableView: UITableView = UITableView()
    
    var fruitMeals = [Meal]()
    var vegeMeals = [Meal]()
    var meatMeals = [Meal]()
    var grainMeals = [Meal]()
    var allMeals = [Meal]()
    
    var meals = [Meal]()
    
    
    
    let actID = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.peachColor()
        self.actIDSetup()
        self.segmentControllerSetup()
        self.tableViewSettings()
        self.getFromDatabase()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actIDSetup() {
        actID.hidden = false
        actID.type = .BallPulseSync
        actID.center = view.center
        actID.startAnimation()
        actID.hidesWhenStopped = true
        view.addSubview(actID)
    }
    
    
    func segmentControllerSetup()
    {
        let items = ["All Meals","Fruit Meals","Vege Meals","Meat Meals","Grain Meals"]
        let segment: HMSegmentedControl = HMSegmentedControl(sectionTitles: items)
        segment.selectionIndicatorColor = UIColor.peachColor()
        segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        let titleDict = [NSFontAttributeName: UIFont.LatoRegular(20)]
        
        segment.titleTextAttributes = titleDict
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: "changeMeals:", forControlEvents: UIControlEvents.ValueChanged)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        self.view.addConstraints([
            NSLayoutConstraint(item: segment, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 64),
            NSLayoutConstraint(item: segment, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: segment, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: segment, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 41)
            
            ])
        
        
    }
    
    func changeMeals(sender: UISegmentedControl)
    {
        meals = [Meal]()
        switch (sender.selectedSegmentIndex)
        {
        case 0:
            meals = allMeals
        case 1:
            // Fruit Segment
            meals = fruitMeals
        case 2:
            // Vege Segment
            meals = vegeMeals
        case 3:
            // Grab all meals that include meat
            meals = meatMeals
        case 4:
            // Grain Meals Segment
            meals = grainMeals
        default:
            break
        }
        
        self.tableView.reloadData()
        
    }

}


extension AllMealsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableViewSettings() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = UIColor.peachColor()
        tableView.backgroundColor = UIColor.peachColor()
        tableView.registerClass(MakeAMealTableViewCell.self, forCellReuseIdentifier: "meal")
        view.addSubview(tableView)
        view.addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 105),
            NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if meals.count == 0 {
            return 1
        } else {
            return meals.count
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("meal", forIndexPath: indexPath) as! MakeAMealTableViewCell
        cell.selectionStyle = .None
        
        // Configure the cell...
        if meals.count == 0 {
            cell.mealTitleView.text = "Woah there is a problem! There is suppose to be meals here! Let me check."
            cell.backgroundViewForImage.image = UIImage()
            cell.servingSizeLabel.text = ""
            cell.caloriesLabel.text = ""
            cell.effortLabel.text = ""
        } else {
            let meal = self.meals[indexPath.row]
            cell.mealTitleView.text = meal.name
            cell.backgroundViewForImage.image = meal.image
            cell.servingSizeLabel.text = "Servings: \(meal.servingSize.getTitle())"
            cell.caloriesLabel.text = "Calories: \(meal.calories.getCalories())"
            cell.effortLabel.text = "Effort: \(meal.effort.getEffortInfo())"
            
            asyncLoadMealImage(meal, imageView: cell.backgroundViewForImage)

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if meals.count == 0 {
            
        } else {
            let meal = meals[indexPath.row]
            mealTitle = meal.name
            mealImage = meal.image
            mealWebsiteURL = meal.website.getURL()
            mealWebsiteTitle = meal.website.getTitleOfWebsite()
            ingredients = meal.ingredients
            directions = meal.directions
            time = meal.getTotalTime()
            effort = meal.effort
            servingSize = meal.servingSize
            calories = meal.calories
            mealKey = meal.key
            toAnyObject = meal.toAnyObject()
            numOfTimes = meal.numOfTime
            mealFav = meal.isFav
            
            self.navigationController?.pushViewController(DetailViewController(), animated: true)
        }
        
        
    }
    
    
    func asyncLoadMealImage(meal: Meal, imageView: UIImageView)
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            var image : UIImage?
            if meal.image != nil {
                image = meal.image
                imageView.image = image
            }
        }
    }

}

extension AllMealsViewController {
    func getFromDatabase() {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/meal/")
            
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            self.meals = [Meal]()
            self.fruitMeals = [Meal]()
            self.vegeMeals = [Meal]()
            self.meatMeals = [Meal]()
            self.grainMeals = [Meal]()
            self.allMeals = [Meal]()
            var newMeals = [Meal]()
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                newMeals.append(Meal(snapshot: snap))
     
            }
            
            
            // Add meals to array
            self.allMeals = newMeals
            self.categorySort(self.allMeals)
            
            // Stop Animating
            self.actID.stopAnimation()
            self.actID.hidden = true
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: Sort Meals by Name & Category
    
    private func sortByName(meals:[Meal]) -> [Meal]{
        var newMeals: [Meal] = meals
        
        newMeals.sortInPlace({$0.name < $1.name})
        return newMeals
    }
    
    private func categorySort(meals:[Meal])
    {   self.meals = meals
        self.fruitMeals = sortByItems(meals, category: "Fruit")
        self.vegeMeals = sortByItems(meals, category: "Vegetable")
        self.meatMeals = containsMeat(meals)
        self.grainMeals = containsGrain(meals)
    }
    
    private func sortByItems(meals:[Meal],category: String) -> [Meal] {
        var newMeals: [Meal] = [Meal]()
        
        for meal in meals {
            if(checkItemInMeal(meal) == category) {
                newMeals.append(meal)
            }
        }
        return newMeals
    }
    
    private func checkItemInMeal(meal:Meal) -> String {
        var fruitNum = 0
        var vegNum = 0
        var grainNum = 0
        var meatNum = 0
        var dairyNum = 0
        
        var category: String = ""
        
        for item in meal.getMealItems() {
            switch(item.category.lowercaseString) {
                case "Dairy".lowercaseString:
                    dairyNum += 1
                case "Fruit".lowercaseString:
                    fruitNum += 1
                case "Vegetable".lowercaseString:
                    vegNum += 1
                case "Beef".lowercaseString,"Pork".lowercaseString,"Poultry".lowercaseString:
                    meatNum += 1
                case "Grain".lowercaseString:
                    grainNum += 1
                default:
                    break
            }// End Switch
        }// End Item loop
        
        var maxNum = 0
        
        if (dairyNum > maxNum) {
            maxNum = dairyNum
            category = "Dairy"
        }
        else if (fruitNum > maxNum) {
            maxNum = fruitNum
            category = "Fruit"
        }
        else if (vegNum > maxNum) {
            maxNum = vegNum
            category = "Vegetable"
        }
        else if (meatNum > maxNum) {
            maxNum = meatNum
            category = "Meat"
        }
        else if (grainNum > maxNum) {
            maxNum = grainNum
            category = "Grain"
        }
        else {
            maxNum = 0
            category = ""
        }
        
        return category
    }
    
    private func containsMeat(meals: [Meal]) -> [Meal] {
        var newMeals: [Meal] = [Meal]()
        
        for meal in meals {
            for item in meal.getMealItems() {
                if(item.category == "Beef" || item.category == "Pork" || item.category == "Poultry") {
                    newMeals.append(meal)
                }// End condition
            }// End item loop
        }// End meal loop
        
        newMeals = checkIfMeal(newMeals)
        
        return newMeals
    }
    
    // Check to see if meal is made more than once
    func checkIfMeal(meals: [Meal]) -> [Meal] {
        var newMeals = [Meal]()
        var counts = [String : Int]()
        
        for meal in meals {
            counts[meal.name] = (counts[meal.name] ?? 0) + 1
        }// End For
        
        for (key, _) in counts {
            newMeals.append(Meal(name: key, ingredients: Ingredients(ingredientList: []), directions: [Direction](), calories: Calories(protein: 0, carbs: 0, fat: 0), effort: Effort(effort: .Easy), size: ServingSize(size: 0), website: Website(url: NSURL(), websiteTitle: "")))
        }
        
        for meal in meals {
            for newMeal in newMeals {
                if meal.name == newMeal.name {
                    newMeal.ingredients = meal.ingredients
                    newMeal.items = meal.items
                    newMeal.directions = meal.directions
                    newMeal.calories = meal.calories
                    newMeal.effort = meal.effort
                    newMeal.servingSize = meal.servingSize
                    newMeal.website = meal.website
                    newMeal.time = meal.time
                    newMeal.date = meal.date
                }
            }
        }
        
        return newMeals
    }
    
    private func containsGrain(meals: [Meal]) -> [Meal] {
        var newMeals: [Meal] = [Meal]()
        
        for meal in meals {
            for item in meal.getMealItems()
            {
                if(item.category == "Grain")
                {
                    newMeals.append(meal)
                }// End condition
            }// End item loop
        }// End meal loop
        
        newMeals = checkIfMeal(newMeals)
        
        return newMeals
    }
}