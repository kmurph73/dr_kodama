//
//  Array2D.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

class Array2D<T>: CustomStringConvertible {
  let columns: Int
  let rows: Int
  var array: Array<T?>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(count:rows * columns, repeatedValue: nil)
  }
  
  subscript(column: Int, row: Int) -> T? {
    get {
      if row >= NumRows || column >= NumColumns {
        return nil
      } else {
        return array[(row * columns) + column]
      }
    }
    
    set(newValue) {
      array[(row * columns) + column] = newValue
    }
  }
  
  func countMadDots() -> Int {
    var cnt = 0
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let _ = self[col,row] as? MadDot {
          cnt += 1
        }
      }
    }
    
    return cnt
  }
  
  func removeDotsFromScene() {
    for thing in array {
      if let dot = thing as? Dot {
        dot.removeFromScene()
      }
    }
  }
  
  func removePiece(piece: Piece) {
    removeDot(piece.leftDot)
    removeDot(piece.rightDot)
  }
  
  func removeDot(dot: Dot) {
    self[dot.column, dot.row] = nil
  }
  
  func hasAchievedVictory() -> Bool {
    var madDotCount = 0
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let _ = self[col,row] as? MadDot {
          madDotCount += 1
        }
      }
    }
    
    return madDotCount == 0
  }
  
  var description: String {
    var desc = ""
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let line = self[col,row] as? Dot {
          let color = "\(line.color.spriteName.characters.first!),"
          if let _ = line as? MadDot {
            desc += "m\(color)"
          } else if let dot = line as? GoodDot {
            if let s = dot.sibling {
              let abbrev = dot.side == .Left ? "l" : "r"
              desc += "\(abbrev)\(color)"
            } else {
              desc += " \(color)"
            }
          }

        } else {
          desc += " X,"
        }
      }
      desc += "\n"
    }
    
    return desc
  }
  
  deinit {
    print("dotArray is being deinitialized")
  }
  
}