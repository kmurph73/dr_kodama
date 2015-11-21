//
//  ChainHandler.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/12/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import XCTest

class ChainHandler: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
    func testFlip() {
      
    }

    func testExample() {
      let dotGame = DotGame()
      let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
      
      let dot1 = GoodDot(column: 3, row: NumRows - 6, color: .Yellow, side: .Left)
      let dot2 = GoodDot(column: 3, row: NumRows - 5, color: .Yellow, side: .Right)
      
      dot1.sibling = dot2
      dot2.sibling = dot1
      
      dotArray[3, NumRows - 6] = dot1
      dotArray[3, NumRows - 5] = dot2
      let madDot = MadDot(column: 3, row: NumRows - 4, color: .Red)
      
      dotArray[3, NumRows - 4] = madDot
      let dot3 = GoodDot(column: 3, row: NumRows - 3, color: .Red, side: .Right)
      let dot4 = GoodDot(column: 3, row: NumRows - 2, color: .Red, side: .Right)
      let dot5 = GoodDot(column: 3, row: NumRows - 1, color: .Red, side: .Right)
      
      dotArray[3,NumRows - 3] = dot3
      dotArray[3,NumRows - 2] = dot4
      dotArray[3,NumRows - 1] = dot5
      
      dotGame.dotArray = dotArray
      
      let results = dotGame.removeCompletedDots()
      
      XCTAssertEqual(results.dotsToRemove.count, 4)
      XCTAssertEqual(dot1, results.fallenDots[1])
      XCTAssertEqual(dot2, results.fallenDots[0])
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
  
  func testFloatingPiece() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let leftRedDot = GoodDot(column: 4, row: NumRows - 6, color: .Red, side: .Left)
    let rightRedDot = GoodDot(column: 3, row: NumRows - 6, color: .Red, side: .Right)
    leftRedDot.sibling = rightRedDot
    rightRedDot.sibling = leftRedDot
    setDot(dotArray, dot: leftRedDot)
    setDot(dotArray, dot: rightRedDot)
    
    let leftBlueDot = GoodDot(column: 4, row: NumRows - 7, color: .Blue, side: .Left)
    let rightBlueDot = GoodDot(column: 3, row: NumRows - 7, color: .Blue, side: .Right)
    leftBlueDot.sibling = rightBlueDot
    rightBlueDot.sibling = leftBlueDot
    setDot(dotArray, dot: leftBlueDot)
    setDot(dotArray, dot: rightBlueDot)
    
    let dot3 = GoodDot(column: 3, row: NumRows - 1, color: .Yellow, side: .Left)
    let dot4 = GoodDot(column: 3, row: NumRows - 2, color: .Yellow, side: .Right)
    let dot5 = GoodDot(column: 3, row: NumRows - 3, color: .Yellow, side: .Left)
    let dot6 = GoodDot(column: 3, row: NumRows - 4, color: .Yellow, side: .Right)
    
    setDot(dotArray, dot: dot3)
    setDot(dotArray, dot: dot4)
    setDot(dotArray, dot: dot5)
    setDot(dotArray, dot: dot6)
    
    let results = dotGame.removeCompletedDots()

    XCTAssertEqual(results.dotsToRemove.count, 4)
    XCTAssertEqual(results.fallenDots[0], leftRedDot)
    XCTAssertEqual(results.fallenDots[1], rightRedDot)
    XCTAssertEqual(results.fallenDots[2], leftBlueDot)
    XCTAssertEqual(results.fallenDots[3], rightBlueDot)
    
//    XCTAssertEqual(results.fallenDots[3], rightBlueDot)
    
//    XCTAssertEqual(dotArray, rightBlueDot)

//    XCTAssertEqual(dot1, results.fallenDots[1])
//    XCTAssertEqual(dot2, results.fallenDots[0])
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testDotsShouldntDrop() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let madDot = MadDot(column: 4, row: NumRows - 3, color: .Yellow)
    let leftDot = GoodDot(column: 4, row: NumRows - 4, color: .Red, side: .Left)
    let rightDot = GoodDot(column: 5, row: NumRows - 4, color: .Red, side: .Right)
    
    leftDot.sibling = rightDot
    rightDot.sibling = leftDot
    
    setDot(dotArray, dot: leftDot)
    setDot(dotArray, dot: rightDot)
    setDot(dotArray, dot: madDot)
    
    let dot3 = GoodDot(column: 3, row: NumRows - 1, color: .Yellow, side: .Left)
    let dot4 = GoodDot(column: 3, row: NumRows - 2, color: .Yellow, side: .Right)
    let dot5 = GoodDot(column: 3, row: NumRows - 3, color: .Yellow, side: .Left)
    let dot6 = GoodDot(column: 3, row: NumRows - 4, color: .Yellow, side: .Right)
    
    setDot(dotArray, dot: dot3)
    setDot(dotArray, dot: dot4)
    setDot(dotArray, dot: dot5)
    setDot(dotArray, dot: dot6)
    
    let results = dotGame.removeCompletedDots()

    XCTAssertEqual(results.fallenDots.count, 0)
//    XCTAssertEqual(results.fallenDots[3], rightBlueDot)
    
//    XCTAssertEqual(results.fallenDots[3], rightBlueDot)

//    XCTAssertEqual(dotArray, rightBlueDot)
    
//    XCTAssertEqual(dot1, results.fallenDots[1])
//    XCTAssertEqual(dot2, results.fallenDots[0])
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testBug() {
    let dotGame = DotGame()
    let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let col = NumColumns - 3
    
    let red1 = GoodDot(column: col, row: 2, color: .Red, side: .Left)
    let red2 = GoodDot(column: col, row: 3, color: .Red, side: .Left)
    let mad = MadDot(column: col, row: 4, color: .Red)
    
    setDot(dotArray, dot: red1)
    setDot(dotArray, dot: red2)
    setDot(dotArray, dot: mad)
    
    let piece = Piece(column: col, row: 1, leftColor: .Red, rightColor: .Yellow)
    
    dotGame.fallingPiece = piece
    

    //    setPiece(dotArray, piece: piece)
    //    print("darray0: \(dotArray)")
    //
    //    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    setPiece(dotArray, piece: piece)
    
    let results = dotGame.removeCompletedDots()
    
    XCTAssertEqual(results.fallenDots.count, 1)
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measureBlock {
          // Put the code you want to measure the time of here.
      }
  }

}
