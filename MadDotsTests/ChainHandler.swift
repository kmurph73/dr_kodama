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
      let dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
      
      let dot1 = GoodDot(column: 3, row: NumRows - 6, color: .yellow)
      let dot2 = GoodDot(column: 3, row: NumRows - 5, color: .yellow)
      
      dot1.sibling = dot2
      dot2.sibling = dot1
      
      dotArray[3, NumRows - 6] = dot1
      dotArray[3, NumRows - 5] = dot2
      let madDot = MadDot(column: 3, row: NumRows - 4, color: .red)
      
      dotArray[3, NumRows - 4] = madDot
      let dot3 = GoodDot(column: 3, row: NumRows - 3, color: .red)
      let dot4 = GoodDot(column: 3, row: NumRows - 2, color: .red)
      let dot5 = GoodDot(column: 3, row: NumRows - 1, color: .red)
      
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
    let dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let leftRedDot = GoodDot(column: 4, row: NumRows - 6, color: .red)
    let rightRedDot = GoodDot(column: 3, row: NumRows - 6, color: .red)
    leftRedDot.sibling = rightRedDot
    rightRedDot.sibling = leftRedDot
    dotArray.setDot(leftRedDot)
    dotArray.setDot(rightRedDot)
    
    let leftBlueDot = GoodDot(column: 4, row: NumRows - 7, color: .blue)
    let rightBlueDot = GoodDot(column: 3, row: NumRows - 7, color: .blue)
    leftBlueDot.sibling = rightBlueDot
    rightBlueDot.sibling = leftBlueDot
    dotArray.setDot(leftBlueDot)
    dotArray.setDot(rightBlueDot)
    
    let dot3 = GoodDot(column: 3, row: NumRows - 1, color: .yellow)
    let dot4 = GoodDot(column: 3, row: NumRows - 2, color: .yellow)
    let dot5 = GoodDot(column: 3, row: NumRows - 3, color: .yellow)
    let dot6 = GoodDot(column: 3, row: NumRows - 4, color: .yellow)
    
    dotArray.setDot(dot3)
    dotArray.setDot(dot4)
    dotArray.setDot(dot5)
    dotArray.setDot(dot6)
    
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
    let dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let madDot = MadDot(column: 4, row: NumRows - 3, color: .yellow)
    let leftDot = GoodDot(column: 4, row: NumRows - 4, color: .red)
    let rightDot = GoodDot(column: 5, row: NumRows - 4, color: .red)
    
    leftDot.sibling = rightDot
    rightDot.sibling = leftDot
    
    dotArray.setDot(leftDot)
    dotArray.setDot(rightDot)
    dotArray.setDot(madDot)
    
    let dot3 = GoodDot(column: 3, row: NumRows - 1, color: .yellow)
    let dot4 = GoodDot(column: 3, row: NumRows - 2, color: .yellow)
    let dot5 = GoodDot(column: 3, row: NumRows - 3, color: .yellow)
    let dot6 = GoodDot(column: 3, row: NumRows - 4, color: .yellow)
    
    dotArray.setDot(dot3)
    dotArray.setDot(dot4)
    dotArray.setDot(dot5)
    dotArray.setDot(dot6)
    
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
    let dotArray = DotArray2D(columns: NumColumns, rows: NumRows)
    dotGame.dotArray = dotArray
    
    let col = NumColumns - 3
    
    let red1 = GoodDot(column: col, row: 2, color: .red)
    let red2 = GoodDot(column: col, row: 3, color: .red)
    let mad = MadDot(column: col, row: 4, color: .red)
    
    dotArray.setDot(red1)
    dotArray.setDot(red2)
    dotArray.setDot(mad)
    
    let piece = Piece(column: col, row: 1, leftColor: .red, rightColor: .yellow)
    
    dotGame.fallingPiece = piece
    

    //    setPiece(dotArray, piece: piece)
    //    print("darray0: \(dotArray)")
    //
    //    dotArray.removePiece(piece)
    piece.rotateCounterClockwise(dotArray)
    
    dotArray.setPiece(piece)
    
    let results = dotGame.removeCompletedDots()
    
    XCTAssertEqual(results.fallenDots.count, 1)
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
          // Put the code you want to measure the time of here.
      }
  }

}
