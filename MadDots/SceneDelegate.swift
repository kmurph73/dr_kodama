//
//  SceneDelegate.swift
//  MadDots
//
//  Created by Claude Code
//  Copyright © 2025 Kyle Murphy. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be loaded and attached to the scene.
    guard let _ = (scene as? UIWindowScene) else { return }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    if var topController = window?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        if let gvc = presentedViewController as? GameViewController {
          if !gvc.sheetShown {
            gvc.stopTimer()
            gvc.startTimer()
          }
          break
        } else {
          topController = presentedViewController
        }
      }
    }
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    if var topController = window?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        if let gvc = presentedViewController as? GameViewController {
          gvc.stopTimer()
          break
        } else {
          topController = presentedViewController
        }
      }
    }
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
  }
}
