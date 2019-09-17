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
  
  @IBAction func tapCancel(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setLabelColor()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("GameLevel: \(GameLevel)")
    delay(0.2) {
      self.speedSlider.value = Float(GameSpeed)
      self.levelSlider.value = Float(GameLevel)
    }
    
    bgSwitch.isOn = ShowBG
    
    handleMoreLevels()
    handleFifthColor()
    handleNextPiece()
    
    updateLabels()
  }
  
  @IBAction func tapStart(_ sender: UIButton) {
    UserDefaults.standard.setValue(ShowNextPiece, forKey: "showNextPiece")
    UserDefaults.standard.setValue(GameLevel, forKey: "gameLevel")
    UserDefaults.standard.setValue(NumberOfColors, forKey: "numColors")
    UserDefaults.standard.setValue(ShowBG, forKey: "showBG")
    
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
  
  @IBAction func numColorsSwitchChanged(_ sender: UISwitch) {
    NumberOfColors = sender.isOn ? 5 : 4
    updateLabels()
  }
  
  @IBAction func bgSwitchChanged(_ sender: UISwitch) {
    ShowBG = sender.isOn
  }
  
  @IBAction func nextPieceSwitchChanged(_ sender: UISwitch) {
    ShowNextPiece = sender.isOn
  }
  
  func setLabelColor() {
    let color = iPad ? UIColor.white : UIColor.black
    
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
    nextPieceSwitch.isOn = ShowNextPiece
  }
  
  func handleFifthColor() {
    numColorsSwitch.isOn = NumberOfColors == 5
  }
  
  func handleMoreLevels() {
    levelSlider.maximumValue = 20.0
  }
}
