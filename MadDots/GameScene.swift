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
  var timer: NSTimer?

  override func didMoveToView(view: SKView) {
      /* Setup your scene here */
  }
  
  override init(size: CGSize) {
    super.init(size: size)

    self.tickLength = abs(Double(GameSpeed - 13)) * 0.1
//    self.tickLengthMillis = NSTimeInterval(Double(abs(GameSpeed - 14)) * 102.4)
//    print("tickLengh: \(tickLengthMillis)")

    anchorPoint = CGPoint(x: 0, y: 1.0)
  
    if ShowBG {
      setupBackground()
    }

    drawGrid()
    dotLayer.position = LayerPosition
    self.addChild(dotLayer)
    
    let y = CGRectGetMaxY(self.frame) - (extraYSpace - BlockSize)
    
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
      menuBtn.position = CGPointMake(CGRectGetMaxX(self.frame) - (BlockSize * 2), y - CGFloat(offset))
      self.addChild(menuBtn)
    }
    
    levelLabelSetter()

    let speedLabel = SKLabelNode(fontNamed: "Arial")
    speedLabel.text = "Speed \(GameSpeed)"
    speedLabel.fontSize = 13
    speedLabel.zPosition = 5
    
    speedLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 80, y)
    self.addChild(speedLabel)
    
    

  }
  
//  func startTicking() {
//    NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "newTick", userInfo: nil, repeats: true)
//  }
  
  func levelLabelSetter() {
    let y = CGRectGetMaxY(self.frame) - (extraYSpace - BlockSize)

    if levelLabel != nil {
      levelLabel!.removeFromParent()
    }

    levelLabel = SKLabelNode(fontNamed: "Arial")
    levelLabel!.text = "Level \(GameLevel)"
    levelLabel!.fontSize = 13
    levelLabel!.zPosition = 2
    
    levelLabel!.position = CGPointMake(CGRectGetMidX(self.frame), y)
    self.addChild(levelLabel!)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("NSCoder not supported")
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let t = touches.first {
      let loc = t.locationInNode(self)
      let node = self.nodeAtPoint(loc)
      if node.name == "menu" {
        menuTapped = true
        if let c = ctrl {
          c.showSheet("You rang?", showCancel: true)
          stopTicking()
//          lastTick = nil
        }
      } else {
        menuTapped = false
      }
      
    }
  }

  func pointForColumn(column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + ((CGFloat(column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
    let y: CGFloat = LayerPosition.y - (((CGFloat(row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1
    return CGPointMake(x, y - (extraYSpace - BlockSize * 2))
  }
  
  func pointForConnector(dot: GoodDot) -> CGPoint? {
    guard let s = dot.sibling where s.connector == nil else {
      return nil
    }
    
    if let side = dot.sideOfSibling() {
      let x: CGFloat = LayerPosition.x + ((CGFloat(dot.column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
      let y: CGFloat = (LayerPosition.y - (((CGFloat(dot.row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1) - (extraYSpace - BlockSize * 2)
      
      let halfBlock = BlockSize / 2 - ((BlockSize / 6) / 2)
      let pieceCenter = halfBlock * 1.25
      
      switch side {
      case .Left:
        return CGPointMake(x - pieceCenter, y)
      case .Right:
        return CGPointMake(x + pieceCenter, y)
      case .Bottom:
        return CGPointMake(x, y - pieceCenter)
      case .Top:
        return CGPointMake(x, y + pieceCenter)
      }
    } else {
      return nil
    }

  }
  
  func resumeGame() {
    self.timer = NSTimer.scheduledTimerWithTimeInterval(tickLength, target: self, selector: "didTick", userInfo: nil, repeats: true)
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
  
  func addArrayToScene(array: DotArray2D) {
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let dot = array[col,row] {
          addDotToScene(dot, completion: nil)
        }
      }
    }
  }
  
  func addDotToScene(dot:Dot, completion:(() -> ())?) {
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
    sprite.position = pointForColumn(dot.column, row: dot.row)
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
        
        let connector = SKSpriteNode(texture: connTexture, size: CGSizeMake(size,size))

        connector.position = p
        connector.zPosition = 12 // zPosition to change in which layer the barra appears.
        d.connector = connector
        
        dotLayer.addChild(connector)
      }
    }

    if let c = completion {
      runAction(SKAction.waitForDuration(0.2), completion: c)
    }

  }
  
  func removeDots(dots: Array<Dot>) {
    for dot in dots {
      dot.sprite?.removeFromParent()
      if let d = dot as? GoodDot {
        d.connector?.removeFromParent()
        d.sibling?.connector?.removeFromParent()
      }
    }
  }
  
  func dropDots(fallenDots: Array<GoodDot>, completion:() -> ()) {
    var longestDuration: NSTimeInterval = 0

    for (columnIdx, dot) in fallenDots.enumerate() {
      let newPosition = pointForColumn(dot.column, row: dot.row)
      let sprite = dot.sprite!
      
      let delay = (NSTimeInterval(columnIdx) * 0.05) + (NSTimeInterval(columnIdx) * 0.05)
      let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
      let moveAction = SKAction.moveTo(newPosition, duration: duration)
      
      moveAction.timingMode = .EaseIn
      sprite.runAction(moveAction)
      
      if let p = pointForConnector(dot) {
        let connector = dot.connector!

        let movAction = SKAction.moveTo(p, duration: duration)
        movAction.timingMode = .EaseIn

        connector.runAction(movAction)
      }
      
      longestDuration = max(longestDuration, duration + delay)
    }
    
    runAction(SKAction.waitForDuration(longestDuration), completion:completion)
  }
  
  func addPieceToScene(piece: Piece, completion: (() -> ())?) {
    addDotToScene(piece.dot1, completion: nil)
    addDotToScene(piece.dot2, completion: completion)
  }
  
  func addMadDotsToScene(madDots: Array<MadDot>) {
    for dot in madDots {
      addDotToScene(dot, completion: nil)
    }
  }
  
  func didTick() {
    tick?()
  }
  
  func startTicking() {
    self.timer = NSTimer.scheduledTimerWithTimeInterval(tickLength, target: self, selector: "didTick", userInfo: nil, repeats: true)
  }
  
  func stopTicking() {
    self.timer?.invalidate()
    self.timer = nil
  }

  func redrawPiece(piece: Piece, duration: NSTimeInterval, completion:() -> ()) {
    for dot in piece.dots {
      if let sprite = dot.sprite {
        let point = pointForColumn(dot.column, row: dot.row)
        let moveToAction:SKAction = SKAction.moveTo(point, duration: duration)
        sprite.runAction(moveToAction)
        
        if let p = pointForConnector(dot) {
          let connector = dot.connector!
          let movToAction:SKAction = SKAction.moveTo(p, duration: duration)
          
          connector.runAction(movToAction)
        }

        runAction(SKAction.waitForDuration(duration), completion: completion)
      }
    }
  }
  
  func setupBackground() {
    let name = iPad ? "ipadfantasybg" : "fantasyforest"

    var texture = textureCache[name]
    
    if texture == nil {
      texture = SKTexture(imageNamed: name)
      textureCache[name] = texture
    }
    
    let background = SKSpriteNode(texture: texture, size: CGSizeMake(size.width,size.height))

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
      squareSize -= 5
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
      
      let barra = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(rowWidth, 0.5))
      barra.position = CGPoint(x: centerX, y: y - extraYSpace)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      gridLayer.addChild(barra)
    }
    
    for col in 1..<totalCols {
      let x = squareSize * CGFloat(col)
      
      let barra = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(0.5, colHeight))
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
