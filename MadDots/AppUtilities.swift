//
//  AppUtilties.swift
//  Dr. Kodama
//
//  Created by Kyle Murphy on 10/30/21.
//  Copyright © 2021 Kyle Murphy. All rights reserved.
//

import Foundation

func findTopRow(dots: Array<MadDot>) -> Int {
  var topRow = NumRows

  for dot in dots {
    if dot.row < topRow {
      topRow = dot.row
    }
  }
  
  return topRow
}

func findTopDots(dots: Array<MadDot>, topRow: Int) -> Array<MadDot> {
  var topDots = Array<MadDot>()
  
  for dot in dots {
    if dot.row == topRow {
      topDots.append(dot)
    }
  }
  
  return topDots
}

func findTopDots(dots: Array<MadDot>) -> Array<MadDot> {
  let topRow = findTopRow(dots: dots)
  var topDots = Array<MadDot>()
  
  for dot in dots {
    if dot.row == topRow {
      topDots.append(dot)
    }
  }
  
  return topDots
}

func findRandomTopDot(dots: Array<MadDot>) -> MadDot {
  let topDots = findTopDots(dots: dots)
  let num = randomNum(0, max: topDots.count)
    
  return topDots[num]
}

func findRealRandomTopDot(dots: Array<MadDot>, dotArray: DotArray2D) -> MadDot {
  let topDots = findRealTopDots(dots: dots, dotArray: dotArray)
  let num = randomNum(0, max: topDots.count)
    
  return topDots[num]
}

func findRealTopDots(dots: Array<MadDot>, dotArray: DotArray2D) -> Array<MadDot> {
  var arr = Array<MadDot>()
  for col in 0..<NumColumns {
    for row in 3..<NumRows {
      if let maddot = dotArray[col, row] as? MadDot {
        arr.append(maddot)
        break
      }
    }
  }
  
  return arr
}

func randomNum(_ min: Int, max: Int) -> Int {
  return Int(arc4random_uniform(UInt32(max))) + min
}
