//
//  Dot.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

//import Foundation

//
//  Block.swift
//  Swiftris
//
//  Created by Stan Idesis on 7/18/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 4

enum DotColor: Int, CustomStringConvertible {
  
  case Red = 0, Green, Blue, Yellow
  
  var spriteName: String {
    switch self {
    case .Red:
      return "red"
    case .Green:
      return "green"
    case .Blue:
      return "blue"
    case .Yellow:
      return "yellow"
    }
  }
  
  var description: String {
    return self.spriteName
  }
  
  static func random() -> DotColor {
    return DotColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
  }
}

class Dot: Hashable, CustomStringConvertible {
  // Constants
  let color: DotColor
  
  // Variables
  var column: Int
  var row: Int
  
  // Lazy loading
  var sprite: SKSpriteNode?

  var spriteName: String {
    return color.description
  }
  
  var hashValue: Int {
    return self.column ^ self.row
  }
  
  var description: String {
    return "\(color) (\(column), \(row))"
  }
  
  init(column:Int, row:Int, color:DotColor) {
    self.column = column
    self.row = row
    self.color = color
  }
  
  deinit {
//    print("\(self) is being deinitialized")
  }
  
}

func ==(lhs: Dot, rhs: Dot) -> Bool {
  return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
