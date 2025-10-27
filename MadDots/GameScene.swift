//
//  GameScene.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright (c) 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

var BlockSize: CGFloat = 0
let TickLengthLevelOne = 0.2
var extraYSpace: CGFloat = 0
typealias PointStore = (point: CGPoint, connectorPoints: [Side: CGPoint])
var points: Array2D<PointStore>?
var tinyScreen = false
var iPad = UIDevice.current.userInterfaceIdiom == .pad

class GameScene: SKScene {
  let gridLayer = SKNode()
  let dotLayer = SKNode()
  let LayerPosition = CGPoint(x: 1, y: 1)
  
  private var node = SKSpriteNode()

  var ctrl: GameViewController?
  var tick:(() -> ())?
  var count:(() -> ())?
  var tickLength = TickLengthLevelOne
  var menuTapped = false
  var levelLabel: SKLabelNode?
  var counterLabel: SKLabelNode?
  var menuLabel: SKLabelNode?
  var menuBtn: SKSpriteNode?
  var textureCache = Dictionary<String, SKTexture>()
  var angryKodamaAtlas: SKTextureAtlas?
  var timer: Timer?
  var counter: Timer?
  
  override func didMove(to view: SKView) {
      /* Setup your scene here */
  }
  
  override init(size: CGSize) {
    super.init(size: size)

    self.tickLength = abs(Double(GameSpeed - 13)) * 0.1

    anchorPoint = CGPoint(x: 0, y: 1.0)
  
    if size.height < 500 {
      tinyScreen = true
    }
    
    if ShowBG {
      setupBackground()
    }
    
    drawGrid()
    dotLayer.position = LayerPosition
    self.addChild(dotLayer)
    
    let y = self.frame.maxY - (extraYSpace - BlockSize)
    
    menuBtn = SKSpriteNode(imageNamed: "menubtn")
    
    if let menuBtn = menuBtn {
      menuBtn.name = "menu"

      menuBtn.zPosition = 5
      if iPad {
        menuBtn.size = CGSize(width: 201, height: 65)
      } else {
        menuBtn.size = CGSize(width: 123, height: 40)
      }

      let offset = iPad ? 20 : 5
      menuBtn.position = CGPoint(x: self.frame.maxX - (BlockSize * 2), y: y - CGFloat(offset))
      self.addChild(menuBtn)
    }
    
    levelLabelSetter()
//    if AngryKodama {
//      counterLabelSetter()
//    }

//    let speedLabel = SKLabelNode(fontNamed: "Arial")
//    speedLabel.text = "Speed \(GameSpeed)"
//    speedLabel.fontSize = 13
//    speedLabel.zPosition = 5
//
//    speedLabel.position = CGPoint(x: self.frame.midX - 80, y: y)
//    self.addChild(speedLabel)
    
    
    if points == nil {
      points = createPoints()
    }

    // Preload all textures to avoid stuttering during gameplay
    preloadTextures()
  }

  func preloadTextures() {
    // Preload dot color textures
    let dotColors = ["red", "green", "blue", "yellow", "orange"]
    for color in dotColors {
      if textureCache[color] == nil {
        let texture = SKTexture(imageNamed: color)
        texture.filteringMode = .nearest
        textureCache[color] = texture
      }
    }

    // Preload connector texture
    let connectorName = "whitecircle"
    if textureCache[connectorName] == nil {
      let texture = SKTexture(imageNamed: connectorName)
      texture.filteringMode = .nearest
      textureCache[connectorName] = texture
    }

    // Preload angry Kodama atlas
    if angryKodamaAtlas == nil {
      angryKodamaAtlas = SKTextureAtlas(named: "AngryKodama")
    }
  }
  
  func createPoints() -> Array2D<PointStore> {
    let arr = Array2D<PointStore>(columns: NumColumns, rows: NumRows)
    
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        arr[col,row] = (point: pointForColumn(col, row: row), connectorPoints: [
          .left: pointForSide(.left, column: col, row: row),
          .right: pointForSide(.right, column: col, row: row),
          .top: pointForSide(.top, column: col, row: row),
          .bottom: pointForSide(.bottom, column: col, row: row)
          ])
      }
    }
    
    return arr
  }
  
  func levelLabelSetter() {
    if levelLabel != nil {
      levelLabel!.removeFromParent()
    }

    levelLabel = SKLabelNode(fontNamed: "Arial")
    levelLabel!.text = "Level \(GameLevel)"
    levelLabel!.fontSize = 13
    levelLabel!.zPosition = 2
    
    let x = self.frame.midX
    let y = self.frame.maxY - (extraYSpace - BlockSize)
    
    levelLabel!.position = CGPoint(x: x, y: y)
    self.addChild(levelLabel!)
  }
  
  func counterLabelSetter() {
    if counterLabel != nil {
      counterLabel!.removeFromParent()
    }

    counterLabel = SKLabelNode(fontNamed: "Arial")
    counterLabel!.text = "\(angryLengthCountdown)/\(angryIntervalCountdown)"
    counterLabel!.fontSize = 13
    counterLabel!.zPosition = 2
    
    let y = self.frame.maxY - (extraYSpace - BlockSize)
    
    counterLabel!.position = CGPoint(x: self.frame.midX - 120, y: y)

    self.addChild(counterLabel!)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("NSCoder not supported")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let t = touches.first {
      let loc = t.location(in: self)
      let node = self.atPoint(loc)
      if CanMovePiece && node.name == "menu" {
        menuTapped = true
        if let c = ctrl {
          stopTicking()
          c.showSheet("You rang?", showCancel: true)
          stopTicking()
        }
      } else {
        menuTapped = false
      }
      
    }
  }

  func pointForColumn(_ column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + ((CGFloat(column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
    let y: CGFloat = LayerPosition.y - (((CGFloat(row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1
    return CGPoint(x: x, y: y - (extraYSpace - BlockSize * 2))
  }
  
  func pointForSide(_ side: Side, column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + ((CGFloat(column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
    let y: CGFloat = (LayerPosition.y - (((CGFloat(row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1) - (extraYSpace - BlockSize * 2)
    
    let halfBlock = BlockSize / 2 - ((BlockSize / 6) / 2)
    let pieceCenter = halfBlock * 1.25
    
    switch side {
    case .left:
      return CGPoint(x: x - pieceCenter, y: y)
    case .right:
      return CGPoint(x: x + pieceCenter, y: y)
    case .bottom:
      return CGPoint(x: x, y: y - pieceCenter)
    case .top:
      return CGPoint(x: x, y: y + pieceCenter)
    }
  }
  
  func pointForConnector(_ dot: GoodDot) -> CGPoint? {
    guard let s = dot.sibling, s.connector == nil else {
      return nil
    }
    
    if let side = dot.sideOfSibling(), let p = points {
      return p[dot.column, dot.row]!.connectorPoints[side]
    } else {
      return nil
    }
  }
  
  func resumeGame() {
    CanMovePiece = true
    self.timer = Timer.scheduledTimer(timeInterval: tickLength, target: self, selector: #selector(GameScene.didTick), userInfo: nil, repeats: true)
  }
  
  func addArrayToScene(_ array: DotArray2D) {
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let dot = array[col,row] {
          addDotToScene(dot, completion: nil)
        }
      }
    }
  }
  
  func addDotToScene(_ dot:Dot, completion:(() -> ())?) {
    var texture = textureCache[dot.spriteName]

    if texture == nil {
      texture = SKTexture(imageNamed: dot.spriteName)
      textureCache[dot.spriteName] = texture
    }
    
    let sprite = SKSpriteNode(texture: texture)

    let dotSize = BlockSize - 5

    sprite.size = CGSize(width: dotSize, height: dotSize)
    sprite.zPosition = 5
    sprite.position = points![dot.column, dot.row]!.point
    dot.sprite = sprite
    
    dotLayer.addChild(sprite)
        
    if let d = dot as? GoodDot {
      if let p = pointForConnector(d) {
        let size = BlockSize / 4
        let name = "whitecircle"
        var connTexture = textureCache[name]
        
        if connTexture == nil {
          connTexture = SKTexture(imageNamed:name)
          textureCache[name] = connTexture
        }
        
        let connector = SKSpriteNode(texture: connTexture, size: CGSize(width: size,height: size))

        connector.position = p
        connector.zPosition = 12
        d.connector = connector
        
        dotLayer.addChild(connector)
      }
    }

    completion?()
  }
  
  func removeDots(_ dots: Array<Dot>) {
    for dot in dots {
      dot.sprite?.removeAllActions()
      dot.sprite?.removeFromParent()
      if let d = dot as? GoodDot {
        d.connector?.removeFromParent()
        d.sibling?.connector?.removeFromParent()
      }
    }
  }
  
  func dropDots(_ fallenDots: Array<GoodDot>, completion:@escaping () -> ()) {
    var longestDuration: TimeInterval = 0

    for (columnIdx, dot) in fallenDots.enumerated() {
      let newPosition = points![dot.column, dot.row]!.point
      let sprite = dot.sprite!
      
      let delay = (TimeInterval(columnIdx) * 0.05) + (TimeInterval(columnIdx) * 0.05)
      let duration = TimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
      let moveAction = SKAction.move(to: newPosition, duration: duration)
      
      moveAction.timingMode = .easeIn
      sprite.run(moveAction)
      
      if let p = pointForConnector(dot) {
        let connector = dot.connector!

        let movAction = SKAction.move(to: p, duration: duration)
        movAction.timingMode = .easeIn

        connector.run(movAction)
      }
      
      longestDuration = max(longestDuration, duration + delay)
    }
    
    run(SKAction.wait(forDuration: longestDuration), completion:completion)
  }
  
  func addPieceToScene(_ piece: Piece, completion: (() -> ())?) {
    addDotToScene(piece.dot1, completion: nil)
    addDotToScene(piece.dot2, completion: completion)
  }
  
  func makeDotAngry(_ dot: MadDot, completion:(() -> ())?) {
    dot.removeFromScene()
    addAngryDotToScene(dot)
  }
  
  func pacifyDot(_ dot: MadDot, completion:(() -> ())?) {
    dot.angry = false
    dot.sprite?.removeAllActions()
    dot.removeFromScene()
    addDotToScene(dot, completion: completion)
  }
    
  func addAngryDotToScene(_ dot: Dot) {
    // Create and cache the atlas on first use
    if angryKodamaAtlas == nil {
      angryKodamaAtlas = SKTextureAtlas(named: "AngryKodama")
    }

    let atlas = angryKodamaAtlas!
    let f1 = atlas.textureNamed("angry_\(dot.color.description)_kodama1")
    let f2 = atlas.textureNamed("angry_\(dot.color.description)_kodama2")
    let f3 = atlas.textureNamed("angry_\(dot.color.description)_kodama3")

    let textures = [f1, f2, f3]
    
    let node = SKSpriteNode(texture: f1)
    let dotSize = BlockSize + (BlockSize / 5.0)
    let yOffset = BlockSize / 10.0

    node.xScale = dotSize
    node.yScale = dotSize
    node.size = CGSize(width: dotSize, height: dotSize)
    let point = points![dot.column, dot.row]!.point
    node.position = CGPoint(x: point.x, y: point.y + yOffset)
  
    dot.sprite = node
    
    let action = SKAction.repeatForever(
      SKAction.animate(with: textures,
                       timePerFrame: 0.38,
                       resize: false,
                       restore: true))
    
//    SKAction.run(action)
    node.run(action,
             withKey:"angry \(dot.description)")
    
//    run(action)
        
    dotLayer.addChild(node)
    
    NeedAngryDot = false
  }
    
  
  func addMadDotsToScene(_ madDots: Array<MadDot>) {
    for dot in madDots {
      addDotToScene(dot, completion: nil)
    }
  }
  
  @objc func didTick() {
    tick?()
  }
  
  @objc func didCount() {
    count?()
  }
  
  func startTicking() {
    stopTicking()
    CanMovePiece = true

    self.timer = Timer.scheduledTimer(timeInterval: tickLength, target: self, selector: #selector(GameScene.didTick), userInfo: nil, repeats: true)
  }
  
  func stopTicking() {
    self.timer?.invalidate()
    CanMovePiece = false
    self.timer = nil
  }
  
  func startCounting() {
    if !AngryKodama {
      return
    }
    
    self.counter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.didCount), userInfo: nil, repeats: true)
  }
  
  func stopCounting() {
    self.counter?.invalidate()
    self.counter = nil
  }

  func redrawPiece(_ piece: Piece, duration: TimeInterval, completion:@escaping () -> ()) {
    for dot in piece.dots {
      if let sprite = dot.sprite {
        let point = points![dot.column, dot.row]!.point
        let moveToAction:SKAction = SKAction.move(to: point, duration: duration)
        sprite.run(moveToAction)
        
        if let p = pointForConnector(dot) {
          let connector = dot.connector!
          let movToAction:SKAction = SKAction.move(to: p, duration: duration)
          
          connector.run(movToAction)
        }

      }
    }
    
    run(SKAction.wait(forDuration: duration), completion: completion)
  }
  
  func setupBackground() {
    let name = iPad ? "ipadfantasybg" : "fantasyforest"

    var texture = textureCache[name]
    
    if texture == nil {
      texture = SKTexture(imageNamed: name)
      textureCache[name] = texture
    }
    
    let background = SKSpriteNode(texture: texture, size: CGSize(width: size.width,height: size.height))

    background.anchorPoint = CGPoint(x: 0, y: 1.0)
    
    background.position = CGPoint(x: 0, y: 0)
    background.zPosition = 0
    gridLayer.addChild(background)
  }
  
  func drawGrid() {
    let totalRows = NumRows + 2
    let totalCols = NumColumns + 2
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let window = UIApplication.shared.windows.first
    var topNotchHeight = window!.safeAreaInsets.top

    let rowSquare = screenSize.maxY  / CGFloat(totalRows)
    let colSquare = screenSize.maxX / CGFloat(totalCols)
    
    var squareSize = rowSquare > colSquare ? colSquare : rowSquare
    
    if tinyScreen {
      squareSize -= 3
    }
    BlockSize = squareSize
    
    let rowWidth = (CGFloat(NumColumns) * squareSize)
    let colHeight = (CGFloat(DrawnRows) * squareSize)
    
    let centerX = ((squareSize * CGFloat(NumColumns + 1)) + squareSize) / 2
    let centerY = ((squareSize * CGFloat(DrawnRows + 1)) + squareSize) / 2 * -1
    
    if topNotchHeight > 0 {
      topNotchHeight += 5
    }
//    extraYSpace = (self.frame.minY * -1) - colHeight - (squareSize * 2)
    extraYSpace = squareSize + topNotchHeight
    
    for row in 1..<(totalRows-2) {
      let y = squareSize * CGFloat(row) * -1
      
      let barra = SKSpriteNode(color: SKColor.gray, size: CGSize(width: rowWidth, height: 0.5))
      barra.position = CGPoint(x: centerX, y: y - extraYSpace)
      barra.zPosition = 9
      
      gridLayer.addChild(barra)
    }
    
    for col in 1..<totalCols {
      let x = squareSize * CGFloat(col)
      
      let barra = SKSpriteNode(color: SKColor.gray, size: CGSize(width: 0.5, height: colHeight))
      barra.position = CGPoint(x: x, y: centerY - extraYSpace)
      barra.zPosition = 9
      
      gridLayer.addChild(barra)
    }
    
    gridLayer.position = LayerPosition

    self.addChild(gridLayer)
  }
  
  deinit {
    print("GameScene is being deinitialized")
  }
}
