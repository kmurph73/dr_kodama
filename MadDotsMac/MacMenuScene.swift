//
//  MacMenuScene.swift
//  DrKodamaMac
//

import SpriteKit

protocol MacMenuSceneDelegate: AnyObject {
  func menuDidSelectPlay()
  func menuDidSelectAbout()
}

class MacMenuScene: SKScene {
  weak var menuDelegate: MacMenuSceneDelegate?

  private var titleLabel: SKLabelNode!
  private var controlsLabel: SKLabelNode!
  private var levelLabel: SKLabelNode!
  private var colorsLabel: SKLabelNode!
  private var angryLabel: SKLabelNode!
  private var playLabel: SKLabelNode!
  private var aboutLabel: SKLabelNode!
  private var quitLabel: SKLabelNode!

  private var menuItems: [MenuItem] = []
  private var selectedIndex = 0

  enum MenuItem {
    case level, colors, angry, play, about, quit
  }

  override init(size: CGSize) {
    super.init(size: size)
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    backgroundColor = SKColor.black
    menuItems = [.level, .colors, .angry, .play, .about, .quit]
    setupScene()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupScene() {
    let centerY = size.height * 0.5

    titleLabel = SKLabelNode(fontNamed: "Arial Bold")
    titleLabel.text = "Dr. Kodama"
    titleLabel.fontSize = 36
    titleLabel.fontColor = SKColor.white
    titleLabel.position = CGPoint(x: 0, y: centerY - 80)
    addChild(titleLabel)

    let kodamaTexture = SKTexture(imageNamed: "kodama")
    let kodama = SKSpriteNode(texture: kodamaTexture)
    let iconSize: CGFloat = 120
    let aspect = kodamaTexture.size().height / kodamaTexture.size().width
    kodama.size = CGSize(width: iconSize, height: iconSize * aspect)
    kodama.position = CGPoint(x: 0, y: centerY - 185)
    addChild(kodama)

    levelLabel = SKLabelNode(fontNamed: "Arial")
    levelLabel.fontSize = 20
    levelLabel.position = CGPoint(x: 0, y: -10)
    addChild(levelLabel)
    updateLevelLabel()

    colorsLabel = SKLabelNode(fontNamed: "Arial")
    colorsLabel.fontSize = 20
    colorsLabel.position = CGPoint(x: 0, y: -50)
    addChild(colorsLabel)
    updateColorsLabel()

    angryLabel = SKLabelNode(fontNamed: "Arial")
    angryLabel.fontSize = 20
    angryLabel.position = CGPoint(x: 0, y: -90)
    addChild(angryLabel)
    updateAngryLabel()

    playLabel = SKLabelNode(fontNamed: "Arial Bold")
    playLabel.text = "[ Play ]"
    playLabel.name = "play"
    playLabel.fontSize = 28
    playLabel.fontColor = SKColor.green
    playLabel.position = CGPoint(x: 0, y: -145)
    addChild(playLabel)

    aboutLabel = SKLabelNode(fontNamed: "Arial")
    aboutLabel.text = "About"
    aboutLabel.name = "about"
    aboutLabel.fontSize = 18
    aboutLabel.position = CGPoint(x: 0, y: -190)
    addChild(aboutLabel)

    quitLabel = SKLabelNode(fontNamed: "Arial")
    quitLabel.text = "Quit"
    quitLabel.name = "quit"
    quitLabel.fontSize = 18
    quitLabel.position = CGPoint(x: 0, y: -225)
    addChild(quitLabel)

    controlsLabel = SKLabelNode(fontNamed: "Arial")
    controlsLabel.text = "Arrow keys: move  |  X: rotate  |  Up/Space: drop  |  Enter: menu"
    controlsLabel.fontSize = 12
    controlsLabel.fontColor = SKColor.gray
    controlsLabel.position = CGPoint(x: 0, y: -centerY + 50)
    addChild(controlsLabel)

    let hint = SKLabelNode(fontNamed: "Arial")
    hint.text = "Up/Down: select  |  Left/Right: adjust  |  Enter: play"
    hint.fontSize = 11
    hint.fontColor = SKColor.darkGray
    hint.position = CGPoint(x: 0, y: -centerY + 30)
    addChild(hint)

    updateSelectionHighlight()
  }

  func updateLevelLabel() {
    levelLabel.text = "< Level: \(GameLevel) >"
  }

  func updateColorsLabel() {
    colorsLabel.text = "< Colors: \(NumberOfColors) >"
  }

  func updateAngryLabel() {
    angryLabel.text = "Angry Kodama: \(AngryKodama ? "ON" : "OFF")"
  }

  func labelForItem(_ item: MenuItem) -> SKLabelNode {
    switch item {
    case .level: return levelLabel
    case .colors: return colorsLabel
    case .angry: return angryLabel
    case .play: return playLabel
    case .about: return aboutLabel
    case .quit: return quitLabel
    }
  }

  func updateSelectionHighlight() {
    for (index, item) in menuItems.enumerated() {
      let label = labelForItem(item)
      if index == selectedIndex {
        label.fontColor = item == .play ? SKColor.green : SKColor.yellow
      } else {
        let dimColor = SKColor(white: 0.4, alpha: 1.0)
        label.fontColor = (item == .play || item == .about || item == .quit) ? dimColor : SKColor.white
      }
    }
  }

  func adjustSelected(delta: Int) {
    switch menuItems[selectedIndex] {
    case .level:
      GameLevel += delta
      if GameLevel > 20 { GameLevel = 1 }
      if GameLevel < 1 { GameLevel = 20 }
      updateLevelLabel()
    case .colors:
      NumberOfColors += delta
      if NumberOfColors > 5 { NumberOfColors = 4 }
      if NumberOfColors < 4 { NumberOfColors = 5 }
      updateColorsLabel()
    case .angry:
      AngryKodama.toggle()
      updateAngryLabel()
    case .play, .about, .quit:
      break
    }
  }

  func confirmSelected() {
    switch menuItems[selectedIndex] {
    case .colors:
      NumberOfColors = NumberOfColors == 4 ? 5 : 4
      updateColorsLabel()
    case .angry:
      AngryKodama.toggle()
      updateAngryLabel()
    case .play:
      menuDelegate?.menuDidSelectPlay()
    case .about:
      menuDelegate?.menuDidSelectAbout()
    case .quit:
      NSApplication.shared.terminate(nil)
    default:
      menuDelegate?.menuDidSelectPlay()
    }
  }

  // MARK: - Key Repeat

  private var repeatTimer: Timer?
  private var repeatDelta: Int = 0
  private var initialDelayFired = false

  func startRepeat(delta: Int) {
    stopRepeat()
    repeatDelta = delta
    initialDelayFired = false
    adjustSelected(delta: delta)
    repeatTimer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      self.initialDelayFired = true
      self.repeatTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] _ in
        self?.adjustSelected(delta: delta)
      }
    }
  }

  func stopRepeat() {
    repeatTimer?.invalidate()
    repeatTimer = nil
    repeatDelta = 0
    initialDelayFired = false
  }

  // MARK: - Input

  override func mouseDown(with event: NSEvent) {
    let location = event.location(in: self)

    for (index, item) in menuItems.enumerated() {
      if isNear(location, node: labelForItem(item)) {
        selectedIndex = index
        updateSelectionHighlight()

        switch item {
        case .play, .about, .quit:
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.confirmSelected()
          }
        default:
          if location.x < 0 {
            adjustSelected(delta: -1)
          } else {
            adjustSelected(delta: 1)
          }
        }
        return
      }
    }
  }

  override func keyDown(with event: NSEvent) {
    if event.isARepeat { return }

    switch event.keyCode {
    case 36, 49: // Enter, Space
      confirmSelected()
    case 126: // Up arrow
      selectedIndex = selectedIndex - 1 < 0 ? menuItems.count - 1 : selectedIndex - 1
      updateSelectionHighlight()
    case 125: // Down arrow
      selectedIndex = selectedIndex + 1 >= menuItems.count ? 0 : selectedIndex + 1
      updateSelectionHighlight()
    case 124: // Right arrow
      startRepeat(delta: 1)
    case 123: // Left arrow
      startRepeat(delta: -1)
    default:
      break
    }
  }

  override func keyUp(with event: NSEvent) {
    switch event.keyCode {
    case 123, 124: // Left/Right arrow released
      stopRepeat()
    default:
      break
    }
  }

  private func isNear(_ point: CGPoint, node: SKLabelNode) -> Bool {
    return abs(point.y - node.position.y) < 20
  }
}
