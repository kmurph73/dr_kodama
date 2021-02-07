//
//  Dot.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

enum DotColor: Int, CustomStringConvertible {
  
  case red = 0, green, blue, yellow, orange
  
  var spriteName: String {
    switch self {
    case .red:
      return "red"
    case .green:
      return "green"
    case .blue:
      return "blue"
    case .yellow:
      return "yellow"
    case .orange:
      return "orange"
    }
  }
  
  var uiColor: UIColor {
    switch self {
    case .red:
      return UIColor.red
    case .green:
      return UIColor.green
    case .blue:
      return UIColor.blue
    case .yellow:
      return UIColor.yellow
    case .orange:
      return UIColor.orange
    }
  }
  
  var description: String {
    return self.spriteName
  }
  
  static func random() -> DotColor {
    return DotColor(rawValue:Int(arc4random_uniform(UInt32(NumberOfColors))))!
  }
}

class Dot: Hashable, CustomStringConvertible {
  let color: DotColor
  
  var column: Int
  var row: Int
  
  var sprite: SKShapeNode?

  var spriteName: String {
    return color.description
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(column)
    hasher.combine(row)
  }
  
  var description: String {
    return "\(color) (\(column), \(row))"
  }
  
  init(column:Int, row:Int, color:DotColor) {
    self.column = column
    self.row = row
    self.color = color
  }
  
  func removeFromScene() {
    self.sprite?.removeFromParent()
  }
}

func ==(lhs: Dot, rhs: Dot) -> Bool {
  return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
