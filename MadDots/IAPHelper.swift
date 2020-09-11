////
////  IAPHelper.swift
////  MadDots
////
////  Created by Kyle Murphy on 12/27/15.
////  Copyright © 2015 Kyle Murphy. All rights reserved.
////
//
//import Foundation
////
////  IAPHelper.swift
////  inappragedemo
////
////  Created by Ray Fix on 5/1/15.
////  Copyright (c) 2015 Razeware LLC. All rights reserved.
////
//
//import StoreKit
//
///// Notification that is generated when a product is purchased.
//public let IAPHelperProductPurchasedNotification = "IAPHelperProductPurchasedNotification"
//
///// Product identifiers are unique strings registered on the app store.
//public typealias ProductIdentifier = String
//
///// Completion handler called when products are fetched.
//public typealias RequestProductsCompletionHandler = (_ success: Bool, _ products: [SKProduct]) -> ()
//public typealias PurchaseCompletedHandler = (_ success: Bool, _ productIdentifier: String) -> ()
//typealias PurchasingHandler = (_ started: Bool, _ productIdentifier: String) -> ()
//
///// A Helper class for In-App-Purchases, it can fetch products, tell you if a product has been purchased,
///// purchase products, and restore purchases.  Uses NSUserDefaults to cache if a product has been purchased.
//open class IAPHelper : NSObject  {
//
//  /// MARK: - Private Properties
//
//  // Used to keep track of the possible products and which ones have been purchased.
//  fileprivate let productIdentifiers: Set<ProductIdentifier>
//  fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
//  fileprivate var purchasingProductIdentifiers = Set<ProductIdentifier>()
//
//  // Used by SKProductsRequestDelegate
//  fileprivate var productsRequest: SKProductsRequest?
//  fileprivate var completionHandler: RequestProductsCompletionHandler?
//  var purchaseCompletedHandler: PurchaseCompletedHandler?
//  var purchasingHandler: PurchasingHandler?
//  var restoreCompletedHandler: PurchaseCompletedHandler?
//
//  /// MARK: - User facing API
//
//  /// Initialize the helper.  Pass in the set of ProductIdentifiers supported by the app.
//  public init(productIdentifiers: Set<ProductIdentifier>) {
//    self.productIdentifiers = productIdentifiers
//    for productIdentifier in productIdentifiers {
//      let purchased = UserDefaults.standard.bool(forKey: productIdentifier + "Purchased")
//      if purchased {
//        purchasedProductIdentifiers.insert(productIdentifier)
//        print("Previously purchased: \(productIdentifier)")
//      }
//      else {
//        print("Not purchased: \(productIdentifier)")
//      }
//    }
//
//    super.init()
//    SKPaymentQueue.default().add(self)
//  }
//
//  /// Gets the list of SKProducts from the Apple server calls the handler with the list of products.
//  open func requestProductsWithCompletionHandler(_ handler: @escaping RequestProductsCompletionHandler) {
//    completionHandler = handler
//    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
//    productsRequest?.delegate = self
//    productsRequest?.start()
//  }
//
//  /// Initiates purchase of a product.
//  open func purchaseProduct(_ product: SKProduct) {
//    let payment = SKPayment(product: product)
//    SKPaymentQueue.default().add(payment)
//  }
//
//  /// Given the product identifier, returns true if that product has been purchased.
//  open func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
//    return purchasedProductIdentifiers.contains(productIdentifier)
//  }
//
//  open func isProductBeingPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
//    return purchasingProductIdentifiers.contains(productIdentifier)
//  }
//
//  /// If the state of whether purchases have been made is lost  (e.g. the
//  /// user deletes and reinstalls the app) this will recover the purchases.
//  open func restoreCompletedTransactions() {
//    SKPaymentQueue.default().restoreCompletedTransactions()
//  }
//
//  open func restoreCompletedTransactionsWithCompletionHandler(_ handler: @escaping PurchaseCompletedHandler) {
//    self.restoreCompletedHandler = handler
//    SKPaymentQueue.default().restoreCompletedTransactions()
//  }
//
//  open class func canMakePayments() -> Bool {
//    return SKPaymentQueue.canMakePayments()
//  }
//}
//
//// This extension is used to get a list of products, their titles, descriptions,
//// and prices from the Apple server.
//
//extension IAPHelper: SKProductsRequestDelegate {
//  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//    print("Loaded list of products...")
//    let products = response.products
//    completionHandler?(true, products)
//    clearRequest()
//
//    // debug printing
//    for p in products {
//      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
//    }
//  }
//
//  public func request(_ request: SKRequest, didFailWithError error: Error) {
//    print("Failed to load list of products.")
//    print("Error: \(error)")
//    clearRequest()
//  }
//
//  fileprivate func clearRequest() {
//    productsRequest = nil
//    completionHandler = nil
//  }
//}
//
//
//extension IAPHelper: SKPaymentTransactionObserver {
//  /// This is a function called by the payment queue, not to be called directly.
//  /// For each transaction act accordingly, save in the purchased cache, issue notifications,
//  /// mark the transaction as complete.
//  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//    for transaction in transactions {
//      switch (transaction.transactionState) {
//      case .purchased:
//        completeTransaction(transaction)
//        break
//      case .failed:
//        failedTransaction(transaction)
//        break
//      case .restored:
//        restoreTransaction(transaction)
//        break
//      case .deferred:
//        stopPurchasing(transaction.payment.productIdentifier)
//        break
//      case .purchasing:
//        setPurchasing(transaction)
//        break
//      }
//    }
//  }
//
//  fileprivate func setPurchasing(_ transaction: SKPaymentTransaction) {
//    purchasingProductIdentifiers.insert(transaction.payment.productIdentifier)
//    purchasingHandler?(true, transaction.payment.productIdentifier)
//    print("ho: \(transaction.payment.productIdentifier)")
//  }
//
//  fileprivate func completeTransaction(_ transaction: SKPaymentTransaction) {
//    stopPurchasing(transaction.payment.productIdentifier)
//
//    print("completeTransaction...")
//    provideContentForProductIdentifier(transaction.payment.productIdentifier)
//    SKPaymentQueue.default().finishTransaction(transaction)
//  }
//
//  fileprivate func restoreTransaction(_ transaction: SKPaymentTransaction) {
//    stopPurchasing(transaction.payment.productIdentifier)
//    let productIdentifier = transaction.original!.payment.productIdentifier
//    print("restoreTransaction... \(productIdentifier)")
//    provideContentForProductIdentifier(productIdentifier)
//    SKPaymentQueue.default().finishTransaction(transaction)
//
//    if productIdentifier == "shownextpiece" {
//      NextPiecePurchased = true
//      UserDefaults.standard.setValue(NextPiecePurchased, forKey: "shownextpiecePurchased")
//    }
//
//    restoreCompletedHandler?(true, productIdentifier)
//  }
//
//  fileprivate func stopPurchasing(_ productIdentifier: String) {
//    purchasingProductIdentifiers.remove(productIdentifier)
//    purchasingHandler?(false, productIdentifier)
//  }
//
//  // Helper: Saves the fact that the product has been purchased and posts a notification.
//  fileprivate func provideContentForProductIdentifier(_ productIdentifier: String) {
//    purchasedProductIdentifiers.insert(productIdentifier)
//    UserDefaults.standard.set(true, forKey: productIdentifier + "Purchased")
//    UserDefaults.standard.synchronize()
//    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelperProductPurchasedNotification), object: productIdentifier + "Purchased")
//
//    if let pc = purchaseCompletedHandler {
//      assessState()
//      pc(true, productIdentifier)
//    }
//  }
//
//  fileprivate func failedTransaction(_ transaction: SKPaymentTransaction) {
//    stopPurchasing(transaction.payment.productIdentifier)
//
//    print("failedTransaction...")
//    if transaction.error!._code != SKError.paymentCancelled.rawValue {
//      print("Transaction error: \(transaction.error!.localizedDescription)")
//    }
//    SKPaymentQueue.default().finishTransaction(transaction)
//  }
//}

