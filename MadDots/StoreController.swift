//
//  StoreController.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/7/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import Foundation
import UIKit

protocol StoreControllerDelegate {
  func storeController(controller: StoreController, didChangeMoreLevels: Bool)
  func storeController(controller: StoreController, didChangeNextPiece: Bool)
  func storeController(controller: StoreController, didChangeFifthColor: Bool)
}

class StoreController: UIViewController {
  var delegate: StoreControllerDelegate!
  
  @IBOutlet weak var moreLevelsSwitch: UISwitch!
  @IBOutlet weak var nextPieceSwitch: UISwitch!
  @IBOutlet weak var numColorsSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    moreLevelsSwitch.on = MoreLevelsPurchased
    nextPieceSwitch.on = NextPiecePurchased
    numColorsSwitch.on = FifthColorPurchased
    
  }

  @IBAction func tapDone(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func moreLevelsSwitch(sender: UISwitch) {
    delegate.storeController(self, didChangeMoreLevels: sender.on)
  }
  
  @IBAction func nextPieceSwitch(sender: UISwitch) {
    delegate.storeController(self, didChangeNextPiece: sender.on)
  }
  
  @IBAction func fifthColorSwitched(sender: UISwitch) {
    delegate.storeController(self, didChangeFifthColor: sender.on)
  }
}
