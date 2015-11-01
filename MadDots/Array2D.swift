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
      return array[(row * columns) + column]
    }
    
    set(newValue) {
      array[(row * columns) + column] = newValue
    }
  }
  
  var description: String {
    var desc = ""
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let line = self[col,row] as? Dot {
          desc += "\(line.color.spriteName.characters.first!),"
        } else {
          desc += "X,"
          
        }
      }
      desc += "\n"
    }
    
    return desc
  }
}