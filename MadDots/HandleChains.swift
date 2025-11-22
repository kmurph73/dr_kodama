//
//  HandleChains.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/18/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

@discardableResult func findChainsForRows(_ dotArray: DotArray2D, realChains: inout Set<Dot>, startRow: Int, endRow: Int) -> Set<Dot> {
  var someChain = Array<Dot>()

  var previousDot: Dot?

  var row = startRow - 1

  while (row >= endRow) {
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

    row -= 1
  }

  checkIfRealChain(someChain, realChains: &realChains)

  return realChains
}

@discardableResult func findChainsForColumns(_ dotArray: DotArray2D, realChains: inout Set<Dot>, startColumn: Int, endColumn: Int) -> Set<Dot> {
  var someChain = Array<Dot>()

  var previousDot: Dot?

  var column = startColumn - 1

  while (column >= endColumn) {
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

    column -= 1
  }

  checkIfRealChain(someChain, realChains: &realChains)

  return realChains
}

func columnHasChain(_ dotArray: DotArray2D, column: Int) -> Bool {
  var chains = Set<Dot>()

  findChainsForColumns(dotArray, realChains: &chains, startColumn: column, endColumn: column)

  return chains.count > 0
}

func rowHasChain(_ dotArray: DotArray2D, row: Int) -> Bool {
  var chains = Set<Dot>()

  findChainsForRows(dotArray, realChains: &chains, startRow: row, endRow: row)

  return chains.count > 0
}

func findAllChains(_ dotArray: DotArray2D) -> Array<Dot> {
  var realChains = Set<Dot>()

  findChainsForColumns(dotArray, realChains: &realChains, startColumn: NumColumns, endColumn: 0)
  findChainsForRows(dotArray, realChains: &realChains, startRow: NumRows, endRow: 0)

  return Array(realChains)
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

func dropFallenDots(_ dotArray: DotArray2D) -> Array<GoodDot> {
  var fallenDots = Array<GoodDot>()
  var processedDots = Set<GoodDot>()
  var row = NumRows - 2

  while row >= 0 {
    for column in 0..<NumColumns {
      guard let dot = dotArray[column, row] as? GoodDot else { continue }

      // Skip if already processed (e.g., as a sibling)
      if processedDots.contains(dot) { continue }

      var newRow = row
      // Find lowest empty position
      while newRow < NumRows - 1 && dotArray[column, newRow + 1] == nil {
        newRow += 1
      }

      // Handle horizontal siblings together
      if let sibling = dot.sibling, sibling.row == dot.row {
        var newSiblingRow = sibling.row

        while newSiblingRow < NumRows - 1 && dotArray[sibling.column, newSiblingRow + 1] == nil {
          newSiblingRow += 1
        }

        // Both dots fall to same level
        let finalRow = min(newRow, newSiblingRow)

        if finalRow > sibling.row {
          dotArray[sibling.column, sibling.row] = nil
          sibling.row = finalRow
          dotArray[sibling.column, finalRow] = sibling
          fallenDots.append(sibling)
          processedDots.insert(sibling)
        }

        if finalRow > dot.row {
          dotArray[column, row] = nil
          dot.row = finalRow
          dotArray[column, finalRow] = dot
          fallenDots.append(dot)
        }
      } else {
        // Single dot or vertical sibling
        if newRow > dot.row {
          dotArray[column, row] = nil
          dot.row = newRow
          dotArray[column, newRow] = dot
          fallenDots.append(dot)
        }
      }

      processedDots.insert(dot)
    }

    row -= 1
  }

  return fallenDots
}

func checkIfRealChain(_ someChain: Array<Dot>, realChains: inout Set<Dot>) {
  if someChain.count >= 4 {
    realChains.formUnion(someChain)
  }
}
