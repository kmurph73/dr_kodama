//
//  GameViewController.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright (c) 2015 Kyle Murphy. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, DotGameDelegate, UIGestureRecognizerDelegate, StoreViewCtrlDelegate {
  var dotGame:DotGame!
  var scene: GameScene!
  var panPointReference:CGPoint?
  var justEnded = false
  var panDistance: CGFloat?
  var sheetShown = false

  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    if !scene.menuTapped {
      dotGame.rotatePiece()
      scene.menuTapped = false
    }
  }

  @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
    dotGame.dropPiece()
  }
  
  func doneWithStore(_ ctrl: StoreViewController) {
    ctrl.dismiss(animated: true, completion: { _ in
      self.backToMenu()
    })
  }
  
  func setLevelLabel() {
    self.scene.levelLabelSetter()
  }
  
  func showSheet(_ msg: String?, showCancel: Bool) {
    let style: UIAlertControllerStyle = iPad ? .alert : .actionSheet
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: style)

    let newGame = UIAlertAction(title: "New Game", style: .default, handler: { action in
      self.dotGame.beginAnew()
    })
    
    alertController.addAction(newGame)
    
    let menu = UIAlertAction(title: "Menu", style: .default, handler: { _ in
      self.backToMenu()
    })
    
    alertController.addAction(menu)
    
    if showCancel {
      let cancelAction = UIAlertAction(title: "Resume", style: .cancel, handler: { action in
        self.sheetShown = false
        self.scene.resumeGame()
      })
      alertController.addAction(cancelAction)
    }
    
    self.present(alertController, animated:true, completion: {
      self.sheetShown = true
    })
  }
  
  func stopTimer() {
    print("stop timer")
    self.scene.stopTicking()
  }
  
  func startTimer() {
    print("start timer")
    self.scene.startTicking()
  }
  
  func backToMenu() {
//    self.scene.textureCache = Dictionary<String, SKTexture>()
    self.scene.ctrl = nil
    self.scene.tick = nil
    self.scene.stopTicking()
//    self.scene.lastTick = nil
    self.scene = nil
    
    self.dotGame.delegate = nil
    self.dotGame = nil
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
    guard let panD = panDistance else {
      return
    }

    let currentPoint = sender.translation(in: self.view)

    if let originalPoint = panPointReference {
      let velocity = sender.velocity(in: self.view)
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
    } else if sender.state == .began {
      panPointReference = currentPoint
    }
    
    if sender.state == .ended {
      panPointReference = nil
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\(self) did load")

    // Configure the view.
    let skView = self.view as! SKView
//    skView.showsFPS = true
//    skView.showsNodeCount = true
//    skView.showsDrawCount = true
    skView.isMultipleTouchEnabled = false
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    scene = GameScene(size: skView.bounds.size)
    scene.ctrl = self
    scene.scaleMode = .aspectFill
    scene.tick = didTick
    panDistance = BlockSize * 0.45
    
    dotGame = DotGame()
    dotGame.delegate = self
    dotGame.fallingPiece = nil
    dotGame.beginGame()
    
    skView.presentScene(scene)
  }

  override var shouldAutorotate : Bool {
    return false
  }

  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  func gameDidEnd(_ dotGame: DotGame) {
    scene.tick = nil
    let msg = "You blew it!"
    showSheet(msg, showCancel: false)
  }
  
  func beatLevelAlert() {
    let msg = "Congrats! You beat level \(GameLevel)"
    let style: UIAlertControllerStyle = iPad ? .alert : .actionSheet
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: style)
    
    let nextLevel = UIAlertAction(title: "Play next level", style: .default, handler: { action in
      GameLevel += 1
      self.dotGame.beginAnew()
    })
    
    alertController.addAction(nextLevel)
    
    let menu = UIAlertAction(title: "Back to menu", style: .default, handler: { _ in
      self.backToMenu()
    })
    
    alertController.addAction(menu)
    
    self.present(alertController, animated:true, completion: nil)
  }
  
  func buyMoreLevelsAlert() {
    let msg = "Congrats! You beat the last level... or did you?  Hint: no.  Buy the rest of the levels at the store!"
    let style: UIAlertControllerStyle = iPad ? .alert : .actionSheet
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: style)
    
    let nextLevel = UIAlertAction(title: "Go to store", style: .default, handler: { action in
      self.performSegue(withIdentifier: "goStore", sender: self)
    })
    
    alertController.addAction(nextLevel)
    
    let menu = UIAlertAction(title: "Back to menu", style: .default, handler: { _ in
      self.backToMenu()
    })
    
    alertController.addAction(menu)
    
    self.present(alertController, animated:true, completion: nil)
  }
  
  func gamePieceDidLand(_ dotGame: DotGame) {
    scene.stopTicking()
    self.view.isUserInteractionEnabled = false

    let results = dotGame.removeCompletedDots()
    let dotsToRemove = results.dotsToRemove
    let fallenDots = results.fallenDots
    
    if dotsToRemove.count > 0 {
      dotGame.fallingPiece = nil

      scene.removeDots(dotsToRemove)
      if dotGame.dotArray.hasAchievedVictory() {
        if !MoreLevelsPurchased && GameLevel == 11 {
          buyMoreLevelsAlert()
        } else if GameLevel == 20 {
          let msg = "You won!"
          let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OMG pinch me", style: .default, handler: { _ in
            self.backToMenu()
          })
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
        } else {
          delay(0.5) {
            self.beatLevelAlert()
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
        newPiece()
      }

    }
  }
  
  func newPiece() {
    delay(0.3) {
      if let nextPiece = self.dotGame.nextPiece {
        let newPiece = self.dotGame.newNextPiece()
        self.dotGame.fallingPiece = nextPiece
        self.dotGame.nextPiece = newPiece
        nextPiece.shiftBy(3, rows: 1)
        self.scene.redrawPiece(nextPiece, duration: 0.2) {
          self.view.isUserInteractionEnabled = true
          self.panPointReference = nil
          self.scene.startTicking()

          //        delay(0.75) {
          self.scene.addPieceToScene(newPiece, completion: nil)
          //        }
          
        }
      
      } else {
        let newPiece = self.dotGame.newPiece()

        self.dotGame.fallingPiece = newPiece
        self.view.isUserInteractionEnabled = true
        self.scene.addPieceToScene(newPiece) {
          self.scene.startTicking()
          self.panPointReference = nil
        }
      }

    }
  }
  
  func gameDidBegin(_ dotGame: DotGame) {
    if scene.tick == nil {
      scene.tick = didTick
    }
    
    self.view.isUserInteractionEnabled = true
    
    self.scene.addMadDotsToScene(dotGame.madDots)
    
    delay(0.5) {
      self.scene.addPieceToScene(dotGame.fallingPiece!) {

        if let nextPiece = dotGame.nextPiece {
          delay(0.5) {
            self.scene.addPieceToScene(nextPiece, completion: nil)
          }
        }

        self.scene.startTicking()
      }
    }
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func gamePieceDidMove(_ dotGame: DotGame, duration: TimeInterval, completion:(() -> ())?) {
    scene.redrawPiece(dotGame.fallingPiece!, duration: duration) {
      if let c = completion {
        c()
      }
    }
  }

  func didTick() {
    print("didTick")
    dotGame.lowerPiece()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Release any cached data, images, etc that aren't in use.
  }

  override var prefersStatusBarHidden : Bool {
      return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goStore" {
      let navigationController = segue.destination as! UINavigationController
      let vc = navigationController.viewControllers.first as! StoreViewController
      vc.delegate = self
    }
  }
  
  deinit {
    print("GameViewController is being deinitialized")
  }
}
