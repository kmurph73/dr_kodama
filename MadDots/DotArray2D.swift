//
//  DotArray2D.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/5/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

class DotArray2D: Array2D<Dot>, CustomStringConvertible {
  override init(columns: Int, rows: Int) {
    super.init(columns: columns, rows: rows)
  }
  
  var description: String {
    var desc = "\n"
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let line = self[col,row] {
          let color = "\(line.color.spriteName.first!),"
          if let _ = line as? MadDot {
            desc += "m\(color)"
          } else if let dot = line as? GoodDot {
            if let _ = dot.sibling {
              desc += "\(color)"
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
  
  
  func removeDotsFromScene() {
    for thing in array {
      if let dot = thing {
        dot.removeFromScene()
      }
    }
  }
  
  func hasDotsAboveGrid() -> Bool {
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let dot = self[col,row] {
          if dot.row < 3 {
            return true
          }
        }
      }
    }
    
    return false
  }
  
  func removePiece(_ piece: Piece) {
    removeDot(piece.dot1)
    removeDot(piece.dot2)
  }
  
  func removeDot(_ dot: Dot) {
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
  
  func rmDot(_ dot: Dot) {
    self[dot.column, dot.row] = nil
  }
  
  
  func setDot(_ dot: Dot) {
    self[dot.column,dot.row] = dot
  }
  
  func setPiece(_ piece: Piece) {
    setDot(piece.dot1)
    setDot(piece.dot2)
  }
}
