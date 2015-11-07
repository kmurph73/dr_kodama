//
//  HandleChains.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/18/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func findChainsForRows(dotArray: Array2D<Dot>, inout realChains: Array<Dot>) -> Array<Dot> {
  var someChain = Array<Dot>()
  
  var previousDot: Dot?
  
  for var row = NumRows - 1; row >= 0; row-- {
    checkIfRealChain(someChain, realChains: &realChains)
    
    someChain = Array<Dot>()
    previousDot = nil
    
    for column in 0..<NumColumns {
      if let dot = dotArray[column, row] {
        if let prevDot = previousDot {
          if prevDot.color == dot.color {
            someChain.append(dot)
          } else {
            checkIfRealChain(someChain, realChains: &realChains)
            someChain = Array<Dot>()
            someChain.append(dot)
          }
          
          previousDot = dot
        } else {
          someChain.append(dot)
          checkIfRealChain(someChain, realChains: &realChains)
          previousDot = dot
        }
        
      } else {
        checkIfRealChain(someChain, realChains: &realChains)
        
        someChain = Array<Dot>()
      }
    }
  }
  
  checkIfRealChain(someChain, realChains: &realChains)
  
  return realChains
}

func findChainsForColumn(dotArray:Array2D<Dot>, inout realChains: Array<Dot>) -> Array<Dot> {
  var someChain = Array<Dot>()
  var previousDot: Dot?
  
}

func findChainsForColumns(dotArray: Array2D<Dot>, inout realChains: Array<Dot>) -> Array<Dot> {

  
  for var column = NumColumns - 1; column >= 0; column-- {
    checkIfRealChain(someChain, realChains: &realChains)
    
    someChain = Array<Dot>()
    previousDot = nil
    
    for row in 0..<NumRows {
      if let dot = dotArray[column, row] {
        if let prevDot = previousDot {
          
          if prevDot.color == dot.color {
            someChain.append(dot)
          } else {
            checkIfRealChain(someChain, realChains: &realChains)
            someChain = Array<Dot>()
            someChain.append(dot)
          }
          
          previousDot = dot
        } else {
          someChain.append(dot)
          checkIfRealChain(someChain, realChains: &realChains)
          previousDot = dot
        }
        
      } else {
        checkIfRealChain(someChain, realChains: &realChains)

        someChain = Array<Dot>()
      }
    }
  }
  
  checkIfRealChain(someChain, realChains: &realChains)
  
  return realChains
}

func findAllChains(dotArray: Array2D<Dot>) -> Array<Dot> {
  var realChains = Array<Dot>()
  
  findChainsForColumns(dotArray, realChains: &realChains)
  findChainsForRows(dotArray, realChains: &realChains)

  return realChains
}

func dotIsSettled(dot: Dot?, dotArray: Array2D<Dot>) -> Bool {
  if let d = dot {
    return dotArray[d.column, d.row + 1] != nil
  } else {
    return false
  }
}

func dropFallenDots(dotArray: Array2D<Dot>) -> Array<GoodDot> {
  var fallenDots = Array<GoodDot>()
  for column in 0..<NumColumns {
    var fallingDots = Array<GoodDot>()
    for var row = NumRows - 2; row > 0; row-- {
      if let dot = dotArray[column, row] as? GoodDot {
        let siblingIsSettled = dotIsSettled(dot.sibling, dotArray: dotArray)

        if dot.sibling == nil || !siblingIsSettled {
          var newRow = row
          while (newRow < NumRows - 1 && dotArray[column, newRow + 1] == nil) {
            newRow++
          }
          
          dot.row = newRow
          dotArray[column, row] = nil
          dotArray[column, newRow] = dot
          fallingDots.append(dot)
        }
      }
    }
    
    if fallingDots.count > 0 {
      fallenDots.appendContentsOf(fallingDots)
    }
  }
  
  return fallenDots
}

func checkIfRealChain(someChain: Array<Dot>, inout realChains: Array<Dot>) {
  if someChain.count > 2 {
    realChains.appendContentsOf(someChain)
  }
}