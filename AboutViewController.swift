//
//  AboutViewController.swift
//  MadDots
//
//  Created by Kyle Murphy on 1/1/16.
//  Copyright © 2016 Kyle Murphy. All rights reserved.
//

import Foundation

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
  @IBOutlet weak var webV: UIWebView!
  
  @IBAction func tapClose(_ sender: AnyObject) {
    print("tap close")
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webV.delegate = self
    if let htmlFile = Bundle.main.path(forResource: "about", ofType: "html") {
      let htmlData = try? Data(contentsOf: URL(fileURLWithPath: htmlFile))
      let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
      webV.load(htmlData!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
    }
  }
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
    if navigationType == UIWebView.NavigationType.linkClicked {
      UIApplication.shared.openURL(request.url!)
      return false;
    }
    return true;
  }
  
}
