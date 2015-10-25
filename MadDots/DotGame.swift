//
//  DotGame.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/12/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

let NumColumns = 5
let NumRows = 12

let StartingColumn = 0
let StartingRow = 0

enum MatrixDir: Int {
  case Row = 0, Column
}

protocol DotGameDelegate {
  func gameDidEnd(dotGame: DotGame)
  func gameDidBegin(dotGame: DotGame)
  func gamePieceDidMove(dotGame: DotGame)
  func gamePieceDidLand(dotGame: DotGame)
}

enum Movement: Int, CustomStringConvertible {
  case Up = 0, Down, Left, Right
  
  var description: String {
    switch self {
    case .Up:
      return "Up"
    case .Down:
      return "Down"
    case .Left:
      return "Left"
    case .Right:
      return "Right"
    }
  }
}

class DotGame {
  var dotArray:Array2D<Dot>

  var fallingPiece:Piece?

  var delegate:DotGameDelegate?
  var lastMovement = Movement.Up
  
  init() {
    fallingPiece = nil
    dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
  }
  
  func settleShape() {
    if let piece = fallingPiece {
      for dot in piece.dots {
        dotArray[dot.column, dot.row] = dot
      }
      fallingPiece = nil
      delegate?.gamePieceDidLand(self)
    }
  }
  
  var cnt = 0
  func newPiece() -> Piece {
    return Piece(column: StartingColumn, row: StartingRow, leftColor: .Blue, rightColor: .Yellow)

//    return Piece.random(StartingColumn, startingRow: StartingRow)
  }
  
  func beginGame() {
    if (fallingPiece == nil) {
      fallingPiece = newPiece()
    }
    
    delegate?.gameDidBegin(self)
  }
  
  func detectIllegalPlacement() -> Bool {
    if let piece = fallingPiece {
      for dot in piece.dots {
        if dot.column < 0 || dot.column >= NumColumns
          || dot.row < 0 || dot.row >= NumRows {
            return true
        } else if dotArray[dot.column, dot.row] != nil {
          return true
        }
      }
    }
    return false
  }
  
  func movePieceLeft() {
    if let piece = fallingPiece {
      piece.shiftLeftByOneColumn()
      if detectIllegalPlacement() {
        piece.shiftRightByOneColumn()
        return
      }

      delegate?.gamePieceDidMove(self)
      
    }
  }
  
  func movePieceRight() {
    if let piece = fallingPiece {
      piece.shiftRightByOneColumn()
      if detectIllegalPlacement() {
        piece.shiftLeftByOneColumn()
        return
      }

      delegate?.gamePieceDidMove(self)

    }
  }
  
  func movePieceDown() {
    if let piece = fallingPiece {
      piece.lowerByOneRow()
      if detectIllegalPlacement() {
        piece.raiseByOneRow()
        return
      }

      delegate?.gamePieceDidMove(self)
    }
  }
  
  func rotatePiece() {
    if let piece = fallingPiece {
      piece.rotateCounterClockwise()
      if detectIllegalPlacement() {
        print("dat illeg bro")
        piece.rotateClockwise()
      } else {
        print("rotate counter")
        delegate?.gamePieceDidMove(self)
      }
    }
  }
  
  func detectTouch() -> Bool {
    if let piece = fallingPiece {
      for bottomDot in piece.bottomDots {
        if bottomDot.row == NumRows - 1 ||
          dotArray[bottomDot.column, bottomDot.row + 1] != nil {
            return true
        }
      }
    }
    return false
  }
  
  func lowerPiece() {
    if let piece = fallingPiece {
      piece.lowerByOneRow()
      if detectIllegalPlacement() {
        piece.raiseByOneRow()
        if detectIllegalPlacement() {
          print("end game")
//          endGame()
        } else {
          settleShape()
        }
      } else {
        lastMovement = .Down
        delegate?.gamePieceDidMove(self)

      }
    }

  }
  
  func removeCompletedDots() -> (dotsToRemove:Array<Dot>,fallenDots:Array<Dot>) {
    let dotsToRemove = findChainsForColumns(dotArray)
        
    for dot in dotsToRemove {
      dotArray[dot.column, dot.row] = nil
    }
    
    let fallenDots = dropFallenDots(dotArray)
    
    if dotsToRemove.count == 0 {
      return ([], [])
    } else {
      return (dotsToRemove, fallenDots)
    }
    
  }
  
}
