//
//  IAPHelper.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/27/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation
//
//  IAPHelper.swift
//  inappragedemo
//
//  Created by Ray Fix on 5/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import StoreKit

/// Notification that is generated when a product is purchased.
public let IAPHelperProductPurchasedNotification = "IAPHelperProductPurchasedNotification"

/// Product identifiers are unique strings registered on the app store.
public typealias ProductIdentifier = String

/// Completion handler called when products are fetched.
public typealias RequestProductsCompletionHandler = (success: Bool, products: [SKProduct]) -> ()
public typealias PurchaseCompletedHandler = (success: Bool, productIdentifier: String) -> ()
typealias PurchasingHandler = (started: Bool, productIdentifier: String) -> ()

/// A Helper class for In-App-Purchases, it can fetch products, tell you if a product has been purchased,
/// purchase products, and restore purchases.  Uses NSUserDefaults to cache if a product has been purchased.
public class IAPHelper : NSObject  {
  
  /// MARK: - Private Properties
  
  // Used to keep track of the possible products and which ones have been purchased.
  private let productIdentifiers: Set<ProductIdentifier>
  private var purchasedProductIdentifiers = Set<ProductIdentifier>()
  private var purchasingProductIdentifiers = Set<ProductIdentifier>()
  
  // Used by SKProductsRequestDelegate
  private var productsRequest: SKProductsRequest?
  private var completionHandler: RequestProductsCompletionHandler?
  var purchaseCompletedHandler: PurchaseCompletedHandler?
  var purchasingHandler: PurchasingHandler?
  var restoreCompletedHandler: PurchaseCompletedHandler?

  /// MARK: - User facing API
  
  /// Initialize the helper.  Pass in the set of ProductIdentifiers supported by the app.
  public init(productIdentifiers: Set<ProductIdentifier>) {
    self.productIdentifiers = productIdentifiers
    for productIdentifier in productIdentifiers {
      let purchased = NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier + "Purchased")
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
        print("Previously purchased: \(productIdentifier)")
      }
      else {
        print("Not purchased: \(productIdentifier)")
      }
    }
    
    super.init()
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
  }
  
  /// Gets the list of SKProducts from the Apple server calls the handler with the list of products.
  public func requestProductsWithCompletionHandler(handler: RequestProductsCompletionHandler) {
    completionHandler = handler
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }
  
  /// Initiates purchase of a product.
  public func purchaseProduct(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.defaultQueue().addPayment(payment)
  }
  
  /// Given the product identifier, returns true if that product has been purchased.
  public func isProductPurchased(productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }
  
  public func isProductBeingPurchased(productIdentifier: ProductIdentifier) -> Bool {
    return purchasingProductIdentifiers.contains(productIdentifier)
  }
  
  /// If the state of whether purchases have been made is lost  (e.g. the
  /// user deletes and reinstalls the app) this will recover the purchases.
  public func restoreCompletedTransactions() {
    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
  }
  
  public func restoreCompletedTransactionsWithCompletionHandler(handler: PurchaseCompletedHandler) {
    self.restoreCompletedHandler = handler
    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
}

// This extension is used to get a list of products, their titles, descriptions,
// and prices from the Apple server.

extension IAPHelper: SKProductsRequestDelegate {
  public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    print("Loaded list of products...")
    let products = response.products
    completionHandler?(success: true, products: products)
    clearRequest()
    
    // debug printing
    for p in products {
      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
    }
  }
  
  public func request(request: SKRequest, didFailWithError error: NSError) {
    print("Failed to load list of products.")
    print("Error: \(error)")
    clearRequest()
  }
  
  private func clearRequest() {
    productsRequest = nil
    completionHandler = nil
  }
}


extension IAPHelper: SKPaymentTransactionObserver {
  /// This is a function called by the payment queue, not to be called directly.
  /// For each transaction act accordingly, save in the purchased cache, issue notifications,
  /// mark the transaction as complete.
  public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .Purchased:
        completeTransaction(transaction)
        break
      case .Failed:
        failedTransaction(transaction)
        break
      case .Restored:
        restoreTransaction(transaction)
        break
      case .Deferred:
        stopPurchasing(transaction.payment.productIdentifier)
        break
      case .Purchasing:
        setPurchasing(transaction)
        break
      }
    }
  }
  
  private func setPurchasing(transaction: SKPaymentTransaction) {
    purchasingProductIdentifiers.insert(transaction.payment.productIdentifier)
    purchasingHandler?(started: true, productIdentifier: transaction.payment.productIdentifier)
    print("ho: \(transaction.payment.productIdentifier)")
  }
  
  private func completeTransaction(transaction: SKPaymentTransaction) {
    stopPurchasing(transaction.payment.productIdentifier)

    print("completeTransaction...")
    provideContentForProductIdentifier(transaction.payment.productIdentifier)
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
  
  private func restoreTransaction(transaction: SKPaymentTransaction) {
    stopPurchasing(transaction.payment.productIdentifier)
    let productIdentifier = transaction.originalTransaction!.payment.productIdentifier
    print("restoreTransaction... \(productIdentifier)")
    provideContentForProductIdentifier(productIdentifier)
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    
    if productIdentifier == "shownextpiece" {
      NextPiecePurchased = true
      NSUserDefaults.standardUserDefaults().setValue(NextPiecePurchased, forKey: "shownextpiecePurchased")
    }
    
    restoreCompletedHandler?(success: true, productIdentifier: productIdentifier)
  }
  
  private func stopPurchasing(productIdentifier: String) {
    purchasingProductIdentifiers.remove(productIdentifier)
    purchasingHandler?(started: false, productIdentifier: productIdentifier)
  }
  
  // Helper: Saves the fact that the product has been purchased and posts a notification.
  private func provideContentForProductIdentifier(productIdentifier: String) {
    purchasedProductIdentifiers.insert(productIdentifier)
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: productIdentifier + "Purchased")
    NSUserDefaults.standardUserDefaults().synchronize()
    NSNotificationCenter.defaultCenter().postNotificationName(IAPHelperProductPurchasedNotification, object: productIdentifier + "Purchased")
    
    if let pc = purchaseCompletedHandler {
      assessState()
      pc(success: true, productIdentifier: productIdentifier)
    }
  }
  
  private func failedTransaction(transaction: SKPaymentTransaction) {
    stopPurchasing(transaction.payment.productIdentifier)

    print("failedTransaction...")
    if transaction.error!.code != SKErrorPaymentCancelled {
      print("Transaction error: \(transaction.error!.localizedDescription)")
    }
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
}