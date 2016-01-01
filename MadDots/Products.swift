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
  private static let Prefix = "com.blah.kmurphles.kodama."
    
  /// MARK: - Supported Product Identifiers
  public static let ShowNextPieceProduct = "shownextpiece"
  public static let FifthColorProduct = "fifthcolor"
  public static let MoreLevelsProduct = "morelevels"
  
  // All of the products assembled into a set of product identifiers.
  private static let productIdentifiers: Set<ProductIdentifier> = [Products.ShowNextPieceProduct, Products.FifthColorProduct, Products.MoreLevelsProduct]
  
  /// Static instance of IAPHelper that for rage products.
  public static let store = IAPHelper(productIdentifiers: Products.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
  return productIdentifier.componentsSeparatedByString(".").last
}