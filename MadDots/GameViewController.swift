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
  var sheetShown = false

  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    if !scene.menuTapped && CanMovePiece {
      dotGame.rotatePiece()
      scene.menuTapped = false
    }
  }

  @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
    dotGame.dropPiece()
  }
  
  func setLevelLabel() {
    self.scene.levelLabelSetter()
  }
  
  func showSheet(_ msg: String?, showCancel: Bool) {
    let style: UIAlertController.Style = iPad ? .alert : .actionSheet
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: style)

    let newGame = UIAlertAction(title: "New Game", style: .default, handler: { action in
      self.sheetShown = false
      self.dotGame.beginAnew()
    })
    
    alertController.addAction(newGame)
    
    let menu = UIAlertAction(title: "Menu", style: .default, handler: { _ in
      self.sheetShown = false
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
    
    self.sheetShown = true
    self.present(alertController, animated:true)
  }
  
  func stopTimer() {

    self.scene.stopTicking()
  }
  
  func startTimer() {
    self.scene.startTicking()
  }
  
  func backToMenu() {
    self.scene.ctrl = nil
    self.scene.tick = nil
    self.scene.count = nil
    self.scene.stopTicking()
    self.scene = nil
    
    self.dotGame.delegate = nil
    self.dotGame = nil
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
    guard let panD = panDistance else {
      return
    }
    
    if !CanMovePiece {
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
    scene.count = didCount
    
    let cutoff = 41.0

    if BlockSize > cutoff {
      panDistance = BlockSize * 0.45
    } else {
      panDistance = cutoff * 0.45
    }
    
    
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
    scene.count = nil
    scene.stopCounting()
    CanMovePiece = false

    let msg = "You blew it!"
    showSheet(msg, showCancel: false)
  }
  
  func beatLevelAlert() {
    let msg = "Congrats! You beat level \(GameLevel)"
    let style: UIAlertController.Style = iPad ? .alert : .actionSheet
    let alertController = UIAlertController(title: nil, message: msg, preferredStyle: style)
    
    scene.stopCounting()
    
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
  
  func resetAngry() {
    NeedAngryDot = true
    angryIntervalCountdown = AngryIntervalDefault
    angryLengthCountdown = AngryLengthDefault
    scene.counterLabel?.text = "\(angryIntervalCountdown)/\(angryLengthCountdown)"
  }
  
  func gamePieceDidLand(_ dotGame: DotGame) {
    scene.stopTicking()
    CanMovePiece = false

    let results = dotGame.removeCompletedDots()
    let dotsToRemove = results.dotsToRemove
    let fallenDots = results.fallenDots
    
    if dotsToRemove.count > 0 {
      dotGame.fallingPiece = nil

      scene.removeDots(dotsToRemove)
      if dotGame.dotArray.hasAchievedVictory() {
        if GameLevel == 20 {
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
        
        if angryLengthCountdown == 0 {
          resetAngry()
          
          if let angryDot = self.dotGame.madDots.first(where: { $0.angry }) {
            scene.pacifyDot(angryDot, completion: nil)
    
            let dots = dotGame.addThreeRandomThreeDots()
            for dot in dots {
              scene.addDotToScene(dot, completion: nil)
            }
            
            delay(1) {
              let result = dropFallenDots(dotGame.dotArray)

              self.scene.dropDots(result, completion: {
                self.gamePieceDidLand(dotGame)
              })
            }
          } else {
            newPiece()
          }
          
        } else if angryIntervalCountdown == 0 && NeedAngryDot {
          let angryDot = self.dotGame.madDots.first(where: { $0.angry })
          if angryDot == nil && self.dotGame.madDots.count > 0 {
            let dot = findRealRandomTopDot(dots: self.dotGame.madDots, dotArray: self.dotGame.dotArray)
            dot.angry = true
            dot.sprite?.removeFromParent()
            self.scene.addAngryDotToScene(dot)
//            let color = colormap[dot.color.spriteName]!
//            self.drawRectOverSquare(col: dot.column, row: dot.row, color: color )
            
            self.newPiece()
          } else {
            newPiece()
          }
        } else {
          newPiece()
        }
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
          self.panPointReference = nil
          self.scene.startTicking()
          CanMovePiece = true
          
          self.scene.addPieceToScene(newPiece, completion: nil)
        }
      
      } else {
        let newPiece = self.dotGame.newPiece()

        self.dotGame.fallingPiece = newPiece
        self.scene.addPieceToScene(newPiece) {
          CanMovePiece = true
          self.scene.startTicking()
          self.panPointReference = nil
        }
      }

    }
  }
  
  func drawRectOverSquare(col: Int, row: Int, color: UIColor) {
    let shape = SKShapeNode()
//    let point = points![col, row]!.point
    let x = (BlockSize * CGFloat(col)) + BlockSize
    let y = extraYSpace + (BlockSize * CGFloat(row))
    print("point: \(x),\(-y)")
    shape.path = UIBezierPath(rect: CGRect(x: x + 1, y: -(y - 0.2), width: BlockSize, height: BlockSize)).cgPath
//    shape.position = CGPoint(x: -point.x, y: -point.y)
//    shape.fillColor = UIColor.red
    shape.strokeColor = color
    shape.lineWidth = 3
    shape.zPosition = 99
    self.scene.addChild(shape)
    
    delay(3.5, closure: { shape.removeFromParent()})
    
//    let action = SKAction.fadeOut(withDuration: 5)
//    shape.run(action)
  }
  
  func gameDidBegin(_ dotGame: DotGame) {
    if scene.tick == nil {
      scene.tick = didTick
    }
    
    if scene.count == nil && AngryKodama {
      scene.count = didCount
    }
    
    self.scene.stopTicking()
    self.scene.stopCounting()
    
    CanMovePiece = true
    
    angryLengthCountdown = AngryLengthDefault
    angryIntervalCountdown = AngryIntervalDefault
    
    self.scene.addMadDotsToScene(dotGame.madDots)
//    if AngryKodama {
//      self.scene.counterLabelSetter()
//    }
    
    delay(0.5) {
      self.scene.addPieceToScene(dotGame.fallingPiece!) {

        if let nextPiece = dotGame.nextPiece {
          delay(0.5) {
            self.scene.addPieceToScene(nextPiece, completion: nil)
          }
        }

        self.scene.startTicking()
        self.scene.startCounting()
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
    dotGame.lowerPiece()
  }
  
  func didCount() {
    if !CanMovePiece || angryLengthCountdown == 0 {
      return
    }
    
    if angryIntervalCountdown == 0 {
      if !NeedAngryDot {
        angryLengthCountdown -= 1
      }
    } else if angryIntervalCountdown > 0 {
      angryIntervalCountdown -= 1
    }
    
    scene.counterLabel?.text = "\(angryIntervalCountdown)/\(angryLengthCountdown)"
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Release any cached data, images, etc that aren't in use.
  }

  override var prefersStatusBarHidden : Bool {
      return true
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "goStore" {
//      let navigationController = segue.destination as! UINavigationController
//      let vc = navigationController.viewControllers.first as! StoreViewController
//      vc.delegate = self
//    }
//  }
  
  deinit {
    print("GameViewController is being deinitialized")
  }
}
