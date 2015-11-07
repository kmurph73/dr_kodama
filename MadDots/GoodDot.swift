//
//  GoodDot.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/5/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

enum Side: CustomStringConvertible {
  
  case Left, Right, Top, Bottom
  
  var sideName: String {
    switch self {
    case .Left:
      return "left"
    case .Right:
      return "right"
    case .Top:
      return "top"
    case .Bottom:
      return "bottom"
    }
  }
  
  var description: String {
    return self.sideName
  }
}

class GoodDot: Dot {
  var connector: SKSpriteNode?
  weak var sibling: GoodDot?
  
  var side: Side?
  
  init(column:Int, row:Int, color:DotColor, side:Side) {
    self.side = side
    super.init(column: column,row: row,color: color)
  }
  
  func sideOfSibling() -> Side? {
    if let s = self.sibling {
      if s.row > self.row {
        return .Bottom
      } else if s.row < self.row {
        return .Top
      } else if s.column < self.column {
        return .Left
      } else {
        return .Right
      }
    } else {
      return nil
    }
  }
}