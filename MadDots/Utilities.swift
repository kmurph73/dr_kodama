//
//  Utilities.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/26/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation

func delay(_ delay: Double, closure: @escaping () -> ()) {
  DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}


