//
//  Utilities.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/26/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func matchesForRegexInText(_ regex: String!, text: String!) -> [String] {
  do {
    let regex =  try NSRegularExpression(pattern: regex, options: [])
    let nsString = text as NSString
    let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
    return results.map { nsString.substring(with: $0.range)}
  } catch let error as NSError {
    print("invalid regex: \(error.localizedDescription)")
    return []
  }
}

