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
  
  @IBOutlet weak var angryLabel: UILabel!
  @IBOutlet weak var intervalLabel: UILabel!
  @IBOutlet weak var lengthLabel: UILabel!
  
  @IBOutlet weak var levelSlider: UISlider!
  @IBOutlet weak var speedSlider: UISlider!
  
  @IBOutlet weak var numColorsSwitch: UISwitch!
  @IBOutlet weak var nextPieceSwitch: UISwitch!
  
  @IBOutlet weak var angrySwitch: UISwitch!
  @IBOutlet weak var angryLengthSlider: UISlider!
  @IBOutlet weak var angryIntervalSlider: UISlider!
    
  @IBAction func tapHuh(_ sender: UIButton) {
    self.performSegue(withIdentifier: "aboutAngry", sender: self)
  }
  
  @IBAction func tapCancel(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setLabelColor()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    delay(0.1) {
      self.speedSlider.value = Float(GameSpeed)
      self.levelSlider.value = Float(GameLevel)
      self.angryLengthSlider.value = Float(AngryLengthDefault)
      self.angryIntervalSlider.value = Float(AngryIntervalDefault)
    }
        
    handleMoreLevels()
    handleFifthColor()
    handleNextPiece()
    self.angrySwitch.isOn = AngryKodama
    
    updateLabels()
  }
  
  @IBAction func tapStart(_ sender: UIButton) {
    UserDefaults.standard.setValue(ShowNextPiece, forKey: "showNextPiece")
    UserDefaults.standard.setValue(GameLevel, forKey: "gameLevel")
    UserDefaults.standard.setValue(NumberOfColors, forKey: "numColors")
    UserDefaults.standard.setValue(AngryKodama, forKey: "angryKodama")
    UserDefaults.standard.setValue(AngryIntervalDefault, forKey: "angryIntervalDefault")
    UserDefaults.standard.setValue(AngryLengthDefault, forKey: "angryLengthDefault")

    
    self.performSegue(withIdentifier: "gogo", sender: self)
  }
  
  @IBAction func speedSliderMoved(_ sender: UISlider) {
    GameSpeed = lroundf(sender.value)
    updateLabels()
  }
  
  @IBAction func levelSliderMoved(_ sender: UISlider) {
    GameLevel = lroundf(sender.value)
    updateLabels()
  }
  
  @IBAction func intervalSliderMoved(_ sender: UISlider) {
    AngryIntervalDefault = lroundf(sender.value)
    updateLabels()
  }
  
  @IBAction func lengthSliderMoved(_ sender: UISlider) {
    AngryLengthDefault = lroundf(sender.value)
    updateLabels()
  }
  
  @IBAction func angrySwitchChanged(_ sender: UISwitch) {
    AngryKodama = sender.isOn
  }
  
  @IBAction func numColorsSwitchChanged(_ sender: UISwitch) {
    NumberOfColors = sender.isOn ? 5 : 4
    updateLabels()
  }
  
  @IBAction func nextPieceSwitchChanged(_ sender: UISwitch) {
    ShowNextPiece = sender.isOn
  }
  
  func setLabelColor() {
    let color = iPad ? UIColor.white : UIColor.black
    
    self.nextPieceLabel.textColor = color
    self.numColorsLabel.textColor = color
    self.lengthLabel.textColor = color
    self.intervalLabel.textColor = color
    self.angryLabel.textColor = color
  }
  
  func updateLabels() {
//    self.speedLabel.text = "Speed: \(GameSpeed)"
    self.levelLabel.text = "Level: \(GameLevel)"
    self.numColorsLabel.text = "# of colors: \(NumberOfColors)"
//    self.lengthLabel.text = "L: \(AngryLengthDefault)"
//    self.intervalLabel.text = "I: \(AngryIntervalDefault)"
  }
  
  func handleNextPiece() {
    nextPieceSwitch.isOn = ShowNextPiece
  }
  
  func handleFifthColor() {
    numColorsSwitch.isOn = NumberOfColors == 5
  }
  
  func handleMoreLevels() {
    levelSlider.maximumValue = 20.0
  }
}
