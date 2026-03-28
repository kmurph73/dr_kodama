//
//  Globals.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/31/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

var GameLevel = 1
var GameSpeed = 5
var NumberOfColors = 4
var ShowBG = false
var ShowNextPiece = false
var AngryKodama = false

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
  
//  if let showBG = UserDefaults.standard.value(forKey: "showBG") as? Bool {
//    ShowBG = showBG
//  }
  
  if let showNextPiece = UserDefaults.standard.value(forKey: "showNextPiece") as? Bool {
    ShowNextPiece = showNextPiece
  }
  
  if let angryKodama = UserDefaults.standard.value(forKey: "angryKodama") as? Bool {
    AngryKodama = angryKodama
  }
  
//  if let angryIntervalDefault = UserDefaults.standard.value(forKey: "angryIntervalDefault") as? Int {
//    AngryIntervalDefault = angryIntervalDefault
//  }
//
//  if let angryLengthDefault = UserDefaults.standard.value(forKey: "angryLengthDefault") as? Int {
//    AngryLengthDefault = angryLengthDefault
//  }
}
