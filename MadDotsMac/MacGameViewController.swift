//
//  MacGameViewController.swift
//  DrKodamaMac
//
//  Created by Kyle Murphy on 2026.
//

import Cocoa
import SpriteKit

class MacGameViewController: NSViewController, DotGameDelegate, GameSceneDelegate, GameSceneKeyboardDelegate, MacMenuSceneDelegate, MacAboutSceneDelegate {
  var dotGame: DotGame!
  var scene: GameScene!
  var skView: SKView!
  var menuScene: MacMenuScene!

  override func loadView() {
    skView = SKView(frame: NSRect(x: 0, y: 0, width: 400, height: 720))
    self.view = skView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    skView.ignoresSiblingOrder = true
    showMenu()
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    view.window?.makeFirstResponder(skView)
  }

  func showMenu() {
    // Clean up any running game
    scene?.stopTicking()
    scene?.stopCounting()
    dotGame?.delegate = nil
    dotGame = nil
    scene = nil

    menuScene = MacMenuScene(size: skView.bounds.size)
    menuScene.scaleMode = .aspectFill
    menuScene.menuDelegate = self
    skView.presentScene(menuScene)
  }

  func menuDidSelectPlay() {
    menuScene.menuDelegate = nil
    menuScene = nil
    saveState()
    startGame()
  }

  func menuDidSelectAbout() {
    let aboutScene = MacAboutScene(size: skView.bounds.size)
    aboutScene.scaleMode = .aspectFill
    aboutScene.aboutDelegate = self
    skView.presentScene(aboutScene)
  }

  func aboutDidClose() {
    showMenu()
  }

  func startGame() {
    scene = GameScene(size: skView.bounds.size)
    scene.sceneDelegate = self
    scene.keyboardDelegate = self
    scene.scaleMode = .aspectFill
    scene.tick = didTick
    scene.count = didCount

    dotGame = DotGame()
    dotGame.delegate = self
    dotGame.fallingPiece = nil
    dotGame.beginGame()

    skView.presentScene(scene)
  }

  // MARK: - Keyboard Input

  override var acceptsFirstResponder: Bool { true }

  func handleKeyDown(_ event: NSEvent) {
    let isRepeat = event.isARepeat

    switch event.keyCode {
    case 123: // Left arrow
      guard CanMovePiece else { return }
      dotGame.movePieceLeft()
    case 124: // Right arrow
      guard CanMovePiece else { return }
      dotGame.movePieceRight()
    case 125: // Down arrow
      guard CanMovePiece else { return }
      dotGame.movePieceDown()
    case 126: // Up arrow - hard drop
      guard CanMovePiece, !isRepeat else { return }
      dotGame.dropPiece()
    case 49: // Space - hard drop
      guard CanMovePiece, !isRepeat else { return }
      dotGame.dropPiece()
    case 7: // X - rotate
      guard CanMovePiece, !isRepeat else { return }
      dotGame.rotatePiece()
    case 36: // Return/Enter - menu
      guard !isRepeat else { return }
      if CanMovePiece {
        scene.stopTicking()
        showSheet("You rang?", showCancel: true)
      }
    default:
      break
    }
  }

  // MARK: - DotGameDelegate

  func stopTimer() {
    scene?.stopTicking()
  }

  func setLevelLabel() {
    scene.levelLabelSetter()
  }

  func gameDidEnd(_ dotGame: DotGame) {
    scene.tick = nil
    scene.count = nil
    scene.stopCounting()
    CanMovePiece = false

    showSheet("You blew it!", showCancel: false)
  }

  func gameDidBegin(_ dotGame: DotGame) {
    if scene.tick == nil {
      scene.tick = didTick
    }

    if scene.count == nil && AngryKodama {
      scene.count = didCount
    }

    scene.stopTicking()
    scene.stopCounting()

    CanMovePiece = true

    angryLengthCountdown = AngryLengthDefault
    angryIntervalCountdown = AngryIntervalDefault

    scene.addMadDotsToScene(dotGame.madDots)

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

  func gamePieceDidMove(_ dotGame: DotGame, duration: TimeInterval, completion: (() -> ())?) {
    scene.redrawPiece(dotGame.fallingPiece!, duration: duration) {
      completion?()
    }
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
          let alert = NSAlert()
          alert.messageText = "You won!"
          alert.addButton(withTitle: "OMG pinch me")
          alert.runModal()
          backToMenu()
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
            if let dot = findRealRandomTopDot(dots: self.dotGame.madDots, dotArray: self.dotGame.dotArray) {
              dot.angry = true
              dot.sprite?.removeFromParent()
              self.scene.addAngryDotToScene(dot)
            }

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

  // MARK: - Game Flow

  func newPiece() {
    delay(0.3) {
      if let nextPiece = self.dotGame.nextPiece {
        let newPiece = self.dotGame.newNextPiece()
        self.dotGame.fallingPiece = nextPiece
        self.dotGame.nextPiece = newPiece
        nextPiece.shiftBy(3, rows: 1)
        self.scene.redrawPiece(nextPiece, duration: 0.2) {
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
        }
      }
    }
  }

  func resetAngry() {
    NeedAngryDot = true
    angryIntervalCountdown = AngryIntervalDefault
    angryLengthCountdown = AngryLengthDefault
    scene.counterLabel?.text = "\(angryIntervalCountdown)/\(angryLengthCountdown)"
  }

  func beatLevelAlert() {
    scene.stopCounting()

    let alert = NSAlert()
    alert.messageText = "Congrats! You beat level \(GameLevel)"
    alert.addButton(withTitle: "Play next level")
    alert.addButton(withTitle: "Menu")
    alert.addButton(withTitle: "Quit App")

    let response = alert.runModal()
    switch response {
    case .alertFirstButtonReturn:
      GameLevel += 1
      dotGame.beginAnew()
    case .alertSecondButtonReturn:
      backToMenu()
    default:
      NSApplication.shared.terminate(nil)
    }
  }

  func backToMenu() {
    scene?.sceneDelegate = nil
    scene?.keyboardDelegate = nil
    scene?.tick = nil
    scene?.count = nil
    scene?.stopTicking()
    scene?.stopCounting()
    dotGame?.delegate = nil
    showMenu()
  }

  // MARK: - GameSceneDelegate

  func showSheet(_ msg: String?, showCancel: Bool) {
    let alert = NSAlert()
    alert.messageText = msg ?? ""
    alert.addButton(withTitle: "New Game")
    alert.addButton(withTitle: "Menu")
    if showCancel {
      alert.addButton(withTitle: "Resume")
    }
    alert.addButton(withTitle: "Quit App")

    let response = alert.runModal()
    switch response {
    case .alertFirstButtonReturn:
      dotGame.beginAnew()
    case .alertSecondButtonReturn:
      backToMenu()
    case .alertThirdButtonReturn where showCancel:
      scene.resumeGame()
    default:
      NSApplication.shared.terminate(nil)
    }
  }

  // MARK: - Timer Callbacks

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
}
