//
//  HandleChains.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/18/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func findChainsForRows(_ dotArray: DotArray2D, realChains: inout Array<Dot>, startRow: Int, endRow: Int) -> Array<Dot> {
  var someChain = Array<Dot>()
  
  var previousDot: Dot?
  
  for row in endRow..<startRow {
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

func findChainsForColumns(_ dotArray: DotArray2D, realChains: inout Array<Dot>, startColumn: Int, endColumn: Int) -> Array<Dot> {
  var someChain = Array<Dot>()
  
  var previousDot: Dot?
  
  for column in endColumn..<startColumn {
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

func columnHasChain(_ dotArray: DotArray2D, column: Int) -> Bool {
  var chains = Array<Dot>()
  
  findChainsForColumns(dotArray, realChains: &chains, startColumn: column, endColumn: column)
  
  return chains.count > 0
}

func rowHasChain(_ dotArray: DotArray2D, row: Int) -> Bool {
  var chains = Array<Dot>()
  
  findChainsForRows(dotArray, realChains: &chains, startRow: row, endRow: row)
  
  return chains.count > 0
}

func findAllChains(_ dotArray: DotArray2D) -> Array<Dot> {
  var realChains = Array<Dot>()
  
  findChainsForColumns(dotArray, realChains: &realChains, startColumn: NumColumns, endColumn: 0)
  findChainsForRows(dotArray, realChains: &realChains, startRow: NumRows, endRow: 0)

  return realChains
}

func dotIsSettled(_ dot: Dot, sibling: Dot?, dotArray: DotArray2D) -> Bool {
  if let sibling = sibling {
    if dot.column != sibling.column {
      return dotArray[sibling.column, sibling.row + 1] != nil
    } else {
      let bottomDot = dot.row > sibling.row ? dot : sibling
      return dotArray[bottomDot.column, bottomDot.row + 1] != nil
    }
  } else {
    return false
  }
}

func dropFallenDots(_ dotArray:DotArray2D) -> Array<GoodDot> {
  var fallenDots = Array<GoodDot>()
  var row = NumRows - 2
  while row >= 0 {
    var fallingDots = Array<GoodDot>()
    
    for column in 0..<NumColumns {
      
      if let dot = dotArray[column, row] as? GoodDot {
        var newRow = row
        while (newRow < NumRows - 1 && dotArray[column, newRow + 1] == nil) {
          newRow += 1
        }

        if let sibling = dot.sibling {
          if sibling.row == dot.row {
            let siblingRow = sibling.row
            var newSiblingRow = sibling.row
            
            while (newSiblingRow < NumRows - 1 && dotArray[sibling.column, newSiblingRow + 1] == nil) {
              newSiblingRow += 1
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
      fallenDots.append(contentsOf: fallingDots)
    }
    
    row -= 1
  }
  
  return fallenDots
}

func checkIfRealChain(_ someChain: Array<Dot>, realChains: inout Array<Dot>) {
  if someChain.count > 3 {
    realChains.append(contentsOf: someChain)
  }
}
