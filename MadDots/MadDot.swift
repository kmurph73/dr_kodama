//
//  MadDot.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

class MadDot: Dot {
  override init(column:Int, row:Int, color:DotColor) {
    super.init(column: column,row: row,color: color)
  }
  
  override var spriteName: String {
    return super.spriteName + "maddot"
  }
}