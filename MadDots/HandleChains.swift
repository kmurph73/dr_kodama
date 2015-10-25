//
//  HandleChains.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/18/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func findChainsForRows(dotArray: Array2D<Dot>) -> Set<Dot> {
  var dotsToRemove = Set<Dot>()
  var tempDotsToRemove = Set<Dot>()
  
  var previousDot: Dot?
  
  for var row = NumRows - 1; row > 0; row-- {
    for column in 0..<NumColumns {
      if let dot = dotArray[column, row] {
        if let prevDot = previousDot {
          if prevDot.color == dot.color {
            tempDotsToRemove.insert(prevDot)
            tempDotsToRemove.insert(dot)
          } else {
            if dotsToRemove.count > 3 {
              dotsToRemove = dotsToRemove.union(tempDotsToRemove)
            }
            tempDotsToRemove = Set<Dot>()
          }
          
          previousDot = dot
        } else {
          tempDotsToRemove.insert(dot)
          previousDot = dot
        }
      }
    }
  }
  
  return dotsToRemove
}

func findChainsForColumns(dotArray: Array2D<Dot>) -> Array<Dot> {
  var realChains = Array<Dot>()
  var someChain = Array<Dot>()
  
  var previousDot: Dot?
  
  for var column = NumColumns - 1; column >= 0; column-- {
    checkIfRealChain(someChain, realChains: &realChains)
    
    print("reset chain at start of column")
    someChain = Array<Dot>()
    previousDot = nil
    
    for row in 0..<NumRows {
      print("row: \(row); col: \(column)")
      if let dot = dotArray[column, row] {

        if let prevDot = previousDot {
          if prevDot.color == dot.color {
            someChain.append(dot)
            print("append due to same color: \(someChain)")
          } else {
            print("check if real cuz prev dot doesnt match")
            checkIfRealChain(someChain, realChains: &realChains)
            print("empty chain cuz prev dot dont match")
            someChain = Array<Dot>()
          }
          
          previousDot = dot
        } else {
          someChain.append(dot)
          print("append due to no prev: \(someChain); check if real for no reason")
          checkIfRealChain(someChain, realChains: &realChains)


          previousDot = dot
        }
        
      } else {
        print("reset chain due to no dot")

        someChain = Array<Dot>()
      }
    }
  }
  
  print("check if real chain cuz method is done")
  checkIfRealChain(someChain, realChains: &realChains)
  
  return realChains
}

func dropFallenDots(dotArray: Array2D<Dot>) -> Array<Dot> {
  var fallenDots = Array<Dot>()
  for column in 0..<NumColumns {
    var fallingDots = Array<Dot>()
    for var row = NumRows - 2; row > 0; row-- {
      if let dot = dotArray[column, row] {
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
  print("somechain: \(someChain); real: \(realChains)")

}

func dropFallenDots() {
  
}