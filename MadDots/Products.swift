//
//  Products.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/27/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation
import StoreKit

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum Products {
  
  /// TODO:  Change this to whatever you set on iTunes connect
  fileprivate static let Prefix = "com.blah.kmurphles.kodama."
    
  /// MARK: - Supported Product Identifiers
  public static let ShowNextPieceProduct = "shownextpiece2"
  public static let FifthColorProduct = "fifthcolor2"
  public static let MoreLevelsProduct = "morelevels2"
  
  // All of the products assembled into a set of product identifiers.
  fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.ShowNextPieceProduct, Products.FifthColorProduct, Products.MoreLevelsProduct]
  
  /// Static instance of IAPHelper that for rage products.
  public static let store = IAPHelper(productIdentifiers: Products.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}