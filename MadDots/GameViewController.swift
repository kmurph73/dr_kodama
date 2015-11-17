//
//  GameViewController.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright (c) 2015 Kyle Murphy. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, DotGameDelegate, UIGestureRecognizerDelegate {
  var dotGame:DotGame!
  var scene: GameScene!
  var panPointReference:CGPoint?
  var justEnded = false

  @IBAction func didTap(sender: UITapGestureRecognizer) {
    if !scene.menuTapped {
      dotGame.rotatePiece()
      scene.menuTapped = false
    }
  }
  
  @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
    dotGame.movePieceRight()
  }
  
  @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
    dotGame.movePieceLeft()
  }
  
  @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
    dotGame.lowerPiece()
  }
  
  func setLevelLabel() {
    self.scene.setLevelLabel()
  }
  
  func showSheet(msg: String?) {
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .ActionSheet)
    
    let newGame = UIAlertAction(title: "New Game", style: .Default, handler: { action in
      self.dotGame.beginAnew()
    })
    
    alertController.addAction(newGame)
    
    let menu = UIAlertAction(title: "Menu", style: .Default, handler: { _ in
      self.backToMenu()
    })
    
    alertController.addAction(menu)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
      self.scene.resumeGame()
    })
    alertController.addAction(cancelAction)
    
    presentViewController(alertController, animated:true, completion: nil)
  }
  
  func backToMenu() {
    self.scene.ctrl = nil
    self.scene.tick = nil
    self.scene.lastTick = nil
    self.scene = nil
    
    self.dotGame.delegate = nil
    self.dotGame = nil
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func didPan(sender: UIPanGestureRecognizer) {
    let currentPoint = sender.translationInView(self.view)

    if let originalPoint = panPointReference {
      let velocity = sender.velocityInView(self.view)
      let downDistance = abs(currentPoint.y - originalPoint.y)
      let horizontalDistance = abs(currentPoint.x - originalPoint.x)

      if downDistance > (BlockSize * 0.55) {
        if velocity.y > CGFloat(0) {
          dotGame.movePieceDown()
          panPointReference = currentPoint
        } else {
          panPointReference = currentPoint
        }
      }
      
      if horizontalDistance > (BlockSize * 0.55) {
        if velocity.x > CGFloat(0) {
          dotGame.movePieceRight()
          panPointReference = currentPoint
        } else {

          if !justEnded {
            dotGame.movePieceLeft()
            panPointReference = currentPoint
          }

        }
      }
    } else if sender.state == .Began {
      panPointReference = currentPoint
    }
    
    if sender.state == .Ended {
      panPointReference = nil
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\(self) did load")

    // Configure the view.
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.multipleTouchEnabled = false
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    scene = GameScene(size: skView.bounds.size)
    scene.ctrl = self
    scene.scaleMode = .AspectFill
    scene.tick = didTick      
    
    dotGame = DotGame()
    dotGame.delegate = self
    dotGame.fallingPiece = nil
    dotGame.beginGame()
    
    skView.presentScene(scene)
  }

  override func shouldAutorotate() -> Bool {
      return false
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
      if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
          return .AllButUpsideDown
      } else {
          return .All
      }
  }
  
  func gameDidEnd(dotGame: DotGame) {
    print("end game")
    let msg = "You blew it!"
    showSheet(msg)
  }
  
  func gamePieceDidLand(dotGame: DotGame) {
    scene.stopTicking()
    self.view.userInteractionEnabled = false

    let results = dotGame.removeCompletedDots()
    let dotsToRemove = results.dotsToRemove
    let fallenDots = results.fallenDots
    
    if dotsToRemove.count > 0 {
      scene.removeDots(dotsToRemove)
      if dotGame.dotArray.hasAchievedVictory() {
        if GameLevel == 18 {
          let msg = "You won!"
          let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
          let okAction = UIAlertAction(title: "OMG pinch me", style: .Default, handler: { _ in
            self.backToMenu()
          })
          alertController.addAction(okAction)
          self.presentViewController(alertController, animated: true, completion: nil)
        } else {
          GameLevel += 1
          dotGame.beginAnew()
        }
        
      } else {
        scene.dropDots(fallenDots) {
          self.gamePieceDidLand(dotGame)
        }
      }
    } else {
      nextPiece()
    }
  }
  
  func nextPiece() {
    let newPiece = dotGame.newPiece()
    dotGame.fallingPiece = newPiece
    self.view.userInteractionEnabled = true
    self.scene.addPieceToScene(newPiece) {
      self.scene.startTicking()
    }
  }
  
  func gameDidBegin(dotGame: DotGame) {
    if scene.tick == nil {
      scene.tick = didTick
    }
    
    self.view.userInteractionEnabled = true

    self.scene.addPieceToScene(dotGame.fallingPiece!) {
      self.scene.addMadDotsToScene(dotGame.madDots)

      self.scene.startTicking()
    }
  }
  
  func gamePieceDidMove(dotGame: DotGame) {
    scene.redrawPiece(dotGame.fallingPiece!) {}
  }

  func didTick() {
    dotGame.lowerPiece()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Release any cached data, images, etc that aren't in use.
  }

  override func prefersStatusBarHidden() -> Bool {
      return true
  }
  
  deinit {
    print("GameViewController is being deinitialized")
  }
  
}
