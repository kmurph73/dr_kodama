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
var MoreLevels = false
var FifthColor = false
var NextPiece = false

class MainController: UIViewController, StoreControllerDelegate {
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var speedLabel: UILabel!
  @IBOutlet weak var speedSlider: UISlider!
  @IBOutlet weak var levelSlider: UISlider!
  @IBOutlet weak var numColorsLabel: UILabel!
  @IBOutlet weak var numColorsSlider: UISlider!
  
  @IBOutlet weak var bgSwitch: UISwitch!
  @IBAction func speedSliderChanged(slider: UISlider) {
    GameSpeed = lroundf(slider.value)
    updateLabels()
  }
  
  @IBAction func switchBg(sender: UISwitch) {
    ShowBG = sender.on
  }
  
  @IBAction func levelSliderChanged(slider: UISlider) {
    GameLevel = lroundf(slider.value)
    updateLabels()
  }
  
  @IBAction func numColorsSliderChanged(slider: UISlider) {
    NumberOfColors = lroundf(slider.value)
    updateLabels()
  }
  
  @IBAction func tapPlay(sender: AnyObject) {
    NSUserDefaults.standardUserDefaults().setValue(GameLevel, forKey: "gameLevel")
    NSUserDefaults.standardUserDefaults().setValue(GameLevel, forKey: "gameLevel")
    NSUserDefaults.standardUserDefaults().setValue(NumberOfColors, forKey: "numColors")
    NSUserDefaults.standardUserDefaults().setValue(ShowBG, forKey: "showBG")

    self.performSegueWithIdentifier("gogo", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if !MoreLevels {
      levelSlider.maximumValue = 11.0
    }
    
    speedSlider.value = Float(GameSpeed)
    levelSlider.value = Float(GameLevel)
    numColorsSlider.value = Float(NumberOfColors)
    bgSwitch.on = ShowBG

    updateLabels()
  }
  
  @IBAction func tapHelp(sender: AnyObject) {
    self.performSegueWithIdentifier("help", sender: self)
  }
  
  func updateLabels() {
    self.speedLabel.text = "Speed: \(GameSpeed)"
    self.levelLabel.text = "Level: \(GameLevel)"
    self.numColorsLabel.text = "# of colors: \(NumberOfColors)"
  }
  
  func storeController(controller: StoreController, didChangeFifthColor val: Bool) {
    FifthColor = val
  }

  func storeController(controller: StoreController, didChangeMoreLevels val: Bool) {
    MoreLevels = val
  }
  
  func storeController(controller: StoreController, didChangeNextPiece val: Bool) {
    NextPiece = val
  }
  
  func updateFifth() {
    
  }
  
}