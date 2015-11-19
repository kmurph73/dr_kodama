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
  
  var dotArray: Array2D<Dot>
  
  func randomNum(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max))) + min
  }
  
  init(dotArray: Array2D<Dot>) {
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
    
    let offset = GameLevel > 5 ? GameLevel > 10 ? 4 : 5 : 6
    
    while totalMadDots > 0 {
      if insertRandomDot(offset) {
        totalMadDots -= 1
      }
    }
    
    return self.madDots
  }

  func makeLevel(levelNumber:  Int) -> Array<MadDot> {
    self.madDots = Array<MadDot>()
    let level = levels[levelNumber]!
    var totalMadDots = level.totalMadDots
    
    if let levelRows = level.rows {
      let sortedKeys = levelRows.keys.sort()
      
      for num in sortedKeys {
        if let rowLevel = levelRows[num] {
          let rowNum = NumRows - num
          var numDotsRequiredForRow = randomNum(rowLevel.min, max: rowLevel.max)
          totalMadDots = totalMadDots - numDotsRequiredForRow
          
          for col in 0..<NumColumns {
            if placeRandomDot(col, rowNum: rowNum) {
              numDotsRequiredForRow -= 1
            }
          }
          
          if numDotsRequiredForRow > 1 {
            fillInDotsForRow(numDotsRequiredForRow, rowNum: rowNum)
          } else {
            removeDotsForRow(numDotsRequiredForRow, rowNum: rowNum)
          }
        }
      }
    }
    
    while totalMadDots > 0 {
      if insertRandomDot(level) {
        totalMadDots -= 1
      }
    }
    
    return self.madDots
  }
  
  let levels = [
    1: Level(level: 1, totalMadDots: 4, rows: nil, maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 1)),
    2: Level(level: 2, totalMadDots: 6, rows: nil, maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 2)),
    3: Level(level: 3, totalMadDots: 9, rows: rowReqs[3], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 2)),
    4: Level(level: 4, totalMadDots: 12, rows: rowReqs[4], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 3)),
    5: Level(level: 5, totalMadDots: 15, rows: rowReqs[5], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 3)),
    6: Level(level: 6, totalMadDots: 18, rows: rowReqs[6], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 4)),
    7: Level(level: 7, totalMadDots: 21, rows: rowReqs[7], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 4)),
    8: Level(level: 8, totalMadDots: 24, rows: rowReqs[8], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 5)),
    9: Level(level: 9, totalMadDots: 27, rows: rowReqs[9], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 6)),
    10: Level(level: 10, totalMadDots: 30, rows: rowReqs[10], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 7)),
    11: Level(level: 11, totalMadDots: 32, rows: rowReqs[11], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 8)),
    12: Level(level: 12, totalMadDots: 35, rows: rowReqs[11], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 8)),
    13: Level(level: 13, totalMadDots: 38, rows: rowReqs[12], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: 8)),
    14: Level(level: 14, totalMadDots: 41, rows: rowReqs[12], maxRows: NumRows - 5, everyRow: LevelRow(min: 0, max: NumColumns - 1)),
    15: Level(level: 15, totalMadDots: 44, rows: rowReqs[13], maxRows: NumRows - 4, everyRow: LevelRow(min: 0, max: NumColumns)),
    16: Level(level: 16, totalMadDots: 47, rows: rowReqs[13], maxRows: NumRows - 4, everyRow: LevelRow(min: 0, max: NumColumns)),
    17: Level(level: 17, totalMadDots: 50, rows: rowReqs[14], maxRows: NumRows - 4, everyRow: LevelRow(min: 0, max: NumColumns)),
    18: Level(level: 18, totalMadDots: 53, rows: rowReqs[14], maxRows: NumRows - 4, everyRow: LevelRow(min: 0, max: NumColumns))
  ]
  
}

let rowReqs = [
  3: [1: LevelRow(min: 1, max: 3)],
  4: [1: LevelRow(min: 1, max: 4)],
  5: [1: LevelRow(min: 2, max: 5)],
  6: [1: LevelRow(min: 2, max: 5), 2: LevelRow(min: 2, max: 5)],
  7: [1: LevelRow(min: 2, max: 6), 2: LevelRow(min: 2, max: 7)],
  8: [1: LevelRow(min: 2, max: NumColumns - 4), 2: LevelRow(min: 2, max: 5)],
  9: [1: LevelRow(min: 4, max: NumColumns - 3), 2: LevelRow(min: 2, max: 7)],
  10: [1: LevelRow(min: 2, max: NumColumns - 2), 2: LevelRow(min: 2, max: 6)],
  11: [1: LevelRow(min: 2, max: NumColumns - 2), 2: LevelRow(min: 2, max: 7)],
  12: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: 7)],
  13: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: 7)],
  14: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: 8)],
  15: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: 8)],
  16: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: 8)],
  17: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: 8)],
  18: [1: LevelRow(min: 4, max: NumColumns - 1), 2: LevelRow(min: 2, max: NumColumns - 1)]
]

func setDot(arr: Array2D<Dot>, dot: Dot) {
  arr[dot.column,dot.row] = dot
}

func setPiece(arr: Array2D<Dot>, piece: Piece) {
  setDot(arr, dot: piece.leftDot)
  setDot(arr, dot: piece.rightDot)
}

func testScenario() -> (array:Array2D<Dot>, pieces: Array<Piece>) {
  let arr = Array2D<Dot>(columns: NumColumns, rows: NumRows)
  var seq = Array<Piece>()
  
  let dot1 = GoodDot(column: 4, row: NumRows - 7, color: .Red, side: .Left)
  let dot2 = GoodDot(column: 3, row: NumRows - 7, color: .Red, side: .Right)
  dot1.sibling = dot2
  dot2.sibling = dot1
  
  setDot(arr, dot: dot1)
  setDot(arr, dot: dot2)
  
  let dot3 = GoodDot(column: 1, row: NumRows - 1, color: .Yellow, side: .Left)
  let dot4 = GoodDot(column: 1, row: NumRows - 2, color: .Yellow, side: .Right)
  let dot5 = GoodDot(column: 1, row: NumRows - 3, color: .Yellow, side: .Left)
  let dot6 = GoodDot(column: 1, row: NumRows - 4, color: .Blue, side: .Left)
  
  setDot(arr, dot: dot3)
  setDot(arr, dot: dot4)
  setDot(arr, dot: dot5)
  setDot(arr, dot: dot6)
  
  seq.appendContentsOf([
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .Yellow, rightColor: .Yellow)
  ])
  
  return (array:arr, pieces: seq)
}
