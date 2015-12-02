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
  var panDistance: CGFloat?

  @IBAction func didTap(sender: UITapGestureRecognizer) {
    if !scene.menuTapped {
      dotGame.rotatePiece()
      scene.menuTapped = false
    }
  }

  @IBAction func swipeUp(sender: UISwipeGestureRecognizer) {
    dotGame.dropPiece()
//    dotGame.movePieceRight()
  }
  
  @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
//    dotGame.movePieceRight()
  }
  
  @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
//    dotGame.movePieceLeft()
  }
  
  @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
//    dotGame.lowerPiece()
  }
  
  func setLevelLabel() {
    self.scene.levelLabelSetter()
  }
  
  func showSheet(msg: String?, showCancel: Bool) {
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .ActionSheet)
    
    let newGame = UIAlertAction(title: "New Game", style: .Default, handler: { action in
      self.dotGame.beginAnew()
    })
    
    alertController.addAction(newGame)
    
    let menu = UIAlertAction(title: "Menu", style: .Default, handler: { _ in
      self.backToMenu()
    })
    
    alertController.addAction(menu)
    
    if showCancel {
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
        self.scene.resumeGame()
      })
      alertController.addAction(cancelAction)
    }
    
    presentViewController(alertController, animated:true, completion: nil)
  }
  
  func backToMenu() {
//    self.scene.textureCache = Dictionary<String, SKTexture>()
    self.scene.ctrl = nil
    self.scene.tick = nil
    self.scene.lastTick = nil
    self.scene = nil
    
    self.dotGame.delegate = nil
    self.dotGame = nil
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  var panCnt = 0
  var lastPan:NSDate?
  
  @IBAction func didPan(sender: UIPanGestureRecognizer) {
    guard let panD = panDistance else {
      return
    }
    
    if let lp = lastPan {
      let timePassed = lp.timeIntervalSinceNow * -1000.0
//      print("timePassed: \(timePassed)")
      if timePassed > 1024.0 {
        print("pans perSecond: \(panCnt)")
        panCnt = 0
        lastPan = NSDate()
      }  else {
        panCnt += 1
      }
      
    } else {
      lastPan = NSDate()
    }
    
    
    
    let currentPoint = sender.translationInView(self.view)

    if let originalPoint = panPointReference {
      let velocity = sender.velocityInView(self.view)
      let downDistance = abs(currentPoint.y - originalPoint.y)
      let horizontalDistance = abs(currentPoint.x - originalPoint.x)
      
      if downDistance > panD {
        if velocity.y > CGFloat(0) {
          dotGame.lowerPiece()
          panPointReference = currentPoint
        } else {
          panPointReference = currentPoint
        }
        
        if velocity.y > 2100 {
          dotGame.lowerPiece()
        }
      } else if horizontalDistance > panD {
        if velocity.x > CGFloat(0) {
          dotGame.movePieceRight()
          panPointReference = currentPoint
          if velocity.x > 2200 {
            dotGame.movePieceRight()
          }
        } else {
          if !justEnded {
            dotGame.movePieceLeft()
            panPointReference = currentPoint
            if velocity.x > 2200 {
              dotGame.movePieceLeft()
            }
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
    skView.showsDrawCount = true
    skView.multipleTouchEnabled = false
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    scene = GameScene(size: skView.bounds.size)
    scene.ctrl = self
    scene.scaleMode = .AspectFill
    scene.tick = didTick
    panDistance = BlockSize * 0.45
    
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
    scene.tick = nil
    let msg = "You blew it!"
    showSheet(msg, showCancel: false)
  }
  
  func gamePieceDidLand(dotGame: DotGame) {
    scene.stopTicking()
    self.view.userInteractionEnabled = false

    let results = dotGame.removeCompletedDots()
    let dotsToRemove = results.dotsToRemove
    let fallenDots = results.fallenDots
    
    if dotsToRemove.count > 0 {
      dotGame.fallingPiece = nil

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
          print("begin anew")
          delay(0.5) {
            dotGame.beginAnew()
          }
        }
      } else {
        scene.dropDots(fallenDots) {
          self.gamePieceDidLand(dotGame)
        }
      }
    } else {

      if dotGame.dotArray.hasDotsAboveGrid() {
        gameDidEnd(dotGame)
      } else {
        dotGame.fallingPiece = nil
        nextPiece()
      }

    }
  }
  
  func nextPiece() {
    delay(0.25) {
      let newPiece = self.dotGame.newPiece()
      self.dotGame.fallingPiece = newPiece
      self.view.userInteractionEnabled = true
      self.scene.addPieceToScene(newPiece) {
        self.scene.startTicking()
        self.panPointReference = nil
      }
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
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func gamePieceDidMove(dotGame: DotGame, completion:(() -> ())?) {
    scene.redrawPiece(dotGame.fallingPiece!) {
      if let c = completion {
        c()
      }
    }
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
//    print("GameViewController is being deinitialized")
  }
  
}
