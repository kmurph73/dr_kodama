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
  
  func randomNum(_ min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max))) + min
  }
  
  init(dotArray: DotArray2D) {
    self.dotArray = dotArray
    self.madDots = Array<MadDot>()
  }
  
  func getRowNum(row: Int) {
    NumRows - row
  }
  
  func placeRandomDot(_ col: Int, rowNum: Int) -> Bool {
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
  
  func fillInDotsForRow(_ numDotsRequiredForRow:Int, rowNum: Int) {
    var numDotsRequiredForRow = numDotsRequiredForRow
    while numDotsRequiredForRow > 0 {
      let randColumn = randomNum(0, max: NumColumns)
      if dotArray[randColumn, rowNum] == nil {
        if placeRandomDot(randColumn, rowNum: rowNum) {
          numDotsRequiredForRow -= 1
        }
      }
    }
  }
  
  func removeDotsForRow(_ numDotsRequiredForRow: Int, rowNum: Int) {
    var numDotsRequiredForRow = numDotsRequiredForRow
    while numDotsRequiredForRow < 0 {
      let randColumn = randomNum(0, max: NumColumns)
      
      if let dot = dotArray[randColumn, rowNum] as? MadDot {
        dotArray[randColumn, rowNum] = nil
        if let index = madDots.index(of: dot) {
          madDots.remove(at: index)
        }
        numDotsRequiredForRow += 1
      }
    }
  }
  
  func dotCountForRow(_ rowNum: Int) -> Int {
    var cnt = 0
    for column in 0...NumColumns {
      if let _ = dotArray[column, rowNum] {
        cnt += 1
      }
    }
    
    return cnt
  }
  
  fileprivate func appendRandomDot(_ row: Int, col:Int) {
    let md = MadDot(column: col, row: row, color: DotColor.random())
    dotArray[col, row] = md
    self.madDots.append(md)
  }
  
  func insertRandomDot(_ level: Level) -> Bool {
    let randRow = randomNum(0, max: level.maxRows) + (NumRows - level.maxRows)
    let randCol = randomNum(0, max: NumColumns)
    
    if let everyRow = level.everyRow {
      if let _ = dotArray[randCol, randRow] as? MadDot {
        return false
      } else {
        if let rows = level.rows, let row = rows[randRow] {
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

func siblingizeLastTwo(_ arr: Array<GoodDot>) {
  if let last = arr.last {
    let secondlast = arr[arr.endIndex - 2]
    last.sibling = secondlast; secondlast.sibling = last
  }
}

func testScenario() -> (array:DotArray2D, pieces: Array<Piece>) {
  let arr = DotArray2D(columns: NumColumns, rows: NumRows)
  var seq = Array<Piece>()
  var dots = Array<GoodDot>()
  
//  let dot1 = GoodDot(column: 4, row: NumRows - 7, color: .Red)
//  let dot2 = GoodDot(column: 3, row: NumRows - 7, color: .Red)
//  dot1.sibling = dot2
//  dot2.sibling = dot1
//  
//  arr.setDot(dot1)
//  arr.setDot(dot2)
  
  let column = 2
  dots.append(GoodDot(column: column, row: NumRows - 1, color: .yellow))
  dots.append(GoodDot(column: column, row: NumRows - 2, color: .yellow))
  dots.append(GoodDot(column: column, row: NumRows - 3, color: .yellow))
  dots.append(GoodDot(column: column - 1, row: NumRows - 3, color: .yellow))

  siblingizeLastTwo(dots)
  
  dots.append(GoodDot(column: column, row: NumRows - 4, color: .blue))

  dots.append(GoodDot(column: column, row: NumRows - 5, color: .blue))
  dots.append(GoodDot(column: column - 1, row: NumRows - 5, color: .blue))
  
  siblingizeLastTwo(dots)
  for dot in dots { arr.setDot(dot) }
  
//  for col in 0..<NumColumns {
//    let color: DotColor = col % 2 == 0 ? .Yellow : .Blue
//    arr.setDot(GoodDot(column: col, row: 5, color: color))
//  }

  arr.setDot(MadDot(column: 3, row: NumRows - 1, color: .blue))
  
  seq.append(contentsOf: [
    Piece(column: StartingColumn, row: StartingRow, leftColor: .green, rightColor: .green),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .green, rightColor: .green),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .green, rightColor: .green),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow)
  ])
  
  return (array:arr, pieces: seq)
}

func testScenario2() -> (array:DotArray2D, pieces: Array<Piece>) {
  let arr = DotArray2D(columns: NumColumns, rows: NumRows)
  var seq = Array<Piece>()
  
  let dot1 = GoodDot(column: 4, row: NumRows - 7, color: .red)
  let dot2 = GoodDot(column: 3, row: NumRows - 7, color: .red)
  dot1.sibling = dot2
  dot2.sibling = dot1
  
  arr.setDot(dot1)
  arr.setDot(dot2)
  
  let dot3 = GoodDot(column: 1, row: NumRows - 1, color: .yellow)
  let dot4 = GoodDot(column: 1, row: NumRows - 2, color: .yellow)
  let dot5 = GoodDot(column: 1, row: NumRows - 3, color: .yellow)
  let dot6 = GoodDot(column: 1, row: NumRows - 4, color: .blue)
  
  arr.setDot(dot3)
  arr.setDot(dot4)
  arr.setDot(dot5)
  arr.setDot(dot6)
  
  for col in 0..<NumColumns {
    let color: DotColor = col % 2 == 0 ? .yellow : .blue
    arr.setDot(GoodDot(column: col, row: 5, color: color))
  }
  
  arr.setDot(MadDot(column: 3, row: NumRows - 1, color: .blue))
  
  seq.append(contentsOf: [
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow)
    ])
  
  return (array:arr, pieces: seq)
}

func testScenario3() -> (array:DotArray2D, pieces: Array<Piece>) {
  let arr = DotArray2D(columns: NumColumns, rows: NumRows)
  var seq = Array<Piece>()
  var dots = Array<GoodDot>()
  
  let dot7 = GoodDot(column: 3, row: NumRows - 7, color: .yellow)
  let dot8 = GoodDot(column: 3, row: NumRows - 8, color: .yellow)
  let dot9 = GoodDot(column: 3, row: NumRows - 9, color: .yellow)
  
  let reddot7 = GoodDot(column: 4, row: NumRows - 7, color: .red)
  let reddot9 = GoodDot(column: 4, row: NumRows - 9, color: .red)
  
  let reddot1 = GoodDot(column: 4, row: NumRows - 1, color: .red)
  let reddot2 = GoodDot(column: 4, row: NumRows - 2, color: .red)
  let reddot3 = GoodDot(column: 4, row: NumRows - 3, color: .red)
  
  arr.setDot(reddot1)
  arr.setDot(reddot2)
  arr.setDot(reddot3)
  
  arr.setDot(reddot7)
  arr.setDot(reddot9)
  
  dot7.sibling = reddot7
  dot9.sibling = reddot9
  
  arr.setDot(MadDot(column: 1, row: NumRows - 1, color: .blue))
//  array.setDot(dot6)
  arr.setDot(dot7)
  arr.setDot(dot8)
  arr.setDot(dot9)
  
  seq.append(contentsOf: [
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow),
    Piece(column: StartingColumn, row: StartingRow, leftColor: .yellow, rightColor: .yellow)
    ])
  
  return (array:arr, pieces: seq)
}
