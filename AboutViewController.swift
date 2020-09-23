//
//  AboutViewController.swift
//  MadDots
//
//  Created by Kyle Murphy on 1/1/16.
//  Copyright © 2016 Kyle Murphy. All rights reserved.
//

import Foundation

import UIKit
import WebKit

class AboutViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
  var webView: WKWebView!
  
  override func loadView() {
    let contentController = WKUserContentController();
    contentController.add(self, name: "js")
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    self.webView = WKWebView(frame: .zero, configuration: config)
    self.webView.uiDelegate = self
    
    // https://stackoverflow.com/a/15670274/548170
    self.webView.isOpaque = false
    self.webView.backgroundColor = UIColor.clear
  
    view = self.webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // https://stackoverflow.com/a/49638654/548170
    let url = Bundle.main.url(forResource: "about", withExtension: "html")!
    webView.loadFileURL(url, allowingReadAccessTo: url)
    let request = URLRequest(url: url)
    webView.load(request)

//    if let htmlFile = Bundle.main.path(forResource: "about", ofType: "html") {
//      let htmlData = try? Data(contentsOf: URL(fileURLWithPath: htmlFile))
//      let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
//      webView.load(htmlData!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
//    }
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    //This function handles the events coming from javascript. We'll configure the javascript side of this later.
    //We can access properties through the message body, like this:
    guard let response = message.body as? String else { return }
    self.dismiss(animated: true, completion: nil)
    print(response)
  }

//  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == WKNavigationType.linkActivated {
//          print("link")
//          decisionHandler(WKNavigationActionPolicy.cancel)
//          return
//        }
//        print("no link")
//        decisionHandler(WKNavigationActionPolicy.allow)
//   }

}
