//
//  AppDelegate.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    if let gameSpeed = NSUserDefaults.standardUserDefaults().valueForKey("gameSpeed") as? Int {
      GameSpeed = gameSpeed
    }
    
    if let gameLevel = NSUserDefaults.standardUserDefaults().valueForKey("gameLevel") as? Int {
      GameLevel = gameLevel
    }
    
    if let numColors = NSUserDefaults.standardUserDefaults().valueForKey("numColors") as? Int {
      NumberOfColors = numColors
    }
    
    if let showBG = NSUserDefaults.standardUserDefaults().valueForKey("showBG") as? Bool {
      ShowBG = showBG
    }
    
    if let moreLevels = NSUserDefaults.standardUserDefaults().valueForKey("moreLevelsPurchased") as? Bool {
      MoreLevelsPurchased = moreLevels
    }
    
    if let fifthColor = NSUserDefaults.standardUserDefaults().valueForKey("fifthColorPurchased") as? Bool {
      FifthColorPurchased = fifthColor
    }
    
    if let nextPiece = NSUserDefaults.standardUserDefaults().valueForKey("nextPiecePurchased") as? Bool {
      NextPiecePurchased = nextPiece
    }
    
    if let showNextPiece = NSUserDefaults.standardUserDefaults().valueForKey("showNextPiece") as? Bool {
      ShowNextPiece = showNextPiece
    }

    return true
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

