//
//  NewIngredientViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 12/7/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

var userItems = [Item]()

class NewIngredientViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // Propeties
    var shelves = [ItemCategory]()
    var searchedArray = [ItemCategory]()
    var items: [Item] = []
    var itemName = ""
    var itemCategory = ""
    
    var fruitArray: [Item] = [Item]()
    var vegeArray: [Item] = [Item]()
    var beefArray: [Item] = [Item]()
    var porkarray: [Item] = [Item]()
    var poultryArray: [Item] = [Item]()
    var grainArray: [Item] = [Item]()
    var dairyArray: [Item] = [Item]()

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = backItem
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.freshEggplant()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.getFromDatabase()
        
        self.tableView.registerClass(NewIngredientCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.searchController.removeFromParentViewController()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

// MARK: Database
extension NewIngredientViewController {
    
    func addToBackend(item:Item) {
        
        // MARK : Date
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter.localizedStringFromDate(currentDate, dateStyle: .LongStyle, timeStyle: .NoStyle)
        let date : String = dateFormatter
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/User-Items")
        
        /*
        
        
        FIX THE ELSE 
        
        TO ADD ITEM IF NOT THERE
        
        
        */
        
        // Validation if an item in your cabinet was found with the same name
        var foundItem = false
        var atIndex = 0
        
        
        // If you don't have anything in the cabinet
        if userItems.count != 0 {
            for userItem in userItems {
                // Found Item in cabinet
                if userItem.name == item.name {
                    foundItem = true
                    break
                } else {
                    foundItem = false
                }
                atIndex++
            }
            
            // If item was found update the quanity
            if foundItem {
                self.updateItem(userItems[atIndex].quantity, date: date, key: userItems[atIndex].key)
            } else {
                self.addItem(item.quantity, date: date, key: ref.childByAutoId().key)
            }
            
        } else {
            self.addItem(item.quantity, date: date, key: ref.childByAutoId().key)
        }
        
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    // Update the item quantity in the cabinet
    func updateItem(var quantity: Int,date: String,key: String) {
        quantity++
        let itemPost: [String : AnyObject] = [
            "user" : userName,
            "uid" : userID,
            "date" : date,
            "item-name" : itemName,
            "item-category" : itemCategory,
            "quantity" : quantity
        ]
        
        let _ = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/User-Items").child(key).updateChildValues(itemPost)
    }
    
    
    // Add the item to the cabinet
    func addItem(var quantity : Int,date: String,key:String) {
        quantity++
        let itemPost: [String : AnyObject] = [
            "user" : userName,
            "uid" : userID,
            "date" : date,
            "item-name" : itemName,
            "item-category" : itemCategory,
            "quantity" : quantity
        ]
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com")
        ref.child("User-Items").child("\(key)").setValue(itemPost)
    }
    
    func getFromDatabase()
    {
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/item/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            self.items = [Item]()
            var newItems = [Item]()
            
            for intity in snapshot.children {
                let snap = intity as! FIRDataSnapshot
                newItems.append(Item(snapshot: snap))
            }
            self.itemCategorySorter(newItems)
            self.items = self.sortByName(newItems)
            self.tableView.reloadData()
        }
        
        
    }
    
    private func sortByName(items:[Item]) -> [Item]{
        var food: [Item] = items
        
        food.sortInPlace({$0.name < $1.name})
        return food
    }
    
    func itemCategorySorter(items: [Item]) {
        for item in items {
            //Sort Items in array
            switch(item.category.uppercaseString)
            {
            case "Beef".uppercaseString:
                self.beefArray.append(item)
            case "Poultry".uppercaseString:
                self.poultryArray.append(item)
            case "Pork".uppercaseString:
                self.porkarray.append(item)
            case "Dairy".uppercaseString:
                self.dairyArray.append(item)
            case "Grain".uppercaseString:
                self.grainArray.append(item)
            case "Fruit".uppercaseString:
                self.fruitArray.append(item)
            case "Vegetable".uppercaseString:
                self.vegeArray.append(item)
            default:
                break
            }
        } // End for
        
        
        // Add to  cabinet
        self.shelves.append(ItemCategory(category: "Fruits", items: self.fruitArray))
        self.shelves.append(ItemCategory(category: "Vegetables", items: self.vegeArray))
        self.shelves.append(ItemCategory(category: "Beef", items: self.beefArray))
        self.shelves.append(ItemCategory(category: "Pork", items: self.porkarray))
        self.shelves.append(ItemCategory(category: "Poultry", items: self.poultryArray))
        self.shelves.append(ItemCategory(category: "Grain", items: self.grainArray))
        self.shelves.append(ItemCategory(category: "Dairy", items: self.dairyArray))
        
        
        self.tableView.reloadData()
    }
    
}

// MARK: Tablview Datasource & Delegate
extension NewIngredientViewController
{
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewIngredientCell
        cell.textLabel?.font = UIFont.LatoLight(20)
        
        
        
        var item: Item
        if (searchController.active && searchController.searchBar.text != "" )
        {
            let items = self.searchedArray[indexPath.section].items
            item = items[indexPath.row]
        }
        else
        {
            let items = self.shelves[indexPath.section].items
            item = items[indexPath.row]
        }
        
        // Change size of imageview
        cell.itemImage.sizeToFit()
        
        cell.itemName.text = item.name
        
        asyncLoadMealImage(item, imageView: cell.itemImage)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var items : [Item]
        
        if (searchController.active && searchController.searchBar.text != "" ) {
            items = self.searchedArray[section].items
        } else {
            items = self.shelves[section].items
        }
        
        return items.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (searchController.active && searchController.searchBar.text != "" ) {
            return self.searchedArray.count
        } else {
            return shelves.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var shelf: ItemCategory
        
        if (searchController.active && searchController.searchBar.text != "" ) {
            shelf = searchedArray[section]
        } else {
            shelf = shelves[section]
        }
        
        return shelf.category
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item: Item
       
        if (searchController.active && searchController.searchBar.text != "" ) {
            let items = self.searchedArray[indexPath.section].items
            item = items[indexPath.row]
        } else {
            let items = self.shelves[indexPath.section].items
            item = items[indexPath.row]
        }
        
        itemName = item.name
        itemCategory = item.category
        
        self.addToBackend(item)
    }
    
    func asyncLoadMealImage(item: Item, imageView: UIImageView)
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            var image : UIImage?
            image = item.image
            if item.image != nil {
                imageView.image = image
            }
        }
    }
    
    
    func getItemsOnShelf(index: Int) -> [Item] {
        switch (index) {
        case 0 :
            items = shelves[index].items
        case 1:
            items = shelves[index].items
        case 2 :
            items = shelves[index].items
        case 3 :
            items = shelves[index].items
        case 4:
            items = shelves[index].items
        default:
            break
        }
        
        return items
    }

}


//MARK: Search Results

extension NewIngredientViewController: UISearchResultsUpdating {
    
    // MARK: Search
    func filterContentForSearchText(searchText: String, scope: String = "Title")
    {
        var boolean: Bool!
        
        searchedArray = shelves.filter { shelf in
            
            for item in shelf.items {
                if item.name.lowercaseString.containsString(searchText.lowercaseString)
                {
                    boolean = true
                } else if shelf.category.lowercaseString.containsString(searchText.lowercaseString) {
                    boolean = true
                } else {
                    boolean = false
                }
            }
            return boolean
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


// MARK: TableViewCell
class NewIngredientCell: UITableViewCell
{
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let itemImage : UIImageView = UIImageView()
    let itemName: UILabel = UILabel()
    
    func setup()
    {
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        itemImage.layer.cornerRadius = 25
        self.contentView.addSubview(itemImage)
        self.contentView.addConstraints([
            
            NSLayoutConstraint(item: itemImage, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: itemImage, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: itemImage, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: itemImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 70)
            ])
        
        itemName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(itemName)
        self.contentView.addConstraints([
            
            NSLayoutConstraint(item: itemName, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: itemName, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: itemName, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: itemName, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 235)
            ])
    }
}
