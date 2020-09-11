////
////  StoreViewController.swift
////  MadDots
////
////  Created by Kyle Murphy on 12/27/15.
////  Copyright © 2015 Kyle Murphy. All rights reserved.
////
//
//import Foundation
//import UIKit
//import StoreKit
//
//protocol StoreViewCtrlDelegate {
//  func doneWithStore(_ ctrl: StoreViewController)
//}
//
//class StoreViewController: UITableViewController {
//  @IBOutlet weak var titleLabel: UILabel!
//  @IBOutlet weak var subtitleLabel: UILabel!
//  
//  var delegate: StoreViewCtrlDelegate?
//  
//  var products = [SKProduct]()
//  
//  let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//
//  @IBAction func tapRestore(_ sender: UIBarButtonItem) {
//    self.startSpinning()
//    Products.store.restoreCompletedTransactionsWithCompletionHandler { success, productId in
//      self.stopSpinning()
//      self.tableView.reloadData()
//    }
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    Products.store.requestProductsWithCompletionHandler { success, products in
//      self.products = products
//      self.tableView.reloadData()
//      self.stopSpinning()
//    }
//    
//    Products.store.purchaseCompletedHandler = { success, product in
//      self.tableView.reloadData()
//      self.stopSpinning()
//    }
//    
//    Products.store.purchasingHandler = { started, product in
//      self.tableView.reloadData()
//      self.stopSpinning()
//    }
//    
//    activityView.center = self.view.center
//    activityView.center.y -= 50
//    self.view.addSubview(activityView)
//    startSpinning()
//  }
//  
//  func startSpinning() {
//    delay(0.1) {
//      self.activityView.isHidden = false
//      self.activityView.startAnimating()
//    }
//  }
//  
//  func stopSpinning() {
//    activityView.stopAnimating()
//  }
//  
//  @IBAction func tapDone(_ sender: AnyObject) {
//    Products.store.purchaseCompletedHandler = nil
//    Products.store.purchasingHandler = nil
//    Products.store.restoreCompletedHandler = nil
//    self.delegate?.doneWithStore(self)
//  }
//  
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let product = self.products[indexPath.row]
//    
//    let purchased = UserDefaults.standard.bool(forKey: product.productIdentifier + "Purchased")
//    let purchasing = Products.store.isProductBeingPurchased(product.productIdentifier)
//
//    if !purchased && !purchasing {
//      startSpinning()
//      Products.store.purchaseProduct(product)
//    }
//    
//    tableView.deselectRow(at: indexPath, animated: true)
//  }
//  
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let product = products[indexPath.row]
//    let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath)
//    
//    let title = cell.viewWithTag(1) as! UILabel
//    title.text = product.localizedTitle
//    
//    let subtitle = cell.viewWithTag(2) as! UILabel
//    subtitle.text = product.localizedDescription
//    
//    let purchased = UserDefaults.standard.bool(forKey: product.productIdentifier + "Purchased")
//    let v = cell.contentView
//    
//    if let btn = v.viewWithTag(20) {
//      btn.removeFromSuperview()
//    }
//    
//    if let img = v.viewWithTag(19) {
//      img.removeFromSuperview()
//    }
//    
//    if purchased {
//      guard let image = UIImage(named: "checkmark") else { return cell }
//      let tintedImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//      
//      let imgView = UIImageView(image: tintedImage)
//      imgView.tintColor = UIColor(red: (92 / 255.0), green: (184 / 255.0), blue: (92 / 255.0), alpha: 0.95)
//      imgView.translatesAutoresizingMaskIntoConstraints = false
//      imgView.tag = 19
//      
//      v.addSubview(imgView)
//      
//      v.addConstraint(NSLayoutConstraint(item: imgView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1, constant: 0))
//
//      v.addConstraint(NSLayoutConstraint(item: imgView, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1, constant: -10))
//    } else {
//      let lbl = UILabel()
//      
//      if Products.store.isProductBeingPurchased(product.productIdentifier) {
//        lbl.text = ". . ."
//      } else {
//        lbl.text = product.localizedPrice()
//      }
//      lbl.textColor = UIColor(red: (40 / 255.0), green: (100 / 255.0), blue: (200 / 255.0), alpha: 1)
//      lbl.font = UIFont(name: lbl.font.fontName, size: 15)
//      lbl.tag = 20
//
//      lbl.translatesAutoresizingMaskIntoConstraints = false
//
//      v.addSubview(lbl)
//
//      let constraintButtonWidth = NSLayoutConstraint(item: lbl,
//        attribute: NSLayoutAttribute.width,
//        relatedBy: NSLayoutRelation.equal,
//        toItem: nil,
//        attribute: NSLayoutAttribute.notAnAttribute,
//        multiplier: 1,
//        constant: 50)
//
//      let yConstraint = NSLayoutConstraint(item: lbl, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1, constant: 0)
//
//      v.addConstraint(yConstraint)
//
////      constraintButtonWidth.priority = 999
//      
//      v.addConstraint(constraintButtonWidth)
//      
//      v.addConstraint(NSLayoutConstraint(item: lbl, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1, constant: 2))
//
//    }
//    
//    return cell
//  }
//  
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return products.count
//  }
//  
//  deinit {
//    print("StoreViewController is being deinitialized")
//  }
//  
//}

