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
  
  if let showNextPiece = UserDefaults.standard.value(forKey: "showNextPiece") as? Bool {
    ShowNextPiece = showNextPiece
  }
  
  if let showNextNextPiece = UserDefaults.standard.value(forKey: "showNextNextPiece") as? Bool {
    ShowNextNextPiece = showNextNextPiece
  }
}
