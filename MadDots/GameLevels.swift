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
  var totalMadDots: Int?
  var madDots: Array<MadDot>
  
  var dotArray: DotArray2D
  
  func randomNum(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max))) + min
  }
  
  init(dotArray: DotArray2D) {
    self.dotArray = dotArray
    self.madDots = Array<MadDot>()
  }
  
  func getRowNum(row:Int) {
    NumRows - row
  }
  
  func placeRandomDot(col: Int, rowNum: Int) -> Bool {
    let randNum = randomNum(0, max: 5)
    if randNum == 4 {
      return false
    } else {
      while true {
        appendRandomDot(rowNum, col: col)
        
        if !columnHasChain(dotArray, column: col) {
          return true
        }
      }
    }
  }
  
  func fillInDotsForRow(var numDotsRequiredForRow:Int, rowNum: Int) {
    while numDotsRequiredForRow > 0 {
      let randColumn = randomNum(0, max: NumColumns)
      if dotArray[randColumn, rowNum] == nil {
        if placeRandomDot(randColumn, rowNum: rowNum) {
          numDotsRequiredForRow -= 1
        }
      }
    }
  }
  
  func removeDotsForRow(var numDotsRequiredForRow: Int, rowNum: Int) {
    while numDotsRequiredForRow < 0 {
      let randColumn = randomNum(0, max: NumColumns)
      
      if let dot = dotArray[randColumn, rowNum] as? MadDot {
        dotArray[randColumn, rowNum] = nil
        if let index = madDots.indexOf(dot) {
          madDots.removeAtIndex(index)
        }
        numDotsRequiredForRow += 1
      }
    }
  }
  
  func dotCountForRow(rowNum: Int) -> Int {
    var cnt = 0
    for column in 0...NumColumns {
      if let _ = dotArray[column, rowNum] {
        cnt += 1
      }
    }
    
    return cnt
  }
  
  private func appendRandomDot(row: Int, col:Int) {
    let md = MadDot(column: col, row: row, color: DotColor.random())
    dotArray[col, row] = md
    self.madDots.append(md)
  }
  
  func insertRandomDot(level: Level) -> Bool {
    let randRow = randomNum(0, max: level.maxRows) + (NumRows - level.maxRows)
    let randCol = randomNum(0, max: NumColumns)
    
    if let everyRow = level.everyRow {
      if let _ = dotArray[randCol, randRow] as? MadDot {
        return false
      } else {
        if let rows = level.rows, row = rows[randRow] {
          if dotCountForRow(randRow) < row.max {
            appendRandomDot(randRow, col: randCol)
            
            return true
          }
          
        } else if dotCountForRow(randRow) < everyRow.max {
          appendRandomDot(randRow, col: randCol)
          
          return true
        }
      }
    }
    
    return false
  }
  
  func insertRandomDot(offset:Int) -> Bool {
    let randRow = randomNum(offset, max: NumRows - offset)
    let randCol = randomNum(0, max: NumColumns)
    
    if let _ = dotArray[randCol, randRow] as? MadDot {
      return false
    } else {
      appendRandomDot(randRow, col: randCol)
      return true
    }

  }
  
  func makeRandomLevel(levelNumber: Int) -> Array<MadDot> {
    self.madDots = Array<MadDot>()
    var totalMadDots = levelNumber * 3
    
    let offset = GameLevel > 5 ? GameLevel > 10 ? 6 : 7 : 8
    
    while true {
      print("makeRandomLevel")
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
    
    return self.madDots
  }
  
  deinit {
//    print("levelmaker was deinitialized")
  }
}

func testScenario() -> (array:DotArray2D, pieces: Array<Piece>) {
  let arr = DotArray2D(columns: NumColumns, rows: NumRows)
  var seq = Array<Piece>()
  
  let dot1 = GoodDot(column: 4, row: NumRows - 7, color: .Red)
  let dot2 = GoodDot(column: 3, row: NumRows - 7, color: .Red)
  dot1.sibling = dot2
  dot2.sibling = dot1
  
  arr.setDot(dot1)
  arr.setDot(dot2)
  
  let dot3 = GoodDot(column: 1, row: NumRows - 1, color: .Yellow)
  let dot4 = GoodDot(column: 1, row: NumRows - 2, color: .Yellow)
  let dot5 = GoodDot(column: 1, row: NumRows - 3, color: .Yellow)
  let dot6 = GoodDot(column: 1, row: NumRows - 4, color: .Blue)
  
  arr.setDot(dot3)
  arr.setDot(dot4)
  arr.setDot(dot5)
  arr.setDot(dot6)
  
  for col in 0..<NumColumns {
    let color: DotColor = col % 2 == 0 ? .Yellow : .Blue
    arr.setDot(GoodDot(column: col, row: 5, color: color))
  }

  arr.setDot(MadDot(column: 3, row: NumRows - 1, color: .Blue))

  seq.appendContentsOf([
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow)
  ])
  
  return (array:arr, pieces: seq)
}

func testScenario2() -> (array:DotArray2D, pieces: Array<Piece>) {
  let arr = DotArray2D(columns: NumColumns, rows: NumRows)
  var seq = Array<Piece>()
  
  let dot1 = GoodDot(column: 4, row: NumRows - 7, color: .Red)
  let dot2 = GoodDot(column: 3, row: NumRows - 7, color: .Red)
  dot1.sibling = dot2
  dot2.sibling = dot1
  
  arr.setDot(dot1)
  arr.setDot(dot2)
  
  let dot3 = GoodDot(column: 1, row: NumRows - 1, color: .Yellow)
  let dot4 = GoodDot(column: 1, row: NumRows - 2, color: .Yellow)
  let dot5 = GoodDot(column: 1, row: NumRows - 3, color: .Yellow)
  let dot6 = GoodDot(column: 1, row: NumRows - 4, color: .Blue)
  
  arr.setDot(dot3)
  arr.setDot(dot4)
  arr.setDot(dot5)
  arr.setDot(dot6)
  
  for col in 0..<NumColumns {
    let color: DotColor = col % 2 == 0 ? .Yellow : .Blue
    arr.setDot(GoodDot(column: col, row: 5, color: color))
  }
  
  arr.setDot(MadDot(column: 3, row: NumRows - 1, color: .Blue))
  
  seq.appendContentsOf([
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow)
    ])
  
  return (array:arr, pieces: seq)
}
