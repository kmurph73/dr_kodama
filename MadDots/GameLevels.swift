//
//  GameLevels.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

class LevelMaker {
  var totalMadDots: Int?
  var madDots: Array<MadDot>
  
  var dotArray: DotArray2D
  
  init(dotArray: DotArray2D) {
    self.dotArray = dotArray
    self.madDots = Array<MadDot>()
  }
  
  fileprivate func appendRandomDot(_ row: Int, col:Int) {
    let md = MadDot(column: col, row: row, color: DotColor.random())
    dotArray[col, row] = md
    self.madDots.append(md)
  }
  
  func insertRandomDot(_ offset:Int) -> Bool {
    let randRow = randomNum(offset, max: NumRows - offset)
    let randCol = randomNum(0, max: NumColumns)
    
    if let _ = dotArray[randCol, randRow] as? MadDot {
      return false
    } else {
      appendRandomDot(randRow, col: randCol)
      return true
    }

  }
  
  func makeRandomLevel(_ levelNumber: Int) -> Array<MadDot> {
    self.madDots = Array<MadDot>()
    var totalMadDots = levelNumber * 3
//    var totalMadDots = 1
    let offset = GameLevel > 5 ? GameLevel > 10 ? 6 : 7 : 8
    
    while true {
      while totalMadDots > 0 {
        if insertRandomDot(offset) {
          totalMadDots -= 1
        }
      }
      
      let results = findAllChains(dotArray)
      if results.count > 0 {
        for d in results {
          dotArray.rmDot(d)
        }
        totalMadDots += results.count
        self.madDots = self.madDots.filter({ (dot) in !results.contains(dot) })
      } else {
        break
      }
    }
    
//    self.madDots[0].angry = true
    
    return self.madDots
  }
  
}

