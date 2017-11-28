
import UIKit
import Koloda

var userID = ""
var userName = ""

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    
    var count = 8
    
    
    // Arrays need to grab item from backend
    var meals = [Meal]()
    
    private var isPresenting: Bool = true
    private var point: CGPoint!
    private let animationDuration = 0.3

    var kolodaBackground = UIView()
    var kolodaView: KolodaView = KolodaView()
    
    let actID = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // So that navigation bar does not hide the tableview
        //self.edgesForExtendedLayout = .None
        
        // Table and Koloda View Settings
        self.tableViewSettings()
        self.mealPreviewSetup()
        
//        if let user = FIRAuth.auth()?.currentUser {
            userName = user.email!
            userID = user.uid
//            self.actIDSetup()
//            self.getUserMealsFromDatabase()
//            self.animateTable()
        
            print("Username \(userName)")
//        } else {
//            let loginVC = LoginViewController()
//            self.navigationController!.presentViewController(loginVC, animated: true, completion: nil)
//        }
        self.view.backgroundColor = UIColor.peachColor()
        self.navigationController?.navigationBar.hidden = false
        
        //performSelector("signOutUser", withObject: nil, afterDelay: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      // Dispose of any revarrces that can be recreated.
    }
    
//    func signOutUser() {
//        try! FIRAuth.auth()?.signOut()
//        let loginVC = LoginViewController()
//        self.navigationController!.presentViewController(loginVC, animated: true, completion: nil)
//    }
    
//    func actIDSetup() {
//        actID.hidden = false
//        actID.type = .BallPulseSync
//        actID.center = view.center
//        actID.startAnimation()
//        actID.hidesWhenStopped = true
//        view.addSubview(actID)
//    }
//
    // This is to show a preview of the meal when the user clicks an item
    func mealPreviewSetup() {
        
        self.kolodaBackgroundSetup()
    }
    
    func kolodaBackgroundSetup() {
        kolodaBackground.hidden = true
        kolodaBackground.translatesAutoresizingMaskIntoConstraints = false
        kolodaBackground.backgroundColor = UIColor.freshEggplant(0.7)
        self.view.addSubview(kolodaBackground)
        self.view.addConstraints([
            NSLayoutConstraint(item: kolodaBackground, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: kolodaBackground, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: kolodaBackground, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: kolodaBackground, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0)
            ])
        
        let backButton = UIButton()
        let fowardButton = UIButton()
        let closeButton = UIButton()
        
        let height: CGFloat = 60
        let width: CGFloat = 60
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        fowardButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.setImage(UIImage(named: "Back_Button"), forState: .Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        kolodaBackground.addSubview(backButton)
        kolodaBackground.addConstraints([
            NSLayoutConstraint(item: backButton, attribute: .Left, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Left, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: backButton, attribute: .Bottom, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Bottom, multiplier: 1.0, constant: -90),
            NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: height),
            NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width)
            ])
        
        fowardButton.setImage(UIImage(named: "Foward_Button"), forState: .Normal)
        fowardButton.addTarget(self, action: "goForward", forControlEvents: .TouchUpInside)
        kolodaBackground.addSubview(fowardButton)
        kolodaBackground.addConstraints([
            NSLayoutConstraint(item: fowardButton, attribute: .Right, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Right, multiplier: 1.0, constant: -50),
            NSLayoutConstraint(item: fowardButton, attribute: .Bottom, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Bottom, multiplier: 1.0, constant: -90),
            NSLayoutConstraint(item: fowardButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: height),
            NSLayoutConstraint(item: fowardButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width)
            ])
        
        closeButton.setImage(UIImage(named: "close_button"), forState: .Normal)
        closeButton.addTarget(self, action: "closeKolodaView", forControlEvents: .TouchUpInside)
        kolodaBackground.addSubview(closeButton)
        kolodaBackground.addConstraints([
            NSLayoutConstraint(item: closeButton, attribute: .CenterX, relatedBy: .Equal, toItem: kolodaBackground, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: closeButton, attribute: .Bottom, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Bottom, multiplier: 1.0, constant: -90),
            NSLayoutConstraint(item: closeButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: height),
            NSLayoutConstraint(item: closeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width)
            ])
    }
    
    func goBack() {
        self.kolodaView.revertAction()
    }
    
    func goForward() {
        self.kolodaView.swipe(.Right)
    }
    
    func closeKolodaView() {
        self.kolodaBackground.hidden = true
        self.kolodaView.reloadData()
    }
}


//  MARK: SETTINGS FOR TABLEVIEW
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableViewSettings()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = UIColor.peachColor()
        tableView.backgroundColor = UIColor.peachColor()
        self.tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        view.addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 80)
            ])
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
    
    // MARK: TableView Functions
    
    // Number of cells presented
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
        
        if meals.count != 0 {
            
            let meal = meals[indexPath.row]
            cell.datelabel.text = " \(meal.date)"
            cell.mealTitleView.text = meal.name
            cell.timeLabel.text = meal.getTotalTime().getTitle()
            cell.effortLabel.text = meal.effort.getEffortInfo()
            cell.servingSizeLabel.text = meal.servingSize.getTitle()
            cell.mealImageView.image = meal.image
            if (meal.isFav == true) {
                cell.favButton.select()
            } else {
                cell.favButton.deselect()
            }
            
            cell.selectionStyle = .None
            
            cell.favButton.tag = indexPath.row
            cell.favButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        } else {
            cell.mealTitleView.text = "Opps you haven't made a meal yet get to cooking!"
        }
        
        return cell
    }
    
    // Number of row on the menu
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    // Customize size of cells
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height/3
    }
    
    // MARK: Like Button function
    func tapped(sender: DOFavoriteButton)
    {
        if (sender.selected)
        {
            // Deselect
            self.updateMealFav(false, key: meals[sender.tag].key)
            sender.deselect()
        }
        else
        {
            // Select
            self.updateMealFav(true, key: meals[sender.tag].key)
            sender.select()
        }
    }
    
    private func likeMeal(checkedBool: Bool) -> Bool
    {
        let isLiked: Bool = true;
        
        return isLiked;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        kolodaView.translatesAutoresizingMaskIntoConstraints = false
        kolodaView.currentCardIndex = indexPath.row
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaBackground.addSubview(kolodaView)
        kolodaBackground.addConstraints([
            NSLayoutConstraint(item: kolodaView, attribute: .Left, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Left, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: kolodaView, attribute: .Bottom, relatedBy: .Equal, toItem: kolodaBackground, attribute: .CenterY, multiplier: 1.0, constant: 200),
            NSLayoutConstraint(item: kolodaView, attribute: .Top, relatedBy: .Equal, toItem: kolodaBackground, attribute: .CenterY, multiplier: 1.0, constant: -250),
            NSLayoutConstraint(item: kolodaView, attribute: .Right, relatedBy: .Equal, toItem: kolodaBackground, attribute: .Right, multiplier: 1.0, constant: -40)
            ])
        kolodaBackground.hidden = false
    }
}


// MARK: Animation
extension HomeViewController: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate
{
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = false
        return self
    }
    

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView();
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        toViewController!.view.frame = fromViewController!.view.frame
        if(self.isPresenting == true) {
            toViewController!.view.alpha = 0;
            toViewController!.view.transform = CGAffineTransformMakeScale(0, 0);
            
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .TransitionNone, animations: { () -> Void in
                toViewController!.view.alpha = 1;
                toViewController!.view.transform = CGAffineTransformMakeScale(1, 1);
                containerView!.addSubview(toViewController!.view)
                }, completion: { (completed) -> Void in
                    transitionContext.completeTransition(completed)
            })
            
        } else {
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .TransitionNone, animations: { () -> Void in
                fromViewController!.view.alpha = 0;
                fromViewController!.view.transform = CGAffineTransformMakeScale(0.001, 0.0001);
                }, completion: { (completed) -> Void in
                    fromViewController?.view.removeFromSuperview()
                    transitionContext.completeTransition(completed)
            })
        }
    }
}

extension HomeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(meals.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        
        let i = Int(index)
        
        
        let meal = meals[i]
            print(meal.name)
        mealTitle = meal.name
        effort = meal.effort
        servingSize = meal.servingSize
        time = meal.getTotalTime()
        mealImage = meal.image

        
        let mealPreview = MealPreviewView(frame: CGRect(x: 0, y: 0, width: kolodaView.bounds.width, height: kolodaView.bounds.height))
        mealPreview.layer.cornerRadius = 20
        mealPreview.clipsToBounds = true
        if meal.isFav == true {
            mealPreview.favButton.setTitle("  REMOVE TO FAVORITES", forState: .Normal)
        } else {
            mealPreview.favButton.setTitle("  ADD TO FAVORITES", forState: .Normal)
        }
        mealPreview.favButton.tag = i
        mealPreview.favButton.addTarget(self, action: "addFavAction:", forControlEvents: .TouchUpInside)
        
        return mealPreview
    }
    
    // Fav Button for meal Preview
    func addFavAction(sender: ZFRippleButton) {
        if sender.selected
        {
            // Deselect
            self.updateMealFav(false, key: meals[sender.tag].key)
            sender.setTitle("  ADD TO FAVORITES", forState: .Normal)
            sender.deselect()
        }
        else
        {
            // Select
            self.updateMealFav(true, key: meals[sender.tag].key)
            sender.setTitle("  REMOVE TO FAVORITES", forState: .Normal)
            sender.select()
        }
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        let overlay = OverlayView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        overlay.layer.cornerRadius = 20
        return overlay
    }
}


extension HomeViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        self.closeKolodaView()
    }
}


// MARK: DATABASE SETTINGS
extension HomeViewController {
    
    func updateMealFav(bool: Bool,key: String) {
        
        let _ = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/Made-Meals/\(key)/isFav").setValue(bool)
    }
    
    func getUserMealsFromDatabase()
    {
        
        let ref = FIRDatabase.database().referenceFromURL("https://crumblestorage.firebaseio.com/Made-Meals/")
        
        ref.observeEventType(.Value) { (snapshot: FIRDataSnapshot) -> Void in
            
            // Empty Meals
            self.meals = [Meal]()

            
            for item in snapshot.children {
                let snap = item as! FIRDataSnapshot
                let data = snap.value as! [String : AnyObject]
                let uid = data["uid"] as! String
                if uid == userID {
                    let meal = Meal(snapshot: snap)
                    self.meals.append(meal)
                }
            }
            
            userMeals = self.meals
            
            // Stop Animating
            self.actID.stopAnimation()
            self.actID.hidden = true
            
            self.tableView.reloadData()
        }
        
    }
    
    // Check to see if meal is made more than once
    func checkIfMeal(meals: [Meal]) -> [Meal] {
        var newMeals = [Meal]()
        var counts = [String : Int]()
        
        for meal in meals {
            counts[meal.name] = (counts[meal.name] ?? 0) + 1
        }// End For
        
        //print(counts)
        
        for (key, _) in counts {
            newMeals.append(Meal(name: key, ingredients: Ingredients(ingredientList: []), directions: [Direction](), calories: Calories(protein: 0, carbs: 0, fat: 0), effort: Effort(effort: .Easy), size: ServingSize(size: 0), website: Website(url: NSURL(), websiteTitle: "")))
        }
        
        for meal in meals {
            for newMeal in newMeals {
                if meal.name == newMeal.name {
                    newMeal.ingredients = meal.ingredients
                    newMeal.directions = meal.directions
                    newMeal.calories = meal.calories
                    newMeal.effort = meal.effort
                    newMeal.servingSize = meal.servingSize
                    newMeal.website = meal.website
                    newMeal.time = meal.time
                    newMeal.date = meal.date
                    newMeal.isFav = meal.isFav
                    newMeal.key = meal.key
                }
            }
        }
        
        return newMeals
    }
    
    func dateCompare(date:String,otherDate: String) {
        
    }
}
