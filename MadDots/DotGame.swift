//
//  DotGame.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/12/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

let NumColumns = 10
let NumRows = 18

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
  var madDots: Array<MadDot>

  var fallingPiece:Piece?
  var levelMaker: LevelMaker

  var delegate:DotGameDelegate?
  var lastMovement = Movement.Up
  var seq: Array<Piece>?
  
  init() {
    fallingPiece = nil
    dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)    
    madDots = Array<MadDot>()
    levelMaker = LevelMaker(dotArray: dotArray)
  }
  
  func settleShape() {
    if let piece = fallingPiece {
      for dot in piece.dots {
        dotArray[dot.column, dot.row] = dot
      }
//      print("darray: \(dotArray)")
      fallingPiece = nil
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
  
  func beginAnew() {
    if let vc = delegate as? GameViewController {
      vc.setLevelLabel()
    }

    fallingPiece?.removeFromScene()
    fallingPiece = nil
    dotArray.removeDotsFromScene()
    dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    madDots = Array<MadDot>()
    levelMaker.dotArray = dotArray
    
    beginGame()
  }
  
  func beginGame() {
    if (fallingPiece == nil) {
      fallingPiece = newPiece()
    }
    
    self.madDots.appendContentsOf(levelMaker.makeRandomLevel(GameLevel))
    
//    let sen = testScenario()
//    dotArray = sen.array
//    seq = sen.pieces
//    if let vc = delegate as? GameViewController {
//      vc.scene.addArrayToScene(dotArray)
//    }
    
    delegate?.gameDidBegin(self)
  }
  
  func addMadDots() {
    let hardCodedSpots: [(column: Int, row: Int, color: DotColor)] = [(5,10,.Red)]

    for spot in hardCodedSpots {
      let dot = MadDot(column: spot.column, row: spot.row, color: spot.color)
      dotArray[dot.column, dot.row] = dot
      madDots.append(dot)
    }
    
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
      piece.rotateCounterClockwise(dotArray)
      if detectIllegalPlacement() {
        piece.rotateClockwise()
      } else {
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
    
    if dotsToRemove.count == 0 {
      return ([], [])
    } else {
      let fallenDots = dropFallenDots(dotArray)
      return (dotsToRemove, fallenDots)
    }
  }
  
  deinit {
    print("DotGame is being deinitialized")
  }

}
