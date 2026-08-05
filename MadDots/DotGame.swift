//
//  DotGame.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/12/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//
import Foundation

let NumColumns = 8
let NumRows = 16
let DrawnRows = NumRows - 2

let StartingColumn = 3
let StartingRow = 1
var CanMovePiece = false
var AngryLengthDefault = 25
var angryLengthCountdown = AngryLengthDefault
var AngryIntervalDefault = 20
var angryIntervalCountdown = AngryIntervalDefault
var NeedAngryDot = AngryKodama

var RotateDir: Dir = .counterClockwise

enum MatrixDir: Int {
  case row = 0, column
}

protocol DotGameDelegate: AnyObject {
  func gameDidEnd(_ dotGame: DotGame)
  func gameDidBegin(_ dotGame: DotGame)
  func gamePieceDidMove(_ dotGame: DotGame, duration: TimeInterval, completion: (() -> ())?)
  func gamePieceDidLand(_ dotGame: DotGame)
  func stopTimer()
  func setLevelLabel()
}

class DotGame {
  var dotArray:DotArray2D
  var madDots: Array<MadDot>

  var fallingPiece:Piece?
  var nextPiece:Piece?
  var graceSettle = false

  var levelMaker: LevelMaker

  weak var delegate: DotGameDelegate?
  
  init() {
    fallingPiece = nil
    nextPiece = nil
    dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
    madDots = Array<MadDot>()
    levelMaker = LevelMaker(dotArray: dotArray)
  }
  
  func settlePiece() {
    if let piece = fallingPiece {
      for dot in piece.dots {
        dotArray[dot.column, dot.row] = dot
      }
      fallingPiece = nil
//      print("darray: \(dotArray)")
      delegate?.gamePieceDidLand(self)
    }
  }
  
  func newPiece() -> Piece {
    return Piece.random(StartingColumn, startingRow: StartingRow)
  }
  
  func newNextPiece() -> Piece {
    return Piece.random(StartingColumn - 3, startingRow: StartingRow - 1)
  }
  
  func dropPiece() {
    if let piece = fallingPiece {
      delegate?.stopTimer()
      while true {
        piece.lowerByOneRow()
        if detectIllegalPlacement() {
          piece.raiseByOneRow()
          break
        }
      }
      
      delegate?.gamePieceDidMove(self, duration: 0.07) {
        self.settlePiece()
      }
    }
  }
  
  func beginAnew() {
    delegate?.setLevelLabel()

    fallingPiece?.removeFromScene()
    nextPiece?.removeFromScene()
    fallingPiece = nil
    nextPiece = nil
    dotArray.removeDotsFromScene()
    dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
    madDots = Array<MadDot>()
    levelMaker.dotArray = dotArray

    // Reset angry dot state
    angryLengthCountdown = AngryLengthDefault
    angryIntervalCountdown = AngryIntervalDefault
    NeedAngryDot = AngryKodama

    beginGame()
  }
  
  func beginGame() {
    if (fallingPiece == nil) {
      fallingPiece = newPiece()
    }
    
    if (nextPiece == nil && ShowNextPiece) {
      nextPiece = newNextPiece()
    }
    
    NeedAngryDot = true
    
    self.madDots.append(contentsOf: levelMaker.makeRandomLevel(GameLevel))

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
  
  func addThreeRandomThreeDots() -> Array<GoodDot> {
    let color1 = DotColor(rawValue: randomNum(0, max: NumberOfColors))
    let color2 = DotColor(rawValue: randomNum(0, max: NumberOfColors))
    
    let zeroOrOne = randomNum(0, max: 2)
    let numDots = zeroOrOne == 1 ? 2 : 3

    let colors = numDots == 2 ? [color1, color2] : [color1, color2, DotColor(rawValue: randomNum(0, max: NumberOfColors))]
  
    var cols: Set<Int> = []
    
    while (cols.count < numDots) {
      let num = randomNum(0, max: NumColumns)
      cols.insert(num)
    }
    
    let dots = cols.enumerated().compactMap { (index, col) -> GoodDot? in
      guard dotArray[col, 1] == nil else { return nil }
      return GoodDot(column: col, row: 1, color: colors[index]!)
    }

    for dot in dots {
      dotArray[dot.column, dot.row] = dot
    }
    
    return dots
  }
    
  
  func movePieceLeft() {
    if let piece = fallingPiece {
      piece.shiftLeftByOneColumn()
      if detectIllegalPlacement() {
        piece.shiftRightByOneColumn()
        return
      }

      delegate?.gamePieceDidMove(self, duration: 0, completion: nil)
      
    }
  }
  
  func movePieceRight() {
    if let piece = fallingPiece {
      piece.shiftRightByOneColumn()
      if detectIllegalPlacement() {
        piece.shiftLeftByOneColumn()
        return
      }

      delegate?.gamePieceDidMove(self, duration: 0, completion: nil)
    }
  }
  
  func movePieceDown() {
    if let piece = fallingPiece {
      piece.lowerByOneRow()
      if detectIllegalPlacement() {
        piece.raiseByOneRow()
        return
      }

      delegate?.gamePieceDidMove(self, duration: 0, completion: nil)
    }
  }
  
  func rotatePiece() {
    if let piece = fallingPiece {
      // Try rotating in current position
      if RotateDir == .clockwise {
        piece.rotateClockwise(dotArray)
      } else {
        piece.rotateCounterClockwise(dotArray)
      }

      if detectIllegalPlacement() {
        // Rotation failed in current position, undo it
        piece.undoPreviousRotation()

        // Try lowering by one row and rotating again
        piece.lowerByOneRow()

        // Check if we can even lower the piece
        if !detectIllegalPlacement() {
          // Lower was successful, now try rotating again
          if RotateDir == .clockwise {
            piece.rotateClockwise(dotArray)
          } else {
            piece.rotateCounterClockwise(dotArray)
          }

          if detectIllegalPlacement() {
            // Still can't rotate after lowering, undo everything
            piece.undoPreviousRotation()
            piece.raiseByOneRow()
          } else {
            // Success! Lowered and rotated — give the player a grace tick
            graceSettle = true
            delegate?.gamePieceDidMove(self, duration: 0, completion: nil)
          }
        } else {
          // Can't even lower the piece, undo the lower
          piece.raiseByOneRow()
        }
      } else {
        // Rotation succeeded in current position
        delegate?.gamePieceDidMove(self, duration: 0, completion: nil)
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
        if graceSettle {
          // Give the player one tick to move/rotate after a snap-down
          graceSettle = false
        } else {
          settlePiece()
        }
      } else {
        // Piece moved successfully
        graceSettle = false
        delegate?.gamePieceDidMove(self, duration: 0, completion: nil)
      }
    }
  }
  
  func removeCompletedDots() -> (dotsToRemove:Array<Dot>,fallenDots:Array<GoodDot>) {
    let dotsToRemove = findAllChains(dotArray)
    
    for dot in dotsToRemove {
      if let d = dot as? GoodDot {
        if let s = d.sibling {
          s.sibling = nil
        }
      }
      
      dotArray[dot.column, dot.row] = nil
    }
    
    madDots = madDots.filter() {
      return !dotsToRemove.contains($0)
    }
    levelMaker.madDots = madDots
    
    if dotsToRemove.count == 0 {
      return ([], [])
    } else {
      let fallenDots = dropFallenDots(dotArray)
      return (dotsToRemove, fallenDots)
    }
  }
  
  deinit {
//    print("DotGame is being deinitialized")
  }

}
