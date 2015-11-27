//
//  Piece.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

enum Orientation: Int, CustomStringConvertible {
  case Vertical, Horizontal
  
  var name: String {
    switch self {
    case .Vertical:
      return "vertical"
    case .Horizontal:
      return "horizontal"
    }
  }
  
  var description: String {
    return self.name
  }
}

class Rotation {
  var dots: [GoodDot]
  var translations: Array<(columnDiff: Int, rowDiff: Int)>
  
  init(dots: [GoodDot], translations: Array<(columnDiff: Int, rowDiff: Int)>) {
    self.dots = dots
    self.translations = translations
  }
  
  func undo() {
    for (idx,dot) in self.dots.enumerate() {
      let translation = translations[idx]
      dot.row += translation.rowDiff * -1
      dot.column += translation.columnDiff * -1
    }
  }
  
}

class Piece: CustomStringConvertible {
  // The column and row representing the shape's anchor point
//  var column, row:Int
  
  var dot1, dot2: GoodDot
  
  var previousRotation: Rotation?
  
  init(column:Int, row:Int, leftColor: DotColor, rightColor: DotColor) {
    self.dot1 = GoodDot(column: column, row: row, color: leftColor)
    self.dot2 = GoodDot(column: column + 1, row: row, color: rightColor)
    self.dot1.sibling = dot2
    self.dot2.sibling = dot1
  }
  
  var dots: [GoodDot] {
    get {
      if let ldot = self.leftDot, let rdot = self.rightDot {
        return [ldot, rdot]
      } else if let bdot = self.bottomDot, let tdot = self.topDot {
        return [tdot, bdot]
      } else {
        return []
      }
    }
  }
  
  var previousDots: [GoodDot]?
  
  var bottomDot: GoodDot? {
    get {
      return dot1.row == dot2.row ? nil : dot1.row > dot2.row ? dot1 : dot2
    }
  }
  
  var topDot: GoodDot? {
    get {
      return dot1.row == dot2.row ? nil : dot1.row < dot2.row ? dot1 : dot2
    }
  }
  
  var leftDot: GoodDot? {
    get {
      return dot1.column == dot2.column ? nil : dot1.column < dot2.column ? dot1 : dot2
    }
  }
  
  var rightDot: GoodDot? {
    get {
      return dot1.column == dot2.column ? nil : dot1.column > dot2.column ? dot1 : dot2
    }
  }
  
  var bottomDots: Array<Dot> {
    if let ldot = self.leftDot, let rdot = self.rightDot {
      return [ldot,rdot]
    } else if let bdot = self.bottomDot {
      return [bdot]
    }
    
    return []
  }
  
  var orientation: Orientation {
    get {
      return self.leftDot == nil ? .Vertical : .Horizontal
    }
  }
  
  var description: String {
    return "piece: \(dot1), \(dot2)"
  }
  
  final func lowerByOneRow() {
    shiftBy(0, rows:1)
  }
  
  final func raiseByOneRow() {
    shiftBy(0, rows:-1)
  }
  
  final func shiftRightByOneColumn() {
    shiftBy(1, rows:0)
  }
  
  final func shiftLeftByOneColumn() {
    shiftBy(-1, rows:0)
  }
  
  final func shiftBy(columns: Int, rows: Int) {
    for dot in dots {
      dot.column += columns
      dot.row += rows
    }
  }
  
  func checkBlockage(dotArray: Array2D<Dot>) -> (blockedOnRight: Bool, blockedOnTop: Bool) {
    var rightIsBlocked = false
    var topIsBlocked = false
    
    if let rdot = self.rightDot, let ldot = self.leftDot {
      let isOnTop = ldot.row == 0 && rdot.row == 0
//      let isOnBottom = ldot.row == NumRows - 1
      
      if isOnTop {
        topIsBlocked = true
      } else {
        topIsBlocked = dotArray[ldot.column, rdot.row - 1] != nil
      }
    } else if let bdot = self.bottomDot {
      let isOnRightEdge = bdot.column == NumColumns - 1
      
      if isOnRightEdge {
        rightIsBlocked = true
      } else {
        rightIsBlocked = dotArray[bdot.column + 1, bdot.row] != nil
      }
    }

    return (blockedOnRight: rightIsBlocked, blockedOnTop: topIsBlocked)
  }
  
  func getCounterClockwisePositionFor(dotArray: Array2D<Dot>) -> Array<(columnDiff: Int, rowDiff: Int)>? {
    let results = checkBlockage(dotArray)
    
    if results.blockedOnRight {
      return [(-1,1), (0, 0)]
    } else if results.blockedOnTop {
      return [(0, 1),(-1, 0)]
    } else {
      if orientation == .Horizontal {
        return [(0,0), (-1,-1)]
      } else {
        return [(0,1), (1,0)]
      }
    }
  }
  
  func getClockwisePosition(dotArray: Array2D<Dot>) -> Array<(columnDiff: Int, rowDiff: Int)>? {
    let results = checkBlockage(dotArray)
    
    if results.blockedOnRight {
      return [(-1,1), (0, 0)]
    } else if results.blockedOnTop {
      return [(0, 1),(-1, 0)]
    } else {
      if orientation == .Horizontal {
        return [(0,0), (-1,-1)]
      } else {
        return [(0,0), (1,-1)]
      }
    }
  }
  
  private final func rotatePieceCounterClockwise(dotArray: Array2D<Dot>) {
    if let pieceRowColumnTranslation = getCounterClockwisePositionFor(dotArray) {
      previousRotation = Rotation(dots: dots, translations: pieceRowColumnTranslation)
      let cachedDots = dots

      for (idx, diff) in pieceRowColumnTranslation.enumerate() {
        let dot = cachedDots[idx]
        dot.column = dot.column + diff.columnDiff
        dot.row = dot.row + diff.rowDiff
      }
    }
  }
  
  private final func rotatePieceClockwise(dotArray: Array2D<Dot>) {
    if let pieceRowColumnTranslation = getClockwisePosition(dotArray) {
      previousRotation = Rotation(dots: dots, translations: pieceRowColumnTranslation)
      let cachedDots = dots

      for (idx, diff) in pieceRowColumnTranslation.enumerate() {
        let dot = cachedDots[idx]
        dot.column = dot.column + diff.columnDiff
        dot.row = dot.row + diff.rowDiff
      }
    }
  }
  
  final func rotateClockwise(dotArray: Array2D<Dot>) {
    rotatePieceClockwise(dotArray)
  }
  
  final func rotateCounterClockwise(dotArray: Array2D<Dot>) {
    rotatePieceCounterClockwise(dotArray)
  }
  
  final func undoPreviousRotation() {
    previousRotation?.undo()
  }
  
  final class func random(startingColumn:Int, startingRow:Int) -> Piece {
    let leftSide = DotColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    let rightSide = DotColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    
    return Piece(column: startingColumn, row: startingRow, leftColor: leftSide, rightColor: rightSide)
  }
  
  func removeFromScene() {
    self.dot1.removeFromScene()
    self.dot2.removeFromScene()
  }
  
  deinit {
//    print("\(self) is being deinitialized")
  }
  
}