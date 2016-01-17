//
//  Globals.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/31/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func assessState() {
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
  
  if let moreLevels = NSUserDefaults.standardUserDefaults().valueForKey("morelevels2Purchased") as? Bool {
    MoreLevelsPurchased = moreLevels
  }
  
  if let fifthColor = NSUserDefaults.standardUserDefaults().valueForKey("fifthcolor2Purchased") as? Bool {
    FifthColorPurchased = fifthColor
  }
  
  if let nextPiece = NSUserDefaults.standardUserDefaults().valueForKey("shownextpiece2Purchased") as? Bool {
    NextPiecePurchased = nextPiece
  }
  
  if let showNextPiece = NSUserDefaults.standardUserDefaults().valueForKey("showNextPiece") as? Bool {
    ShowNextPiece = showNextPiece
  }
}

func purchaseAll() {
  NSUserDefaults.standardUserDefaults().setBool(true, forKey: "shownextpiecePurchased")
  NSUserDefaults.standardUserDefaults().setBool(true, forKey: "fifthcolorPurchased")
  NSUserDefaults.standardUserDefaults().setBool(true, forKey: "morelevelPurchased")
}