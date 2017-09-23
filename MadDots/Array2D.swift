//
//  Array2D.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

class Array2D<T> {
  let columns: Int
  let rows: Int
  var array: Array<T?>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(repeating: nil, count: rows * columns)
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
  
  deinit {
//    print("dotArray is being deinitialized")
  }
  
}
