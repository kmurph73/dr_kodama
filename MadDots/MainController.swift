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

class MainController: UIViewController {
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var speedLabel: UILabel!
  @IBOutlet weak var speedSlider: UISlider!
  @IBOutlet weak var levelSlider: UISlider!
  
  @IBAction func speedSliderChanged(slider: UISlider) {
    GameSpeed = lroundf(slider.value)
    updateLabels()
  }
  
  @IBAction func levelSliderChanged(slider: UISlider) {
    GameLevel = lroundf(slider.value)
    updateLabels()
  }
  
  @IBAction func tapPlay(sender: AnyObject) {
    self.performSegueWithIdentifier("gogo", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    speedSlider.value = Float(GameSpeed)
    levelSlider.value = Float(GameLevel)
    
    updateLabels()
  }
  
  @IBAction func tapHelp(sender: AnyObject) {
    self.performSegueWithIdentifier("help", sender: self)
  }
  
  func updateLabels() {
    self.speedLabel.text = "Speed: \(GameSpeed)"
    self.levelLabel.text = "Level: \(GameLevel)"
  }
  
}