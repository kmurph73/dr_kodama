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
var iPadPro = false

class GameScene: SKScene {
  let gridLayer = SKNode()
  let dotLayer = SKNode()
  let LayerPosition = CGPoint(x: 1, y: 1)
  
  var ctrl: GameViewController?
  var tick:(() -> ())?
  var tickLength = TickLengthLevelOne
//  var tickLengthMillis = TickLengthLevelOne
//  var lastTick:NSDate?
  var menuTapped = false
  var levelLabel: SKLabelNode?
  var menuLabel: SKLabelNode?
  var menuBtn: SKSpriteNode?
  var textureCache = Dictionary<String, SKTexture>()
  var timer: Timer?
  
  override func didMove(to view: SKView) {
      /* Setup your scene here */
  }
  
  override init(size: CGSize) {
    super.init(size: size)

    print("size: \(size)")
    self.tickLength = abs(Double(GameSpeed - 13)) * 0.1
//    self.tickLengthMillis = NSTimeInterval(Double(abs(GameSpeed - 14)) * 102.4)
//    print("tickLengh: \(tickLengthMillis)")

    anchorPoint = CGPoint(x: 0, y: 1.0)
  
    if size.height < 500 {
      tinyScreen = true
    } else if size.height > 1360 {
      iPadPro = true
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
//      menuLabel.text = "Menu"
      menuBtn.name = "menu"
//      menuLabel.fontSize = iPad ? 40 : 25
//      menuLabel.fontColor = UIColor(red: 0.1, green: 0.6 , blue: 0.6, alpha: 1)
      menuBtn.zPosition = 5
      if iPad {
        menuBtn.size = CGSize(width: 201, height: 65)
      } else {
        menuBtn.size = CGSize(width: 123, height: 40)
      }

      let offset = iPad ? 20 : 2
      menuBtn.position = CGPoint(x: self.frame.maxX - (BlockSize * 2), y: y - CGFloat(offset))
      self.addChild(menuBtn)
    }
    
    levelLabelSetter()

    let speedLabel = SKLabelNode(fontNamed: "Arial")
    speedLabel.text = "Speed \(GameSpeed)"
    speedLabel.fontSize = 13
    speedLabel.zPosition = 5
    
    speedLabel.position = CGPoint(x: self.frame.midX - 80, y: y)
    self.addChild(speedLabel)
    
    if points == nil {
      print("crate points")
      points = createPoints()
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

  

  
//  func startTicking() {
//    NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "newTick", userInfo: nil, repeats: true)
//  }
  
  func levelLabelSetter() {
    let y = self.frame.maxY - (extraYSpace - BlockSize)

    if levelLabel != nil {
      levelLabel!.removeFromParent()
    }

    levelLabel = SKLabelNode(fontNamed: "Arial")
    levelLabel!.text = "Level \(GameLevel)"
    levelLabel!.fontSize = 13
    levelLabel!.zPosition = 2
    
    levelLabel!.position = CGPoint(x: self.frame.midX, y: y)
    self.addChild(levelLabel!)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("NSCoder not supported")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let t = touches.first {
      let loc = t.location(in: self)
      let node = self.atPoint(loc)
      if node.name == "menu" {
        menuTapped = true
        if let c = ctrl {
          stopTicking()
          c.showSheet("You rang?", showCancel: true)
          stopTicking()
//          lastTick = nil
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
  
//  override func update(currentTime: CFTimeInterval) {
//    /* Called before each frame is rendered */
//    
//    guard let lastTick = self.lastTick else { return }
//    
//    let timePassed = lastTick.timeIntervalSinceNow * -1000.0
//    
//    if timePassed > tickLengthMillis {
//      self.lastTick = NSDate()
//      tick?()
//    }
//  }
  
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

    sprite.xScale = dotSize
    sprite.yScale = dotSize
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
        connector.zPosition = 12 // zPosition to change in which layer the barra appears.
        d.connector = connector
        
        dotLayer.addChild(connector)
      }
    }

    if let c = completion {
      run(SKAction.wait(forDuration: 0.2), completion: c)
    }

  }
  
  func removeDots(_ dots: Array<Dot>) {
    for dot in dots {
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
  
  func addMadDotsToScene(_ madDots: Array<MadDot>) {
    for dot in madDots {
      addDotToScene(dot, completion: nil)
    }
  }
  
  @objc func didTick() {
    tick?()
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
    let totalRows = NumRows
    let totalCols = NumColumns + 2
    
    let rowSquare = self.frame.minY  / CGFloat(totalRows) * -1
    let colSquare = self.frame.maxX / CGFloat(totalCols)
    
    var squareSize = rowSquare > colSquare ? colSquare : rowSquare
    if iPad {
      if iPadPro {
        squareSize -= 15
      } else {
        squareSize -= 5
      }
    } else if tinyScreen {
      squareSize -= 3
    }
    BlockSize = squareSize
    
    let rowWidth = (CGFloat(NumColumns) * squareSize)
    let colHeight = (CGFloat(DrawnRows) * squareSize)
    
    let centerX = ((squareSize * CGFloat(NumColumns + 1)) + squareSize) / 2
    let centerY = ((squareSize * CGFloat(DrawnRows + 1)) + squareSize) / 2 * -1
    
    extraYSpace = (self.frame.minY * -1) - colHeight - (squareSize * 2)
//    if iPad {
//      extraYSpace += CGFloat(100)
//    }
    
    for row in 1..<totalRows {
      let y = squareSize * CGFloat(row) * -1
      
      let barra = SKSpriteNode(color: SKColor.gray, size: CGSize(width: rowWidth, height: 0.5))
      barra.position = CGPoint(x: centerX, y: y - extraYSpace)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      gridLayer.addChild(barra)
    }
    
    for col in 1..<totalCols {
      let x = squareSize * CGFloat(col)
      
      let barra = SKSpriteNode(color: SKColor.gray, size: CGSize(width: 0.5, height: colHeight))
      barra.position = CGPoint(x: x, y: centerY - extraYSpace)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      gridLayer.addChild(barra)
    }
    
    gridLayer.position = LayerPosition

    self.addChild(gridLayer)
    
  }
  
  deinit {
    print("GameScene is being deinitialized")
  }
}
