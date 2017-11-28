//
//  FavoriteMealsTableViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 12/31/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MealFramework
import FoldingTabBar
import Firebase
import FirebaseDatabase

class FavoriteMealsTableViewController: UITableViewController , YALTabBarInteracting {
    
    
    // Arrays need to grab item from backend
    var meals = [Meal]()
    var mealNames = [String]()
    var mealIsFav = [Bool]()
    var mealKeys = [String]()
    
    // Favorite Info
    var favMealsName = [String]()
    var favoriteMeals = [Meal]()
    
    let actID = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorite Meals"
        self.tableView.separatorColor = UIColor.peachColor()
        self.tableView.backgroundColor = UIColor.peachColor()
        self.tableView.register(MakeAMealTableViewCell.self, forCellReuseIdentifier: "meal")
        self.actIDSetup()
        self.getUserMealsFromDatabase()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TAB BAR Interaction
    func extraLeftItemDidPress() {
        self.navigationController?.pushViewController(AllMealsViewController(), animated: true)
    }
    
    func actIDSetup() {
        actID.isHidden = false
        actID.type = ballPulseSyncBallPulseSync
        actID.center = view.center
        actID.startAnimating()
        actID.isHidden = true
        view.addSubview(actID)
    }
}

extension FavoriteMealsTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if favoriteMeals.count == 0
        {
            return 1
        }
        else
        {
            return favoriteMeals.count
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("meal", forIndexPath: indexPath) as! MakeAMealTableViewCell
        cell.selectionStyle = .None
        
        // Configure the cell...
        if favoriteMeals.count == 0
        {
            cell.mealTitleView.text = "You don't have any favorites yet!"
        }
        else
        {
            let meal = self.favoriteMeals[indexPath.row]
            cell.mealTitleView.text = meal.name
            cell.backgroundViewForImage.image = meal.image
            cell.servingSizeLabel.text = "Servings: \(meal.servingSize.getTitle())"
            cell.caloriesLabel.text = "Calories: \(meal.calories.getCalories())"
            cell.effortLabel.text = "Effort: \(meal.effort.getEffortInfo())"

            
            asyncLoadMealImage(meal, imageView: cell.backgroundViewForImage)

        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if favoriteMeals.count == 0 {
            
        }
        else {
            let meal = favoriteMeals[indexPath.row]
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
    
    func asyncLoadMealImage(meal: Meal, imageView: UIImageView) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            var image : UIImage?
            if meal.image != nil {
                image = meal.image
                imageView.image = image
            }
        }
    }
}


extension FavoriteMealsTableViewController {
    
    func checkIfMealIsFav(bool: Bool,name : String) -> String {
        var favMealName = String()
        
        if bool {
            favMealName = name
        }
        return favMealName
    }
    
    func getUserMealsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/Made-Meals/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            // Empty Meals
            self.meals = [Meal]()
            self.favoriteMeals = [Meal]()
            self.favMealsName = [String]()
            self.mealNames = [String]()
            self.mealIsFav = [Bool]()
            self.mealKeys = [String]()
            
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                let data = snap.value as! [String : AnyObject]
                let uid = data["uid"] as! String
                if uid == userID {
                    self.meals.append(Meal(snapshot: snap))
                }
            }
            
            for meal in self.meals {
                if meal.isFav == true {
                    self.favoriteMeals.append(meal)
                }
            }
        
            self.tableView.backgroundColor = UIColor.whiteColor()
            
            // Stop Animating
            self.actID.stopAnimation()
            self.actID.hidden = true
            
            self.tableView.reloadData()
        }
        
    }
    
    func findMadeMealsByUser(data : [String : AnyObject]) -> String {
        return data["meal-name"] as! String
    }
    
    func getDateOfMeals(data: [String : AnyObject]) -> String {
        let dateString = data["date"] as! String
        print(dateString)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, H:mm a"
        let date = dateFormatter.dateFromString(dateString)
        
        let newDate = NSDateFormatter.localizedStringFromDate(date!, dateStyle: .MediumStyle, timeStyle: .NoStyle)
        return newDate
    }
    
    func getMealFavInfo(data: [String : AnyObject]) -> Bool {
        return data["isFav"] as! Bool
    }
    
    // Meals from the backend
    func getAllMealsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/meal/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                let data = snap.value as! [String : AnyObject]
                self.meals.append(self.mealFromSnapshot(data))
                
            }
            
            
            for meal in self.meals {
                for name in self.favMealsName {
                    if meal.name == name {
                        self.favoriteMeals.append(meal)
                    }
                }
            }
            
//            for i in 0...self.favoriteMeals.count {
//                self.favoriteMeals[i].key = self.mealKeys[i]
//            }

            self.tableView.backgroundColor = UIColor.whiteColor()
            
            // Stop Animating
            self.actID.stopAnimation()
            self.actID.hidden = true
            
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: Meal Components
    func mealFromSnapshot(data : [String : AnyObject]) -> Meal
    {
        
        // Name
        let name = data["name"] as! String
        
        // Ingredients
        let ingredients = self.getIngredients(data)
        
        // Directions
        let directions = self.getDirections(data)
        
        // Calories
        let calories = self.getCalories(data)
        
        // Effort
        let newEffort = self.getEffort(data)
        
        // Serving Size
        let servingSize = self.getServingSize(data)
        
        // Website data
        let website = self.getWebsite(data)
        
        
        var meal: Meal?
        meal = Meal(name: name, ingredients: ingredients, directions: directions, calories: calories, effort: newEffort, size: servingSize, website: website)
        
        return meal!
    }
    
    
    private func getIngredients(data: [String : AnyObject]) -> Ingredients
    {
        let info = data["ingredients"] as! [String : AnyObject]
        let ingredients = info["ingredients"] as! [String]
        let newIngred = Ingredients(ingredientList: ingredients)
        
        return newIngred
    }
    
    private func getDirections(data: [String : AnyObject]) -> [Direction]
    {
        var directions: [Direction] = []
        
        let directs = data["directions"] as! NSArray
        
        for d in directs
        {
            let items = d as! [String : AnyObject]
            let info = items["info"] as! String
            let time = items["time"] as! [String : AnyObject]
            let totalMins = time["totalMin"] as! Int
            directions.append(Direction(directionInfo: info, directionTime: Time(minutes: totalMins)))
        }
        
        return directions
    }
    
    private func getCalories(data: [String: AnyObject]) -> Calories
    {
        
        let info = data["calories"] as! [String : AnyObject]
        let carbs = info["carbs"] as! CGFloat
        let fat = info["fat"] as! CGFloat
        let protein = info["protein"] as! CGFloat
        
        let calories = Calories(protein: protein, carbs: carbs, fat: fat)
        return calories
    }
    
    private func getEffort(data: [String : AnyObject]) -> Effort
    {
        
        // Effort
        let effortData = data["effort"] as! [String : AnyObject]
        let ef = effortData["effort"] as! String
        
        let effort: Effort!
        
        switch (ef)
        {
        case "Easy":
            effort = Effort(effort: EffortCategory.Easy)
            break
        case "Moderate":
            effort = Effort(effort: EffortCategory.Moderate)
            break
        case "Advanced":
            effort = Effort(effort: EffortCategory.Advanced)
            break
        default:
            effort = nil
            break
        }
        return effort
    }
    
    private func getServingSize(data: [String : AnyObject]) -> ServingSize {
        let info = data["servingSize"] as! [String : AnyObject]
        let size =  info["size"] as! Int
        
        let servingSize = ServingSize(size: size)
        return servingSize
    }
    
    private func getWebsite(data: [String : AnyObject]) -> Website {
        let info = data["website"] as? [String : AnyObject]
        let urlString = info!["uri"] as! String
        let websiteTitle = info!["titleOfWebsite"] as! String
        let url = NSURL(string: urlString)
        
        
        let website = Website(url: url!, websiteTitle: websiteTitle)
        return website
    }
}
