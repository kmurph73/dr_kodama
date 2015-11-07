//
//  GameLevels.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

struct Level {
  var level: Int
  var totalMadDots: Int
  var rows: [Int: LevelRow]?
  var maxRows: Int
  var everyRow: LevelRow?
}

struct LevelRow {
  var min: Int
  var max: Int
}

class LevelMaker {
  var level: Level
  var totalMadDots: Int
  
  func randomNum(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max))) + min
  }
  
  init(level:Level) {
    self.level = level
    self.totalMadDots = level.totalMadDots
  }
  
  func getRowNum(row:Int) {
    NumRows - row
  }
  
  func randomColor() {
    
  }

  func makeLevel(level: Level, dotGame: DotGame) -> Array2D<Dot> {
    let arr = dotGame.dotArray
    
    if let rows = level.rows {
      let sortedKeys = rows.keys.sort()
      
      for num in sortedKeys {
        if let row = rows[num] {
          let rowNum = NumRows - num
          var randNum = randomNum(row.min, max: row.max)
          var sparseArr = Array<MadDot?>(count: NumColumns, repeatedValue: nil)
          
          for col in 0...NumColumns {
            let rn = randomNum(0, max: 4)
            if rn != 4 {
              sparseArr[]
              arr[col, rowNum] = MadDot(column: col, row: rowNum, color: DotColor.random())
            }
          }
        }
      }
    }
    
    return arr
  }
  
  let levels = [
    1: Level(level: 1, totalMadDots: 4, rows: nil, maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 1))
  ]
}