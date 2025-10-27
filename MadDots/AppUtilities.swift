//
//  AppUtilties.swift
//  Dr. Kodama
//
//  Created by Kyle Murphy on 10/30/21.
//  Copyright © 2021 Kyle Murphy. All rights reserved.
//

import Foundation
import UIKit

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

func findRandomTopDot(dots: Array<MadDot>) -> MadDot? {
  guard !dots.isEmpty else { return nil }

  let topDots = findTopDots(dots: dots)
  guard !topDots.isEmpty else { return nil }

  let num = randomNum(0, max: topDots.count)
  return topDots[num]
}

//func dotColorToUIColor(color: DotColor) -> UIColor {
//  switch color {
//  case .red.spriteName:
//    return UIColor(hex: "#BB0C0C")!
//  case .blue:
//    return UIColor(hex: "#3880E1")!
//  case .yellow:
//    return UIColor(hex: "#EFEF19")!
//  case .green:
//    return UIColor(hex: "#63B237")!
//  case .orange:
//    return UIColor(hex: "#FFB01E")!
//  }
//}

let colormap = [
  "red": UIColor(red: 187/255, green: 12/255, blue: 12/255, alpha: 1),
  "blue": UIColor(red: 56/255, green: 128/255, blue: 225/255, alpha: 1),
  "orange": UIColor(red: 1, green: 176/255, blue: 30/255, alpha: 1),
  "green": UIColor(red: 99/255, green: 178/255, blue: 55/255, alpha: 1),
  "yellow": UIColor(red: 239/255, green: 239/255, blue: 25/255, alpha: 1),
]

func findRealRandomTopDot(dots: Array<MadDot>, dotArray: DotArray2D) -> MadDot? {
  guard !dots.isEmpty else { return nil }

  let zeroOrOne = randomNum(0, max: 2)
  let topDots = zeroOrOne == 0 ? findTopDots(dots: dots) : findRealTopDots(dots: dots, dotArray: dotArray)
  guard !topDots.isEmpty else { return nil }

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
  return Int.random(in: min..<(min + max))
}
