//
//  AboutAngry.swift
//  Dr. Kodama
//
//  Created by Kyle Murphy on 12/21/21.
//  Copyright © 2021 Kyle Murphy. All rights reserved.
//

import Foundation

import UIKit

class AboutAngryViewController: UIViewController {
  
  @IBOutlet weak var textViewHeight: NSLayoutConstraint!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var angryDot: UIImageView!
  override func viewWillAppear(_ animated: Bool) {
    self.textView.textContainer.lineBreakMode = .byWordWrapping

//    let height = self.textView.contentSize.height
//    self.textViewHeight.constant = height + 10
    
//    self.textView.sizeToFit()
//    self.angryDot.layer.zPosition = 1000
//    self.angryDot.
    super.viewWillAppear(animated)
  }

  @IBAction func tapDone(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
