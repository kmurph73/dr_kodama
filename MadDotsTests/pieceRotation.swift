//
//  pieceRotation.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/15/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import XCTest

class PieceRotationTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testRotation() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let red1 = GoodDot(column: 3, row: NumRows - 5, color: .Red)
    let red2 = GoodDot(column: 3, row: NumRows - 4, color: .Red)
    let mad = MadDot(column: 3, row: NumRows - 3, color: .Yellow)
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let piece = Piece(column: 2, row: NumRows - 6, leftColor: .Yellow, rightColor: .Yellow)
    setPiece(dotArray, piece: piece)
    print("darray0: \(dotArray)")

    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    piece.lowerByOneRow()
    
    setPiece(dotArray, piece: piece)

    XCTAssertEqual(piece.bottomDot?.row, NumRows - 5)
    XCTAssertEqual(piece.topDot?.row, NumRows - 6)
    
    dotArray.removePiece(piece)
    piece.lowerByOneRow()
    setPiece(dotArray, piece: piece)
    
//    setDot(dotArray, dot: piece.leftDot)
//    setDot(dotArray, dot: piece.rightDot)
    
    print("darray1: \(dotArray)")
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(piece.leftDot?.column, 1)
    XCTAssertEqual(piece.rightDot?.column, 2)
    
    setPiece(dotArray, piece: piece)
    
    print("darray2: \(dotArray)")
    
    // XCTAssertNotNil(lm, "LevelMaker could not be instantiated")
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testRotationInWedge() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let red1 = GoodDot(column: 3, row: NumRows - 3, color: .Red)
    let red2 = GoodDot(column: 3, row: NumRows - 2, color: .Red)
    let mad = MadDot(column: 3, row: NumRows - 1, color: .Yellow)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let red3 = GoodDot(column: 1, row: NumRows - 3, color: .Red)
    let red4 = GoodDot(column: 1, row: NumRows - 2, color: .Red)
    let mad2 = MadDot(column: 1, row: NumRows - 1, color: .Yellow)
    
    setDot(dotArray, dot: red3)
    setDot(dotArray, dot: red4)
    setDot(dotArray, dot: mad2)
    
    let piece = Piece(column: 2, row: NumRows - 4, leftColor: .Yellow, rightColor: .Yellow)
    dotGame.fallingPiece = piece
    setPiece(dotArray, piece: piece)
    print("darray0: \(dotArray)")
    
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    piece.lowerByOneRow()
    
    setPiece(dotArray, piece: piece)
    
//    XCTAssertEqual(piece.leftDot.row, NumRows - 5)
//    XCTAssertEqual(piece.rightDot.row, NumRows - 6)
    
    dotArray.removePiece(piece)
    piece.lowerByOneRow()
    setPiece(dotArray, piece: piece)
    
    //    setDot(dotArray, dot: piece.leftDot)
    //    setDot(dotArray, dot: piece.rightDot)
    
    print("darray1: \(dotArray)")
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),true)
    
    piece.undoPreviousRotation()

    XCTAssertEqual(dotGame.detectIllegalPlacement(),false)
    
    piece.dot1.row -= 1
    piece.dot2.row += 1
//    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),false)
//    setPiece(dotArray, piece: piece)
    piece.rotateCounterClockwise(dotArray)
    XCTAssertEqual(dotGame.detectIllegalPlacement(),true)
    
    piece.undoPreviousRotation()
    XCTAssertEqual(dotGame.detectIllegalPlacement(),false)
    

//    XCTAssertEqual(piece.leftDot.column, 2)
    
//    setPiece(dotArray, piece: piece)
    
    print("darray2: \(dotArray)")
    
  }
  
  func testRotationOnTop() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let red1 = GoodDot(column: 1, row: 1, color: .Red)
    let red2 = GoodDot(column: 2, row: 1, color: .Red)
    let mad = MadDot(column: 3, row: 1, color: .Yellow)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let piece = Piece(column: 1, row: 0, leftColor: .Yellow, rightColor: .Yellow)
    
    dotGame.fallingPiece = piece
    setPiece(dotArray, piece: piece)
    print("darray0: \(dotArray)")
    
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),true)
    
    piece.undoPreviousRotation()
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(), false)
    
    
    //    XCTAssertEqual(piece.leftDot.column, 2)
    
    //    setPiece(dotArray, piece: piece)
    
//    print("darray2: \(dotArray)")
    
  }
  
  func testRotationWhenBlockedOnTop() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let red1 = GoodDot(column: 1, row: 1, color: .Red)
    let red2 = GoodDot(column: 2, row: 1, color: .Red)
    let mad = MadDot(column: 3, row: 1, color: .Yellow)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let red3 = GoodDot(column: 1, row: 3, color: .Red)
    let red4 = GoodDot(column: 2, row: 3, color: .Red)
    let mad2 = MadDot(column: 3, row: 3, color: .Yellow)
    
    setDot(dotArray, dot: red3)
    setDot(dotArray, dot: red4)
    setDot(dotArray, dot: mad2)
    
    let piece = Piece(column: 1, row: 2, leftColor: .Yellow, rightColor: .Yellow)
    
    dotGame.fallingPiece = piece
    setPiece(dotArray, piece: piece)
    print("darray0: \(dotArray)")
    
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),true)
    
    piece.undoPreviousRotation()
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(), false)
    
  }
  
  func testRotatesCorrectlyWhenBlockedOnTop() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let red1 = GoodDot(column: 1, row: 1, color: .Red)
    let red2 = GoodDot(column: 2, row: 1, color: .Red)
    let mad = MadDot(column: 3, row: 1, color: .Yellow)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let red4 = GoodDot(column: 2, row: 3, color: .Red)
    let mad2 = MadDot(column: 3, row: 3, color: .Yellow)
    
    setDot(dotArray, dot: red4)
    setDot(dotArray, dot: mad2)
    
    let piece = Piece(column: 1, row: 2, leftColor: .Yellow, rightColor: .Yellow)
    
    dotGame.fallingPiece = piece
//    setPiece(dotArray, piece: piece)
//    print("darray0: \(dotArray)")
//    
//    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),false)
    XCTAssertEqual(piece.bottomDot?.column, 1)
    XCTAssertEqual(piece.bottomDot?.row, 3)
    XCTAssertEqual(piece.topDot?.column, 1)
    XCTAssertEqual(piece.topDot?.row, 2)
  }
  
  func testFitsIntoSlotOnEdge() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let col = NumColumns - 2
    
    let red1 = GoodDot(column: col, row: 2, color: .Red)
    let red2 = GoodDot(column: col, row: 4, color: .Red)
    let mad = MadDot(column: col, row: 5, color: .Yellow)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let piece = Piece(column: col, row: 1, leftColor: .Yellow, rightColor: .Yellow)
    
    dotGame.fallingPiece = piece
    
    setPiece(dotArray, piece: piece)
    print("darray0: \(dotArray)")
    
    dotArray.removePiece(piece)
    //    setPiece(dotArray, piece: piece)
    //    print("darray0: \(dotArray)")
    //
    //    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    piece.dot1.column += 1
    piece.dot2.column += 1
    piece.lowerByOneRow()
    piece.lowerByOneRow()

    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),false)

    piece.rotateCounterClockwise(dotArray)
    XCTAssertEqual(dotGame.detectIllegalPlacement(),true)

    piece.undoPreviousRotation()
    
    XCTAssertEqual(dotGame.detectIllegalPlacement(),false)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    //    self.measureBlock {
    //      // Put the code you want to measure the time of here.
    //    }
  }
  
  func testRotationInWedge2() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let red1 = GoodDot(column: 3, row: NumRows - 6, color: .Red)
    let red2 = GoodDot(column: 3, row: NumRows - 5, color: .Red)
    let mad = MadDot(column: 3, row: NumRows - 4, color: .Yellow)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let red3 = GoodDot(column: 1, row: NumRows - 6, color: .Red)
    let red4 = GoodDot(column: 1, row: NumRows - 5, color: .Red)
    let mad2 = MadDot(column: 1, row: NumRows - 4, color: .Yellow)
    
    setDot(dotArray, dot: red3)
    setDot(dotArray, dot: red4)
    setDot(dotArray, dot: mad2)
    
    print("darray-1: \(dotArray)")

    let piece = Piece(column: 2, row: NumRows - 8, leftColor: .Yellow, rightColor: .Yellow)
    dotGame.fallingPiece = piece

    piece.rotateCounterClockwise(dotArray)
    piece.rotateCounterClockwise(dotArray)
    piece.rotateCounterClockwise(dotArray)
    print("orient: \(piece.orientation)")

    setPiece(dotArray, piece: piece)
    print("darray0: \(dotArray)")
    
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    piece.rotateCounterClockwise(dotArray)
    piece.rotateCounterClockwise(dotArray)
    setPiece(dotArray, piece: piece)
    print("darray1: \(dotArray)")
    
    dotArray.removePiece(piece)

    piece.rotateClockwise(dotArray)
    
    setPiece(dotArray, piece: piece)
    print("darray2: \(dotArray)")
    
    dotArray.removePiece(piece)
  }
  
}