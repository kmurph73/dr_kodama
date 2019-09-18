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
  
  var description: String {
    return self.spriteName
  }
  
  static func random() -> DotColor {
    return DotColor(rawValue:Int(arc4random_uniform(UInt32(NumberOfColors))))!
  }
}

class Dot: Hashable, CustomStringConvertible {
  // Constants
  let color: DotColor
  
  weak var piece: Piece?

  var column: Int
  var row: Int
  
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
  
  func removeFromScene() {
    self.sprite?.removeFromParent()
  }
    
  static func createSprite(dot: Dot, texture: SKTexture) -> SKSpriteNode {
    let sprite = SKSpriteNode(texture: texture)
  
    let dotSize = BlockSize - 5
    
    var point: CGPoint;
    
    point = points![dot.column, dot.row]!.point
  
    sprite.xScale = dotSize
    sprite.yScale = dotSize
    sprite.size = CGSize(width: dotSize, height: dotSize)
    sprite.zPosition = 5
    sprite.position = point
    dot.sprite = sprite
    
    return sprite
  }
  
  deinit {
//    print("\(self) is being deinitialized")
  }
  
}

func ==(lhs: Dot, rhs: Dot) -> Bool {
  return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
