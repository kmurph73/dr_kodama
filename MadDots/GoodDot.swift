//
//  GoodDot.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/5/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

enum Side: CustomStringConvertible {
  
  case left, right, top, bottom
  
  var sideName: String {
    switch self {
    case .left:
      return "left"
    case .right:
      return "right"
    case .top:
      return "top"
    case .bottom:
      return "bottom"
    }
  }
  
  var description: String {
    return self.sideName
  }
}

class GoodDot: Dot {
  var connector: SKShapeNode?
  weak var sibling: GoodDot?
  
  func sideOfSibling() -> Side? {
    if let s = self.sibling {
      if s.row > self.row {
        return .bottom
      } else if s.row < self.row {
        return .top
      } else if s.column < self.column {
        return .left
      } else {
        return .right
      }
    } else {
      return nil
    }
  }
  
  override func removeFromScene() {
    self.connector?.removeFromParent()

    super.removeFromScene()
  }
  
  override var spriteName: String {
    return super.spriteName + "dot"
  }
  
  deinit {
//    print("GoodDot: \(self) was deinitialized")
  }
}
