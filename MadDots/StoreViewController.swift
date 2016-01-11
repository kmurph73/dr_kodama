//
//  StoreViewController.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/27/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

protocol StoreViewCtrlDelegate {
  func doneWithStore(ctrl: StoreViewController)
}

class StoreViewController: UITableViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  var delegate: StoreViewCtrlDelegate?
  
  var products = [SKProduct]()
  
  let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    Products.store.requestProductsWithCompletionHandler { success, products in
      self.products = products
      self.tableView.reloadData()
      self.stopSpinning()
    }
    
    Products.store.purchaseCompletedHandler = { success, product in
      self.tableView.reloadData()
      self.stopSpinning()
    }
    
    Products.store.purchasingHandler = { started, product in
      self.tableView.reloadData()
      self.stopSpinning()
    }
    
    activityView.center = self.view.center
    activityView.center.y -= 50
    self.view.addSubview(activityView)
    startSpinning()
  }
  
  func startSpinning() {
    delay(0.1) {
      self.activityView.hidden = false
      self.activityView.startAnimating()
    }
  }
  
  func stopSpinning() {
    activityView.stopAnimating()
  }
  
  @IBAction func tapDone(sender: AnyObject) {
    Products.store.purchaseCompletedHandler = nil
    self.delegate?.doneWithStore(self)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let product = self.products[indexPath.row]
    
    let purchased = NSUserDefaults.standardUserDefaults().boolForKey(product.productIdentifier + "Purchased")
    let purchasing = Products.store.isProductBeingPurchased(product.productIdentifier)

    if !purchased && !purchasing {
      startSpinning()
      Products.store.purchaseProduct(product)
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let product = products[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("storeCell", forIndexPath: indexPath)
    
    let title = cell.viewWithTag(1) as! UILabel
    title.text = product.localizedTitle
    
    let subtitle = cell.viewWithTag(2) as! UILabel
    subtitle.text = product.localizedDescription
    
    let purchased = NSUserDefaults.standardUserDefaults().boolForKey(product.productIdentifier + "Purchased")
    let v = cell.contentView
    
    if let btn = v.viewWithTag(20) {
      btn.removeFromSuperview()
    }
    
    if let img = v.viewWithTag(19) {
      img.removeFromSuperview()
    }
    
    if purchased {
      guard let image = UIImage(named: "checkmark") else { return cell }
      let tintedImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
      
      let imgView = UIImageView(image: tintedImage)
      imgView.tintColor = UIColor(red: (92 / 255.0), green: (184 / 255.0), blue: (92 / 255.0), alpha: 0.95)
      imgView.translatesAutoresizingMaskIntoConstraints = false
      imgView.tag = 19
      
      v.addSubview(imgView)
      
      v.addConstraint(NSLayoutConstraint(item: imgView, attribute: .CenterY, relatedBy: .Equal, toItem: v, attribute: .CenterY, multiplier: 1, constant: 0))

      v.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Trailing, relatedBy: .Equal, toItem: v, attribute: .Trailing, multiplier: 1, constant: -10))
    } else {
      let lbl = UILabel()
      
      if Products.store.isProductBeingPurchased(product.productIdentifier) {
        lbl.text = ". . ."
      } else {
        lbl.text = product.localizedPrice()
      }
      lbl.textColor = UIColor(red: (40 / 255.0), green: (100 / 255.0), blue: (200 / 255.0), alpha: 1)
      lbl.font = UIFont(name: lbl.font.fontName, size: 15)
      lbl.tag = 20

      lbl.translatesAutoresizingMaskIntoConstraints = false

      v.addSubview(lbl)

      let constraintButtonWidth = NSLayoutConstraint(item: lbl,
        attribute: NSLayoutAttribute.Width,
        relatedBy: NSLayoutRelation.Equal,
        toItem: nil,
        attribute: NSLayoutAttribute.NotAnAttribute,
        multiplier: 1,
        constant: 50)

      let yConstraint = NSLayoutConstraint(item: lbl, attribute: .CenterY, relatedBy: .Equal, toItem: v, attribute: .CenterY, multiplier: 1, constant: 0)

      v.addConstraint(yConstraint)

//      constraintButtonWidth.priority = 999
      
      v.addConstraint(constraintButtonWidth)
      
      v.addConstraint(NSLayoutConstraint(item: lbl, attribute: .Trailing, relatedBy: .Equal, toItem: v, attribute: .Trailing, multiplier: 1, constant: 2))

    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
}