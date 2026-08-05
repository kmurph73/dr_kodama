//
//  MacAboutScene.swift
//  DrKodamaMac
//

import SpriteKit

protocol MacAboutSceneDelegate: AnyObject {
  func aboutDidClose()
}

class MacAboutScene: SKScene {
  weak var aboutDelegate: MacAboutSceneDelegate?

  override init(size: CGSize) {
    super.init(size: size)
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    backgroundColor = SKColor.black
    setupScene()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupScene() {
    let centerY = size.height * 0.5

    let title = SKLabelNode(fontNamed: "Arial Bold")
    title.text = "Dr. Kodama"
    title.fontSize = 32
    title.fontColor = SKColor.white
    title.position = CGPoint(x: 0, y: centerY - 100)
    addChild(title)

    let lines = [
      "A fun tile-matching puzzle game.",
      "",
      "Rotate and position falling two-dot pieces to",  
      "create chains of 4 or more same-colored dots.",
      "Clear all the Kodama to beat a level.",
      "",
      "Controls:",
      "  Left/Right arrows - Move piece",
      "  Down arrow - Soft drop",
      "  Up arrow / Space - Hard drop",
      "  X - Rotate piece",
      "  Enter - Pause menu",
      "",
      "Angry Kodama mode adds a timed challenge:",
      "a Kodama becomes angry and after a countdown,",
      "extra dots rain down from above!",
      "",
      "20 levels of increasing difficulty.",
      "Good luck!",
    ]

    let startY = centerY - 160.0
    let lineHeight: CGFloat = 20

    for (i, line) in lines.enumerated() {
      let label = SKLabelNode(fontNamed: "Arial")
      label.text = line
      label.fontSize = 14
      label.fontColor = line.hasPrefix("  ") ? SKColor.lightGray : SKColor.white
      label.position = CGPoint(x: 0, y: startY - CGFloat(i) * lineHeight)
      addChild(label)
    }

    let backLabel = SKLabelNode(fontNamed: "Arial Bold")
    backLabel.text = "[ Back ]"
    backLabel.name = "back"
    backLabel.fontSize = 22
    backLabel.fontColor = SKColor.green
    backLabel.position = CGPoint(x: 0, y: -centerY + 40)
    addChild(backLabel)
  }

  override func mouseDown(with event: NSEvent) {
    let location = event.location(in: self)
    let node = atPoint(location)
    if node.name == "back" {
      aboutDelegate?.aboutDidClose()
    }
  }

  override func keyDown(with event: NSEvent) {
    guard !event.isARepeat else { return }

    switch event.keyCode {
    case 36, 49, 53: // Enter, Space, Escape
      aboutDelegate?.aboutDidClose()
    default:
      break
    }
  }
}
