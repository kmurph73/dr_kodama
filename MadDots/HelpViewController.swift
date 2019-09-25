//
//  HelpController.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/21/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
  @IBOutlet weak var whitedot1: UIImageView!
  @IBOutlet weak var reddot1: UIImageView!
  @IBOutlet weak var reddot2: UIImageView!
  @IBOutlet weak var whitedot2: UIImageView!
  @IBOutlet weak var bluedot1: UIImageView!
  @IBOutlet weak var bluedot2: UIImageView!
  
  @IBOutlet weak var textview: UITextView!
  @IBOutlet weak var aftertap1label: UILabel!
  @IBOutlet weak var bluedot3: UIImageView!
  
  @IBOutlet weak var aftertap2label: UILabel!
  @IBOutlet weak var reddot3: UIImageView!
  @IBOutlet weak var whitedot3: UIImageView!
  @IBOutlet weak var trailingMargin: NSLayoutConstraint!
  
  @IBAction func tapDone(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    textview.sizeToFit()
    
    if iPad {
      self.trailingMargin.constant = view.bounds.size.width / 3.5
    } else {
      self.trailingMargin.constant = view.bounds.size.width / 5
    }
  }
}
