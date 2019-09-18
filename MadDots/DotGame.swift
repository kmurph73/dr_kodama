//
//  DotGame.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/12/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//
import Foundation

let NumColumns = 8
let NumRows = 17
let DrawnRows = NumRows - 3

let StartingColumn = 3
let StartingRow = 1

var CanMovePiece = false

var RotateDir: Dir = .counterClockwise

enum MatrixDir: Int {
  case row = 0, column
}

protocol DotGameDelegate {
  func gameDidEnd(_ dotGame: DotGame)
  func gameDidBegin(_ dotGame: DotGame)
  func gamePieceDidMove(_ dotGame: DotGame, duration: TimeInterval, completion: (() -> ())?)
  func gamePieceDidLand(_ dotGame: DotGame)
}

class DotGame {
  var dotArray:DotArray2D
  var madDots: Array<MadDot>

  var fallingPiece:Piece?
  var nextPiece:Piece?

  var levelMaker: LevelMaker

  var delegate:DotGameDelegate?
  var seq: Array<Piece>?
  
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
  
  var cnt = 0
//  var alt = true
  
  func newPiece() -> Piece {
    if let s = seq {
      cnt += 1
      if cnt <= s.count {
        return s[cnt - 1]
      } else {
        return Piece.random(StartingColumn, startingRow: StartingRow)
      }
    } else {
      return Piece.random(StartingColumn, startingRow: StartingRow)
    }
  }
  
  func newNextPiece() -> Piece {
    let piece = Piece.random(StartingColumn - 3, startingRow: 0)
    return piece
  }
  
  func dropPiece() {
    if let piece = fallingPiece {
      if let ctrl = delegate as? GameViewController {
        ctrl.scene.stopTicking()
      }
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
    if let vc = delegate as? GameViewController {
      vc.setLevelLabel()
    }

    fallingPiece?.removeFromScene()
    nextPiece?.removeFromScene()
    fallingPiece = nil
    nextPiece = nil
    dotArray.removeDotsFromScene()
    dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
    madDots = Array<MadDot>()
    levelMaker.dotArray = dotArray
    
    beginGame()
  }
  
  func beginGame() {
    if (fallingPiece == nil) {
      fallingPiece = newPiece()
    }
    
    if (nextPiece == nil && ShowNextPiece) {
      nextPiece = newNextPiece()
    }
    
    self.madDots.append(contentsOf: levelMaker.makeRandomLevel(GameLevel))
    
//    let sen = testScenario3()
//    dotArray = sen.array
//    seq = sen.pieces
//    if let vc = delegate as? GameViewController {
//      vc.scene.addArrayToScene(dotArray)
//    }
    
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
      if RotateDir == .clockwise {
        piece.rotateClockwise(dotArray)
      } else {
        piece.rotateCounterClockwise(dotArray)
      }
      if detectIllegalPlacement() {
        piece.undoPreviousRotation()
//        piece.rotateClockwise(dotArray)
      } else {
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
        if detectIllegalPlacement() {
          delegate?.gameDidEnd(self)
//          endGame()
        } else {
          settlePiece()
        }
      } else {
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
