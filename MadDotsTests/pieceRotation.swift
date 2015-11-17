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
    
    let red1 = GoodDot(column: 3, row: NumRows - 5, color: .Red, side: .Left)
    let red2 = GoodDot(column: 3, row: NumRows - 4, color: .Red, side: .Right)
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

    XCTAssertEqual(piece.leftDot.row, NumRows - 5)
    XCTAssertEqual(piece.rightDot.row, NumRows - 6)
    
    dotArray.removePiece(piece)
    piece.lowerByOneRow()
    setPiece(dotArray, piece: piece)
    
//    setDot(dotArray, dot: piece.leftDot)
//    setDot(dotArray, dot: piece.rightDot)
    
    print("darray1: \(dotArray)")
    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    XCTAssertEqual(piece.rightDot.column, 1)
    XCTAssertEqual(piece.leftDot.column, 2)
    
    setPiece(dotArray, piece: piece)
    
    print("darray2: \(dotArray)")
    
    // XCTAssertNotNil(lm, "LevelMaker could not be instantiated")
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    //    self.measureBlock {
    //      // Put the code you want to measure the time of here.
    //    }
  }
  
}