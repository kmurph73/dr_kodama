//
//  GameLevelsTests.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/7/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import XCTest

class GameLevelsTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testLevel() {
    for n in 0...10 {
      let dotArray = Array2D<Dot>(columns: NumColumns, rows: NumRows)
      var madDots = Array<MadDot>()
      let lm = LevelMaker(dotArray: dotArray, madDots: &madDots)
      lm.makeLevel(4)
      XCTAssertEqual(30, dotArray.countMadDots())
      print("dotArray: \(dotArray)")
    }
    
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
