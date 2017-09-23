//
//  MainController.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/10/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import UIKit
import StoreKit

var GameLevel = 1
var GameSpeed = 5
var NumberOfColors = 4

var ShowBG = false
var ShowNextPiece = false

var MoreLevelsPurchased = true
var NextPiecePurchased = true
var FifthColorPurchased = true

var iPad = false

class MainController: UIViewController, StoreViewCtrlDelegate {

  @IBOutlet weak var backgroundImg: UIImageView!
  @IBOutlet weak var playLabel: UIButton!
  @IBOutlet weak var kodamaLabel: UILabel!
  
  @IBOutlet var viewery: UIView!
  
  @IBAction func tapPlay(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "goSettings", sender: self)
  }
  
  @IBAction func tapStore(_ sender: UIButton) {
    self.performSegue(withIdentifier: "goStore", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let modelName = UIDevice.current.modelName
    let matches = matchesForRegexInText("^iPad", text: modelName)
    if matches.count > 0 {
      iPad = true
    }
    
//    if !RestoredPurchases {
//      Products.store.restoreCompletedTransactions()
//      RestoredPurchases = true
//      NSUserDefaults.standardUserDefaults().setBool(RestoredPurchases, forKey: "restoredPurchases")
//    }
//
//    iPad = true
//    iPadPro = true
    
    if iPad {
      backgroundImg.image = UIImage(named: "ipadfantasybg")
    } else {
      backgroundImg.image = UIImage(named: "fantasyforest")
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction func tapHelp(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "help", sender: self)
  }
  
  func doneWithStore(_ ctrl: StoreViewController) {
    ctrl.dismiss(animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goStore" {
      let navigationController = segue.destination as! UINavigationController
      let vc = navigationController.viewControllers.first as! StoreViewController
      vc.delegate = self
    }
  }
}
