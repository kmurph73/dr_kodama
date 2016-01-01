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
  func boughtFifthColor()
  func boughtMoreLevels()
  func boughtNextPiece()
}

class StoreController: UIViewController {
  var delegate: StoreControllerDelegate!
    
  @IBOutlet weak var moreLevelsSwitch: UISwitch!
  @IBOutlet weak var nextPieceSwitch: UISwitch!
  @IBOutlet weak var numColorsSwitch: UISwitch!
  
  @IBOutlet weak var buyMoreLevelsBtn: UIButton!
  @IBOutlet weak var buyNextPieceBtn: UIButton!
  @IBOutlet weak var buyFifthColorBtn: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    moreLevelsSwitch.on = MoreLevelsPurchased
    nextPieceSwitch.on = NextPiecePurchased
    numColorsSwitch.on = FifthColorPurchased
  }

  @IBAction func tapDone(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func buyNextPiece(sender: UIButton) {
    delegate.boughtFifthColor()
  }

  @IBAction func buyFifthColor(sender: UIButton) {
    delegate.boughtMoreLevels()
  }
  
  @IBAction func buyLevels(sender: UIButton) {
    delegate.boughtNextPiece()
  }
  
  @IBAction func moreLevelsSwitch(sender: UISwitch) {
  }
  
  @IBAction func nextPieceSwitch(sender: UISwitch) {
  }
  
  @IBAction func fifthColorSwitched(sender: UISwitch) {
  }
}
