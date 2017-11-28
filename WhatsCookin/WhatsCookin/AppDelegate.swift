//
//  AppDelegate.swift
//  WhatsCookin
//
//  Created by Devontae Reid on 10/17/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit
import FoldingTabBar
import Firebase
import FirebaseAuth
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        self.setupTabBar()
        
        return true
    }
    
    // MARK: GOOGLE SIGN IN settings
    func application(application: UIApplication,
        openURL url: NSURL, options: [String: AnyObject]) -> Bool {
            return GIDSignIn.sharedInstance().handleURL(url,
                sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func application(application: UIApplication,
        openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            return GIDSignIn.sharedInstance().handleURL(url,
                sourceApplication: sourceApplication,
                annotation: annotation) || FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                // Perform any operations on signed in user here.
            
                let fullName = user.profile.name
                
                let authenication: GIDAuthentication = user.authentication
                let creditals: FIRAuthCredential = FIRGoogleAuthProvider.credentialWithIDToken(authenication.idToken, accessToken: authenication.accessToken)
                
                FIRAuth.auth()?.signInWithCredential(creditals, completion: { (user, error) -> Void in
                    if (user != nil) {
                        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                        print("\(fullName) is signed in!")
                    }
                })
                
                // [START_EXCLUDE]
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "ToggleAuthUINotification",
                    object: nil,
                    userInfo: ["statusText": "Signed in user:\n\(fullName)"])
                // [END_EXCLUDE]
            } else {
                print("\(error.localizedDescription)")
                // [START_EXCLUDE silent]
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "ToggleAuthUINotification", object: nil, userInfo: nil)
                // [END_EXCLUDE]
            }
    }
    // [END signin_handler]
    
    // [START disconnect_handler]
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // [START_EXCLUDE]
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "User has disconnected."])
            // [END_EXCLUDE]
    }
    
    // MARK: Facebook Signin 
//    func application(application: UIApplication,
//        openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
    // MARK: TabBar Setup
    func setupTabBar() -> UIViewController
    {
        
        let iconSize = CGSize(width: 30, height: 35)
        let tabBarController = self.window?.rootViewController as! YALFoldingTabBarController
        
        let item1 = YALTabBarItem(itemImage: UIImage(named: "home")?.resize(iconSize), leftItemImage: nil, rightItemImage: nil)
        let item2 = YALTabBarItem(itemImage: UIImage(named: "heart")?.resize(iconSize), leftItemImage: UIImage(named: "all_meals"), rightItemImage: nil)
        let item3 = YALTabBarItem(itemImage: UIImage(named: "dish")?.resize(iconSize), leftItemImage: nil, rightItemImage: nil)
        let item4 = YALTabBarItem(itemImage: UIImage(named: "cabinets")?.resize(iconSize), leftItemImage: nil, rightItemImage: UIImage(named: "new_item"))
        
        tabBarController.centerButtonImage = UIImage(named: "plus_icon")
        
        tabBarController.leftBarItems = [item1, item2]
        tabBarController.rightBarItems = [item3, item4]
        
        tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        tabBarController.tabBarView.backgroundColor = UIColor.clearColor()
        tabBarController.tabBarView.tabBarColor = UIColor.freshEggplant()
        tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight
        tabBarController.tabBarView.tabBarViewEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        tabBarController.tabBarView.tabBarItemsEdgeInsets = UIEdgeInsets(top: -30, left: -30, bottom: -30, right: -30)
        
        tabBarController.viewControllers = self.setupNavigation()
        self.window?.backgroundColor = UIColor.lightGrayColor()
        self.window?.makeKeyAndVisible()
        return tabBarController
    }
    
    
    func setupNavigation() -> [UIViewController]
    {
        
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.LatoRegular(20)]

        // MAIN FEED VC
        let mainVC : HomeViewController = HomeViewController()
        mainVC.title = "Sizzle"

        let mainNavController = UINavigationController(rootViewController: mainVC)
        mainNavController.navigationBar.barTintColor = UIColor.freshEggplant(0.7)
        mainNavController.navigationBar.titleTextAttributes = titleDict


        // CABINET VC
        let cabVC: CabinetViewController = CabinetViewController()
        cabVC.title = "Cabinet"

        let cabinetNavController = UINavigationController(rootViewController: cabVC)
        cabinetNavController.navigationBar.barTintColor = UIColor.freshEggplant(0.7)
        cabinetNavController.navigationBar.titleTextAttributes = titleDict


        // MAKE A MEAL VC
        let MAMVC : MakeAMealController = MakeAMealController()
        MAMVC.title = "Make A Meal"

        let MAMNavController = UINavigationController(rootViewController: MAMVC)
        MAMNavController.navigationBar.barTintColor = UIColor.freshEggplant(0.7)
        MAMNavController.navigationBar.titleTextAttributes = titleDict


        // FAVORITE MEAL VC
        let favMealVC : FavoriteMealsTableViewController = FavoriteMealsTableViewController()
        favMealVC.title = "Favorite Meals"

        let favNavController = UINavigationController(rootViewController: favMealVC)
        favNavController.navigationBar.barTintColor = UIColor.freshEggplant(0.7)
        favNavController.navigationBar.titleTextAttributes = titleDict
        
        let controllers = [mainNavController,favNavController,MAMNavController,cabinetNavController]
        return controllers
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


