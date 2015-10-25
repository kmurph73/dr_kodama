//
//  Piece.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, CustomStringConvertible {
  case Zero = 0, Ninety, OneEighty, TwoSeventy
  
  var description: String {
    switch self {
    case .Zero:
      return "0"
    case .Ninety:
      return "90"
    case .OneEighty:
      return "180"
    case .TwoSeventy:
      return "270"
    }
  }
  
  static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
    var rotated = orientation.rawValue + (clockwise ? -1 : 1)
    if rotated > Orientation.TwoSeventy.rawValue {
      rotated = Orientation.Zero.rawValue
    } else if rotated < 0 {
      rotated = Orientation.TwoSeventy.rawValue
    }
    return Orientation(rawValue:rotated)!
  }
}

class Piece {
  var orientation: Orientation
  // The column and row representing the shape's anchor point
//  var column, row:Int
  
  var leftDot, rightDot: Dot
  
  init(column:Int, row:Int, leftColor: DotColor, rightColor: DotColor) {
    self.orientation = .Zero
    
    self.leftDot = Dot(column: column, row: row, color: leftColor)
    self.rightDot = Dot(column: column + 1, row: row, color: rightColor)
  }
  
  var dots: [Dot] {
    get {
      return [leftDot, rightDot]
    }
  }
  
  var column: Int {
    get {
      return self.leftDot.column
    }
  }
  
  var row: Int {
    get {
      return self.leftDot.row
    }
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
  
  var counterClockwiseRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
    return [
      Orientation.Zero:       [(0, 0), (1, -1)],
      Orientation.Ninety:     [(0, 0), (-1, -1)],
      Orientation.OneEighty:  [(0, 0), (-1, 1)],
      Orientation.TwoSeventy: [(0, 0), (1, 1)]
    ]
  }
  
  var clockwiseRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
    return [
      Orientation.Zero:       [(0, 0), (1, 1)],
      Orientation.Ninety:     [(0, 0), (1, -1)],
      Orientation.OneEighty:  [(0, 0), (-1, 1)],
      Orientation.TwoSeventy: [(0, 0), (-1, -1)]
    ]
  }
  
  func getClockwisePositionFor(orientation: Orientation) -> Array<(columnDiff: Int, rowDiff: Int)>? {
    let isOnRightEdge = self.rightDot.column == NumColumns - 1 && self.leftDot.column == NumColumns - 1

    if isOnRightEdge {
      if self.leftDot.row > self.rightDot.row {
        return [(-1, 0), (0,1)]
      } else {
        return [(0,1), (-1, 0)]
      }
    } else {
      return clockwiseRowColumnPositions[orientation]
    }
  }
  
  func getCounterClockwisePositionFor(orientation: Orientation) -> Array<(columnDiff: Int, rowDiff: Int)>? {
    let isOnLeftEdge = self.leftDot.column == 0 && self.rightDot.column == 0
    if isOnLeftEdge {
      print("is on left edge")
      if self.leftDot.row > self.rightDot.row {
        return [(1, 0), (0, 1)]
      } else {
        return [(0, 1), (1, 0)]
      }
    } else {
      return counterClockwiseRowColumnPositions[orientation]
    }
  }
  
  
  final func rotatePieceCounterClockwise(orientation: Orientation) {
    print("rotatePieces:\(orientation)")
    if let pieceRowColumnTranslation = getCounterClockwisePositionFor(orientation) {
      print("pRowColumn:\(pieceRowColumnTranslation)")
      for (idx, diff) in pieceRowColumnTranslation.enumerate() {
        let dot = dots[idx]
        print("idx: \(idx); diff: \(diff)")
        dot.column = dot.column + diff.columnDiff
        dot.row = dot.row + diff.rowDiff
      }
    }
  }
  
  final func rotatePieceClockwise(orientation: Orientation) {
    print("rotatePieces:\(orientation)")
    if let pieceRowColumnTranslation = getClockwisePositionFor(orientation) {
      print("pRowColumn:\(pieceRowColumnTranslation)")
      for (idx, diff) in pieceRowColumnTranslation.enumerate() {
        let dot = dots[idx]
        print("idx: \(idx); diff: \(diff)")
        dot.column = dot.column + diff.columnDiff
        dot.row = dot.row + diff.rowDiff
      }
    }
  }
  
  var bottomDotsForOrientations: [Orientation: Array<Dot>] {
    return [
      Orientation.Zero:       [leftDot, rightDot],
      Orientation.Ninety:     [leftDot],
      Orientation.OneEighty:  [rightDot, leftDot],
      Orientation.TwoSeventy: [rightDot]
    ]
  }
  
  var bottomDots:Array<Dot> {
    if let bottomDots = bottomDotsForOrientations[orientation] {
      return bottomDots
    }
    return []
  }
  
  final func rotateClockwise() {
    let newOrientation = Orientation.rotate(orientation, clockwise: true)
    rotatePieceClockwise(newOrientation)
    print("rotateClock: \(newOrientation)")
    orientation = newOrientation
  }
  
  final func rotateCounterClockwise() {
    let newOrientation = Orientation.rotate(orientation, clockwise: false)
    rotatePieceCounterClockwise(newOrientation)
    print("rotateCounter: \(newOrientation)")
    orientation = newOrientation
  }
  
  final class func random(startingColumn:Int, startingRow:Int) -> Piece {
    let leftSide = DotColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    let rightSide = DotColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    
    return Piece(column: startingColumn, row: startingRow, leftColor: leftSide, rightColor: rightSide)
  }
  
}