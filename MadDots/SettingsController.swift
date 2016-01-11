//
//  SettingsController.swift
//  MadDots
//
//  Created by Kyle Murphy on 12/19/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
  @IBOutlet weak var speedLabel: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var numColorsLabel: UILabel!
  @IBOutlet weak var nextPieceLabel: UILabel!
  @IBOutlet weak var levelSlider: UISlider!
  @IBOutlet weak var speedSlider: UISlider!
  @IBOutlet weak var showBgLabel: UILabel!
  
  @IBOutlet weak var numColorsSwitch: UISwitch!
  @IBOutlet weak var nextPieceSwitch: UISwitch!
  @IBOutlet weak var bgSwitch: UISwitch!
  
  @IBAction func tapCancel(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setLabelColor()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    print("GameLevel: \(GameLevel)")
    delay(0.2) {
      self.speedSlider.value = Float(GameSpeed)
      self.levelSlider.value = Float(GameLevel)
    }
    
    bgSwitch.on = ShowBG
    
    handleMoreLevels()
    handleFifthColor()
    handleNextPiece()
    
    updateLabels()
  }
  
  @IBAction func tapStart(sender: UIButton) {
    NSUserDefaults.standardUserDefaults().setValue(ShowNextPiece, forKey: "showNextPiece")
    NSUserDefaults.standardUserDefaults().setValue(GameLevel, forKey: "gameLevel")
    NSUserDefaults.standardUserDefaults().setValue(NumberOfColors, forKey: "numColors")
    NSUserDefaults.standardUserDefaults().setValue(ShowBG, forKey: "showBG")
    
    self.performSegueWithIdentifier("gogo", sender: self)
  }
  
  @IBAction func speedSliderMoved(sender: UISlider) {
    GameSpeed = lroundf(sender.value)
    updateLabels()
  }
  
  @IBAction func levelSliderMoved(sender: UISlider) {
    GameLevel = lroundf(sender.value)
    updateLabels()
  }
  
  @IBAction func numColorsSwitchChanged(sender: UISwitch) {
    NumberOfColors = sender.on ? 5 : 4
    updateLabels()
  }
  
  @IBAction func bgSwitchChanged(sender: UISwitch) {
    ShowBG = sender.on
  }
  
  @IBAction func nextPieceSwitchChanged(sender: UISwitch) {
    ShowNextPiece = sender.on
  }
  
  func setLabelColor() {
    let color = iPad ? UIColor.whiteColor() : UIColor.blackColor()
    
    self.showBgLabel.textColor = color
    self.nextPieceLabel.textColor = color
    self.numColorsLabel.textColor = color
  }
  
  func updateLabels() {
    self.speedLabel.text = "Speed: \(GameSpeed)"
    self.levelLabel.text = "Level: \(GameLevel)"
    self.numColorsLabel.text = "# of colors: \(NumberOfColors)"
  }
  
  func handleNextPiece() {
    let hidden = NextPiecePurchased ? false : true
    nextPieceSwitch.on = ShowNextPiece
    nextPieceSwitch.hidden = hidden
    nextPieceLabel.hidden = hidden
  }
  
  func handleFifthColor() {
    let hidden = FifthColorPurchased ? false : true
    numColorsSwitch.on = NumberOfColors == 5
    numColorsLabel.hidden = hidden
    numColorsSwitch.hidden = hidden
  }
  
  func handleMoreLevels() {
    if MoreLevelsPurchased {
      levelSlider.maximumValue = 20.0
    } else {
      levelSlider.maximumValue = 11.0
    }
  }
}