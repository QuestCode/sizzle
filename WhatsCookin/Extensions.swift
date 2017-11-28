//
//  Extensions.swift
//  FUDI
//
//  Created by Devontae Reid on 12/31/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import MealFramework
import Firebase
import FirebaseDatabase

// MARK: Fonts
extension UIFont {
    class func LatoRegular(fontSize:CGFloat) ->UIFont
    {
        let font: UIFont = UIFont(name: "Lato-Regular", size: fontSize)!
        
        return font
    }
    
    class func LatoLight(fontSize: CGFloat) -> UIFont
    {
        let font: UIFont = UIFont(name: "Lato-Light", size: fontSize)!
        
        return font
    }
    
    class func LatoBold(fontSize: CGFloat) -> UIFont
    {
        let font: UIFont = UIFont(name: "Lato-Bold", size: fontSize)!
        
        return font
    }
    
    class func LatoBigBold(fontSize: CGFloat) -> UIFont
    {
        let font: UIFont = UIFont(name: "Lato-Black", size: fontSize)!
        
        return font
    }
}


// MARK: Colors

extension UIColor {
    class func freshEggplant() -> UIColor
    {
        let color: UIColor = UIColor(red: 158/255, green: 0/255, blue: 68/255, alpha: 1.0)
        
        return color
    }
    
    class func freshEggplant(alpha: CGFloat) -> UIColor
    {
        let color: UIColor = UIColor(red: 159/255, green: 0/255, blue: 68/255, alpha: alpha)
        
        return color
    }
    
    class func deepPink() -> UIColor
    {
        let color: UIColor = UIColor(red: 214/255, green: 147/255, blue: 189/255, alpha: 1.0)
        
        return color
    }
    
    class func deepPink(alpha: CGFloat) -> UIColor
    {
        let color: UIColor = UIColor(red: 214/255, green: 147/255, blue: 189/255, alpha: alpha)
        
        return color
    }
    
    class func magenta() -> UIColor
    {
        let color: UIColor = UIColor(red: 239/255, green: 211/255, blue: 231/255, alpha: 1.0)
        
        return color
    }
    
    class func magenta(alpha: CGFloat) -> UIColor
    {
        let color: UIColor = UIColor(red: 239/255, green: 211/255, blue: 231/255, alpha: alpha)
        
        return color
    }
    
    class func peachColor() -> UIColor
    {
        let color: UIColor = UIColor(red: 245/255, green: 115/255, blue: 101/255, alpha: 1.0)
        
        return color
    }
    
    class func peachColor(alpha: CGFloat) -> UIColor
    {
        let color: UIColor = UIColor(red: 245/255, green: 115/255, blue: 101/255, alpha: alpha)
        
        return color
    }
    
    class func skyBlueColor() -> UIColor
    {
        let color: UIColor = UIColor(red: 19/255, green: 148/255, blue: 223/255, alpha: 1.0)
        
        return color
    }
    
   
}

//MARK : UIImage

extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

// MARK : Meal 
extension Meal {
    public convenience init(snapshot: FIRDataSnapshot) {
        
        self.init (name: "",ingredients:Ingredients(ingredientList: [""]),directions:[Direction](),calories:Calories(protein: 0, carbs: 0, fat: 0),effort:Effort(effort: .Easy),size:ServingSize(size: 0),website:Website(url: NSURL(), websiteTitle: ""))
        
        
        // Meal Name
        if let name = snapshot.value!["meal-name"] as? String {
            self.name = name
            self.image = UIImage(named: self.name)
            self.key = snapshot.key
        } else if let name = snapshot.value!["name"] as? String {
            self.name = name
            self.image = UIImage(named: self.name)
        }
        
        if let size = snapshot.value!["size"] as? Int {
            self.servingSize = ServingSize(size: size)
        } else if let servingSize = snapshot.value!["servingSize"] as? NSDictionary {
            if let size = servingSize["size"] as? Int {
                self.servingSize = ServingSize(size: size)
            }
        }
        
        if let isFav = snapshot.value!["isFav"] as? Bool {
            self.isFav = isFav
        }
        
        if let date = snapshot.value!["date"] as? String {
            self.date = date
        }
        if let effort = snapshot.value!["effort"] as? String {
            self.effort = self.getEffortFromDatabase(effort)
        } else if let effortDict = snapshot.value!["effort"] as? NSDictionary {
            if let effort = effortDict["effort"] as? String {
                self.effort = self.getEffortFromDatabase(effort)
            }
        }
        
        if let time = snapshot.value!["time"] as? Int {
            self.time = self.getTime(time)
        }
        
        if let ingredients = snapshot.value!["ingredients"] as? [String] {
            self.ingredients = self.getIngredients(ingredients)
            self.items = self.ingredients.getMainIngredients()
        } else if let ingredientsDict = snapshot.value!["ingredients"] as? NSDictionary {
            if let ingredients = ingredientsDict["ingredients"] as? [String] {
                self.ingredients = self.getIngredients(ingredients)
                self.items = self.ingredients.getMainIngredients()
            }
        }
        
        if let directions = snapshot.value!["directions"] as? NSDictionary {
            self.directions = self.getDirections(directions)
        } else if let directions = snapshot.value!["directions"] as? NSArray {
            
            var t = 0
            
            for d in directions {
                let items = d as! [String : AnyObject]
                let info = items["info"] as! String
                let time = items["time"] as! [String : AnyObject]
                let totalMins = time["totalMin"] as! Int
                t += totalMins
                self.directions.append(Direction(directionInfo: info, directionTime: Time(minutes: totalMins)))
            }
            
            self.time = Time(minutes: t)
        }
        
        if let numOfTimes = snapshot.value!["numOfTimes"] as? Int {
            self.numOfTime = numOfTimes
        }
        
        if let carbs = snapshot.value!["carbs"] as? CGFloat {
            if let protein = snapshot.value!["protein"] as? CGFloat {
                if let fat = snapshot.value!["fat"] as? CGFloat {
                    self.calories = Calories(protein: protein, carbs: carbs, fat: fat)
                }
            }
        } else if let calories = snapshot.value!["calories"] as? NSDictionary {
            if let carbs = calories["carbs"] as? CGFloat  {
                if let protein = calories["protein"] as? CGFloat {
                    if let fat = calories["fat"] as? CGFloat {
                        self.calories = Calories(protein: protein, carbs: carbs, fat: fat)
                    }
                }
                
            }
        }
        
        if let website = snapshot.value!["website"] as? NSDictionary {
            self.website = self.getWebsite(website)
        }
    }
    
    private func getEffortFromDatabase(data: String) -> Effort {
        
        let effort: Effort!
        
        switch (data)
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
    
    private func getTime(data: Int) -> Time{
        return Time(minutes: data)
    }
    
    private func getIngredients(data: [String]) -> Ingredients {
        let newIngred = Ingredients(ingredientList: data)
        
        return newIngred
    }
    
    private func getDirections(data: NSDictionary) -> [Direction] {
        var directions = [Direction]()
        
        let info = data["info"] as! NSArray
        let time = data["time"] as! NSArray
        
        for i in 0..<time.count {
            directions.append(Direction(directionInfo: info[i] as! String, directionTime: Time(minutes: time[i] as! Int)))
        }
        
        return directions
    }
    
    private func getWebsite(data: NSDictionary) -> Website {
        var website: Website!
        
        var webURL = ""
        var webTitle = ""
        
        if let url = data["url"] as? String {
            webURL = url
        } else if let url = data["uri"] as? String {
            webURL = url
        }
        
        if let title = data["title"] as? String {
            webTitle = title
        } else if let title = data["titleOfWebsite"] as? String {
            webTitle = title
        }
        
        website = Website(url: NSURL(string: webURL)!, websiteTitle: webTitle)
        
        return website
    }
}

// MARK : ITEM
extension Item {
    convenience init(snapshot: FIRDataSnapshot) {
        self.init(name: "", category: "")
        
        self.key = snapshot.key
        
        if let name = snapshot.value!["item-name"] as? String {
            self.name = name
            self.image = UIImage(named: name)
        } else if let name = snapshot.value!["name"] as? String {
            self.name = name
            self.image = UIImage(named: name)
        }
        
        // Ingredients
        if let category = snapshot.value!["item-category"] as? String {
            self.category = category
        } else if let category = snapshot.value!["category"] as? String {
            self.category = category
        }
        
        if let quantity = snapshot.value!["quantity"] as? Int {
            self.quantity = quantity
        }
    }
}
