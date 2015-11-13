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
  
  var description: String {
    var desc = ""
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let line = self[col,row] as? Dot {
          let color = "\(line.color.spriteName.characters.first!),"
          if let _ = line as? MadDot {
            desc += "m\(color)"
          } else {
            desc += color
          }

        } else {
          desc += "X,"
        }
      }
      desc += "\n"
    }
    
    return desc
  }
}