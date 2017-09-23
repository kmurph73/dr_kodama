//
//  Globals.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/31/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func assessState() {
  if let gameSpeed = UserDefaults.standard.value(forKey: "gameSpeed") as? Int {
    GameSpeed = gameSpeed
  }
  
  if let gameLevel = UserDefaults.standard.value(forKey: "gameLevel") as? Int {
    GameLevel = gameLevel
  }
  
  if let numColors = UserDefaults.standard.value(forKey: "numColors") as? Int {
    NumberOfColors = numColors
  }
  
  if let showBG = UserDefaults.standard.value(forKey: "showBG") as? Bool {
    ShowBG = showBG
  }
  
//  if let moreLevels = UserDefaults.standard.value(forKey: "morelevels2Purchased") as? Bool {
//    MoreLevelsPurchased = moreLevels
//  }
//  
//  if let fifthColor = UserDefaults.standard.value(forKey: "fifthcolor2Purchased") as? Bool {
//    FifthColorPurchased = fifthColor
//  }
    
  MoreLevelsPurchased = true
  FifthColorPurchased = true
  NextPiecePurchased = true
//  if let nextPiece = UserDefaults.standard.value(forKey: "shownextpiece2Purchased") as? Bool {
//    NextPiecePurchased = nextPiece
//  }
  
  if let showNextPiece = UserDefaults.standard.value(forKey: "showNextPiece") as? Bool {
    ShowNextPiece = showNextPiece
  }
}

func purchaseAll() {
  UserDefaults.standard.set(true, forKey: "shownextpiecePurchased")
  UserDefaults.standard.set(true, forKey: "fifthcolorPurchased")
  UserDefaults.standard.set(true, forKey: "morelevelPurchased")
}
