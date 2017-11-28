//
//  MakeAMealController.swift
//  FUDI
//
//  Created by Devontae Reid on 12/22/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import MealFramework
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView
import BubbleTransition

class MakeAMealController: UITableViewController {

    var meals : [Meal] = [Meal]()
    var possibleMeals = [Meal]()
    
    let bubble = BubbleTransition()
    
    private var items: [Item] = []
    
    let actID = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var itemNames = [String]()
    var mealNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Make A Meal"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerClass(MakeAMealTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorColor = UIColor.peachColor()
        self.actIDSetup()
        self.getUserItemsFromDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func actIDSetup() {
        self.tableView.backgroundColor = UIColor.peachColor()
        actID.hidden = false
        actID.type = .BallPulseSync
        actID.center = view.center
        actID.startAnimation()
        actID.hidesWhenStopped = true
        view.addSubview(actID)
    }
    
    // MARK: Animation for the tableview
    private func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowAnimatedContent , animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    
//    // Retrieve Items from backend
//    func retrieveFromParse()
//    {
//        var itemTitle: [String] = []
//        var itemCategory: [String] = []
//        
//        let query = PFQuery(className: "CabinetItem")
//        query.whereKey("user", equalTo: PFUser.currentUser()!)
//        query.orderByAscending("name")
//        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            
//            self.meals = [Meal]()
//            
//            // Clear Arrays
//            self.meatArray = [Item]()
//            self.dairyArray = [Item]()
//            self.grainArray = [Item]()
//            self.fruitArray = [Item]()
//            self.vegeArray = [Item]()
//            
//            for object in objects!
//            {
//                itemTitle.append(object["name"] as! String)
//                itemCategory.append(object["Category"] as! String)
//            }
//            
//            // Loop thought array
//            for (var i = 0;i < itemTitle.count;i++)
//            {
//                // Sort Items in array
//                switch(itemCategory[i])
//                {
//                case "Beef","Poultry","Pork":
//                    self.meatArray.append(Item(name: itemTitle[i], category: itemCategory[i]))
//                case "Dairy":
//                    self.dairyArray.append(Item(name: itemTitle[i], category: itemCategory[i]))
//                case "Grains":
//                    self.grainArray.append(Item(name: itemTitle[i], category: itemCategory[i]))
//                case "Fruits":
//                    self.fruitArray.append(Item(name: itemTitle[i], category: itemCategory[i]))
//                case "Vegetables":
//                    self.vegeArray.append(Item(name: itemTitle[i], category: itemCategory[i]))
//                default:
//                    break
//                }
//            }
//            
//            
//            // Reload tableview
//            self.animateTable()
//        }
//        
//        
//    }


}

extension MakeAMealController: UIViewControllerTransitioningDelegate  {
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bubble.transitionMode = .Present
        bubble.startingPoint = tableView.center
        bubble.bubbleColor = tableView.backgroundColor!
        return bubble
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        bubble.transitionMode = .Dismiss
        bubble.startingPoint = tableView.center
        bubble.bubbleColor = tableView.backgroundColor!
        return bubble
    }
}


extension MakeAMealController {
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if possibleMeals.count == 0 {
            return 1
        }
        else {
            return possibleMeals.count
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MakeAMealTableViewCell
        cell.selectionStyle = .None
        
        
        // Configure the cell...
        if possibleMeals.count == 0 {
            cell.mealTitleView.text = "Don't have enough items in your Cabinet"
            
        }
        else {
            let meal = self.possibleMeals[indexPath.row]
            cell.mealTitleView.text = meal.name
            cell.servingSizeLabel.text = "Servings: \(meal.servingSize.getTitle())"
            cell.caloriesLabel.text = "Calories: \(Int(meal.calories.getCalories()))"
            cell.effortLabel.text = "Effort: \(meal.effort.getEffortInfo())"
            
            asyncLoadMealImage(meal, imageView: cell.backgroundViewForImage)
        
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if possibleMeals.count == 0 {
            
        }
        else {
            let meal = possibleMeals[indexPath.row]
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
            
            self.transitioningDelegate = self
            self.modalPresentationStyle = .Custom
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


// MARK: Database
extension MakeAMealController {
    
    // Get all meals from  backend
    
    // MARK: Meal
    // Meals from the backend
    func getAllMealsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/meal/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            // create a new instance of new meals
            var newMeals = [Meal]()
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                newMeals.append(Meal(snapshot: snap))
                
            }
            
            
            self.meals = newMeals
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
    
    // Get all user items from backend
    
    func getUserItemsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/User-Items/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            
            // Empty Arrays
            self.items = [Item]()
            
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                let data = snap.value as! [String : AnyObject]
                let uid = data["uid"] as! String
                if uid == userID {
                    self.itemNames.append(self.findUserItemStored(data))
                }
            }
            self.getAllMealsFromDatabase()
            self.getAllItemsFromDatabase()
            
        }
        
    }
    
    func findUserItemStored(data : [String : AnyObject]) -> String {
        return data["item-name"] as! String
    }
    
    
    // Item from the backend
    func getAllItemsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/item/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            // create a new instance of new meals
            var newItems = [Item]()
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                let data = snap.value as! [String : AnyObject]
                newItems.append(self.itemFromSnapshot(data))
                
            }
            
            for item in newItems {
                for name in self.itemNames {
                    if item.name == name {
                        self.items.append(item)
                    }
                }
            }// end items for loop
            
            self.makeAMeal(self.items)
            
        }
        
    }
    
    // MARK: Meal Components
    func itemFromSnapshot(data : [String : AnyObject]) -> Item
    {
        
        // Name
        let name = data["name"] as! String
        
        // Ingredients
        let category = data["category"] as! String
        
        return Item(name: name, category: category)
    }
    
    // Check to see what meals can be made with the items user has
    func makeAMeal(items:[Item]) {
        
        var numOfItems = 1
        
        // Look through items to see what items are there
        for meal in self.meals {
            for mealItem in meal.getMealItems() {
                for item in items {
                    if item.name == mealItem.name {
                        numOfItems++
                    }// end if
                }// end items for loop
            }// end meal items for loop
            
            // Check to see if meal has all the items
            if meal.getMealItems().count == numOfItems{
                self.possibleMeals.append(meal)
                numOfItems = 1
            }
        }
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        // Stop Animating
        self.actID.stopAnimation()
        self.actID.hidden = true
        
        self.tableView.reloadData()
    }
}
