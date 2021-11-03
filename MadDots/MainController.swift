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
var AngryKodama = false

var LargerScreen = UIScreen.main.bounds.width > 600

class MainController: UIViewController {

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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }
}
