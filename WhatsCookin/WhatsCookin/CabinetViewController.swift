//
//  CabinetViewController.swift
//  FUDI
//
//  Created by Devontae Reid on 11/15/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import FoldingTabBar
import MealFramework
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView


class CabinetViewController: UIViewController , YALTabBarInteracting {

    private let backgroundColor: UIColor = UIColor.peachColor()
    let actID = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var items: [Item] = [Item]()
    var cabinet = [ItemCategory]()

    var fruitArray: [Item] = [Item]()
    var vegeArray: [Item] = [Item]()
    var meatArray: [Item] = [Item]()
    var grainArray: [Item] = [Item]()
    var dairyArray: [Item] = [Item]()
    
    let tableView = UITableView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // So that navigation bar does not hide the tableview
        self.edgesForExtendedLayout = .None
        
        self.actIDSetup()
        self.tableViewSettings()
        self.view.backgroundColor = backgroundColor
        
        self.getUserItemsFromDatabase()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Empty Arrays
        self.cabinet = [ItemCategory]()
        self.meatArray = [Item]()
        self.fruitArray = [Item]()
        self.dairyArray = [Item]()
        self.vegeArray = [Item]()
        self.grainArray = [Item]()
    }
    
    func extraRightItemDidPress() {
        self.addIngredientToCabinet()
    }
    
    func actIDSetup() {
        actID.isHidden = false
        actID.type = ballPulseSyncBallPulseSync
        actID.center = view.center
        actID.startAnimation()
        actID.hidesWhenStopped = true
        view.addSubview(actID)
    }
    
    func tableViewSettings() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.separatorColor = UIColor.white
        self.tableView.backgroundColor = UIColor.peachColor()
        self.tableView.registerregister(CabinetTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(self.tableView)
        view.addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 80)
            ])
    }

//    // Refresh tableview
//    func refresh()
//    {
//        let cells = tableView.visibleCells
//        let tableHeight: CGFloat = tableView.bounds.size.height
//        
//        for i in cells {
//            let cell: UITableViewCell = i as UITableViewCell
//            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
//        }
//        
//        var index = 0
//        
//        for a in cells {
//            let cell: UITableViewCell = a as UITableViewCell
//            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowAnimatedContent , animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, 0);
//                }, completion: nil)
//            
//            index += 1
//        }
//    }
    
    
    func addIngredientToCabinet()
    {
        self.navigationController?.pushViewController(NewIngredientViewController(), animated: true)
    }


}

// MARK: BACKEND 
extension  CabinetViewController {
    func getUserItemsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/User-Items/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            
            // Empty Arrays
            self.cabinet = [ItemCategory]()
            self.items = [Item]()
            self.meatArray = [Item]()
            self.fruitArray = [Item]()
            self.dairyArray = [Item]()
            self.vegeArray = [Item]()
            self.grainArray = [Item]()
            userItems = [Item]()
            
            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                let data = snap.value as! [String : AnyObject]
                let uid = data["uid"] as! String
                if uid == userID {
                    self.items.append(Item(snapshot: snap))
                }
            }
            
            userItems = self.items
            self.items = userItems
            self.cabinet = self.itemCategorySorter(self.items)
            
            // Stop Animating
            self.actID.stopAnimation()
            self.actID.hidden = true
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func itemCategorySorter(items: [Item]) ->[ItemCategory] {
        
        for item in items {
            //Sort Items in array
            switch(item.category.uppercased())
            {
            case "Beef".uppercased(),"Poultry".uppercaseString,"Pork".uppercaseString:
                self.meatArray.append(item)
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
        
        let cabinet = [ItemCategory(category: "Fruits", items: self.fruitArray),ItemCategory(category: "Vegetables", items: self.vegeArray),ItemCategory(category: "Meat", items: self.meatArray),ItemCategory(category: "Dairy", items: self.dairyArray),ItemCategory(category: "Grain", items: self.grainArray)]
        
        return cabinet
        
    }
    
    func takeItemOut(date: String,var quantity: Int,itemName : String,itemCategory: String,key: String) {
        // Increment num of times made
        quantity++
        
        let itemPost: [String : AnyObject] = [
            "username" : userName,
            "uid" : userID,
            "date" : date,
            "item-name" : itemName,
            "item-category" : itemCategory,
            "quantity" : quantity
        ]
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/User-Items")
        ref.child(key).updateChildValues(itemPost)
    }
}

// MARK: Collection View
//
extension CabinetViewController:  UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func asyncLoadMealImage(item: Item, imageView: UIImageView)
    {
        dispatch_get_main_queue().async { () -> Void in
            
            var image : UIImage?
            image = item.image
            imageView.image = image
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CabinetTableViewCell
        let itemCategory = cabinet[indexPath.section].category
        cell.categoryLabel.text = itemCategory
        cell.categoryImage.image = UIImage(named: itemCategory?.lowercaseString)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Number of items in the category
    }
    
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let itemCategory = cabinet[section].category
//        return itemCategory // Names Of the Categorys
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height/4
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
//        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
//        header.textLabel!.font = UIFont.LatoLight(20)
//        header.alpha = 1.0 //make the header transparent
//    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cabinet.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CabinetTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CabinetCollectionViewCell
        
        let item = cabinet[collectionView.tag].items[indexPath.item]
        
        cell.titleLabel.text = item.name
        cell.quantityLabel.text = "\(item.quantity)"
        
        asyncLoadMealImage(item, imageView: cell.itemImage)
        
        cell.contentView.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cabinet[collectionView.tag].items.count
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Item Name
        let item = cabinet[collectionView.tag].items[indexPath.item]
        
        let alert = JSSAlertView.danger(
            self,
            title: item.name,
            text: "Do you want to delete this?",
            buttonText: "Yes",
            cancelButtonText: "No" // This tells JSSAlertView to create a two-button alert
        )
        alert.addAction { () -> Void in
            _ = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/User-Items/\(item.key)").removeValue()
            
            //self.tableView.reloadData()
        }
        
        
    }
    
    
}


class CabinetTableViewCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var itemName: String? = nil
    var itemImage: UIImage? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = self.contentView.bounds
        self.collectionView.frame = CGRectMake(0, 0.5, frame.size.width, frame.size.height - 1)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var cellID: String = "cell"
    let categoryImage = UIImageView()
    let categoryLabel = UILabel()
    
    private func setupCell()
    {
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 20
        
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.alpha = 0.84
        self.addSubview(categoryImage)
        self.addConstraints([
            NSLayoutConstraint(item: categoryImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: categoryImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: categoryImage, attribute: .right, relatedBy: .equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: categoryImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .Center
        categoryLabel.font = UIFont.LatoBold(70)
        categoryLabel.textColor = UIColor.blackColor
        categoryImage.addSubview(categoryLabel)
        categoryImage.addConstraints([
            NSLayoutConstraint(item: categoryLabel, attribute: .top, relatedBy: .equal, toItem: categoryImage, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: categoryLabel, attribute: .left, relatedBy: .equal, toItem: categoryImage, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: categoryLabel, attribute: .right, relatedBy: .equal, toItem: categoryImage, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: categoryLabel, attribute: .bottom, relatedBy: .equal, toItem: categoryImage, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.register(CabinetCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = UIColor.clear
        collectionView.reloadData()
        categoryImage.addSubview(collectionView)
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        
        get {
            return collectionView.contentOffset.x
        }
    }
}
