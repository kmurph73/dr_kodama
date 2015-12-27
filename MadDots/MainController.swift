//
//  MainController.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/10/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import UIKit

var GameLevel = 1
var GameSpeed = 5
var NumberOfColors = 4

var ShowBG = false
var ShowNextPiece = false

var MoreLevelsPurchased = false
var NextPiecePurchased = false
var FifthColorPurchased = false

var iPad = false

class MainController: UIViewController, StoreControllerDelegate {

  @IBOutlet weak var backgroundImg: UIImageView!
  @IBOutlet weak var playLabel: UIButton!
  @IBOutlet weak var kodamaLabel: UILabel!
  
  @IBOutlet var viewery: UIView!
  
  @IBAction func tapPlay(sender: AnyObject) {
    self.performSegueWithIdentifier("goSettings", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let modelName = UIDevice.currentDevice().modelName
    let matches = matchesForRegexInText("^iPad", text: modelName)
    if matches.count > 0 {
      iPad = true
    }
    
//    iPad = true
    
    if iPad {
      backgroundImg.image = UIImage(named: "ipadfantasybg")
    } else {
      backgroundImg.image = UIImage(named: "fantasyforest")
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction func tapHelp(sender: AnyObject) {
    self.performSegueWithIdentifier("help", sender: self)
  }
  
  func storeController(controller: StoreController, didChangeFifthColor val: Bool) {
    FifthColorPurchased = val
    NSUserDefaults.standardUserDefaults().setValue(FifthColorPurchased, forKey: "fifthColorPurchased")
  }

  func storeController(controller: StoreController, didChangeMoreLevels val: Bool) {
    MoreLevelsPurchased = val
    NSUserDefaults.standardUserDefaults().setValue(MoreLevelsPurchased, forKey: "moreLevelsPurchased")
  }
  
  func storeController(controller: StoreController, didChangeNextPiece val: Bool) {
    NextPiecePurchased = val
    NSUserDefaults.standardUserDefaults().setValue(NextPiecePurchased, forKey: "nextPiecePurchased")
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "goStore" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let vc = navigationController.viewControllers.first as! StoreController
      vc.delegate = self
    }
  }
}