//
//  HandleChains.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/18/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func findChainsForRows(dotArray: Array2D<Dot>, inout realChains: Array<Dot>, startRow: Int, endRow: Int) -> Array<Dot> {
  var someChain = Array<Dot>()
  
  var previousDot: Dot?
  
  for var row = startRow - 1; row >= endRow; row-- {
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

func findChainsForColumns(dotArray: Array2D<Dot>, inout realChains: Array<Dot>, startColumn: Int, endColumn: Int) -> Array<Dot> {
  var someChain = Array<Dot>()
  
  var previousDot: Dot?
  
  for var column = startColumn - 1; column >= endColumn; column-- {
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

func columnHasChain(dotArray: Array2D<Dot>, column: Int) -> Bool {
  var chains = Array<Dot>()
  
  findChainsForColumns(dotArray, realChains: &chains, startColumn: column, endColumn: column)
  
  return chains.count > 0
}

func rowHasChain(dotArray: Array2D<Dot>, row: Int) -> Bool {
  var chains = Array<Dot>()
  
  findChainsForRows(dotArray, realChains: &chains, startRow: row, endRow: row)
  
  return chains.count > 0
}

func findAllChains(dotArray: Array2D<Dot>) -> Array<Dot> {
  var realChains = Array<Dot>()
  
  findChainsForColumns(dotArray, realChains: &realChains, startColumn: NumColumns, endColumn: 0)
  findChainsForRows(dotArray, realChains: &realChains, startRow: NumRows, endRow: 0)

  return realChains
}

func dotIsSettled(dot: Dot, sibling: Dot?, dotArray: Array2D<Dot>) -> Bool {
  if let sibling = sibling {
    if dot.column != sibling.column {
      return dotArray[sibling.column, sibling.row + 1] != nil
    } else {
      return false
    }
  } else {
    return false
  }
}

func dropFallenDots(dotArray: Array2D<Dot>) -> Array<GoodDot> {
  var fallenDots = Array<GoodDot>()
  for var row = NumRows - 2; row > 0; row-- {
    var fallingDots = Array<GoodDot>()
    
    for column in 0..<NumColumns {
      
      if let dot = dotArray[column, row] as? GoodDot {
        var newRow = row
        while (newRow < NumRows - 1 && dotArray[column, newRow + 1] == nil) {
          newRow++
        }

        if let sibling = dot.sibling {
          if sibling.row == dot.row {
            let siblingRow = sibling.row
            var newSiblingRow = sibling.row
            
            while (newSiblingRow < NumRows - 1 && dotArray[sibling.column, newSiblingRow + 1] == nil) {
              newSiblingRow++
            }
            
            newRow = min(newRow,newSiblingRow)
            sibling.row = newRow

            if newRow > siblingRow {
              dotArray[sibling.column, siblingRow] = nil
              dotArray[sibling.column, newRow] = sibling
              fallingDots.append(sibling)
            }
          }
        }
        
        if newRow > dot.row {
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
  if someChain.count > 3 {
    realChains.appendContentsOf(someChain)
  }
}