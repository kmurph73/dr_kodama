//
//  GameScene.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright (c) 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

var BlockSize: CGFloat = 0
let TickLengthLevelOne = NSTimeInterval(1024)
var extraYSpace: CGFloat = 0

class GameScene: SKScene {
  let LayerPosition = CGPoint(x: 1, y: 1)
  
  var ctrl: GameViewController?
  var tick:(() -> ())?
  var tickLengthMillis = TickLengthLevelOne
  var lastTick:NSDate?
  var menuTapped = false
  var levelLabel: SKLabelNode?

  override func didMoveToView(view: SKView) {
      /* Setup your scene here */
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    self.tickLengthMillis = NSTimeInterval(Double(abs(GameSpeed - 14)) * 102.4)

    anchorPoint = CGPoint(x: 0, y: 1.0)
    
    drawGrid()
    
    let y = CGRectGetMaxY(self.frame) - (extraYSpace)
    
    var myLabel = SKLabelNode(fontNamed: "Arial")
    myLabel.text = "Menu"
    myLabel.name = "menu"
    myLabel.fontSize = 25
    myLabel.fontColor = UIColor(red: 0.1, green: 0.6 , blue: 0.6, alpha: 1)

    myLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - (BlockSize * 2), y)
    self.addChild(myLabel)
    
    setLevelLabel()

    myLabel = SKLabelNode(fontNamed: "Arial")
    myLabel.text = "Speed \(GameSpeed)"
    myLabel.fontSize = 13
    
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 80, y)
    
    self.addChild(myLabel)
  }
  
  func setLevelLabel() {
    let y = CGRectGetMaxY(self.frame) - (extraYSpace)

    if levelLabel != nil {
      levelLabel!.removeFromParent()
    }

    levelLabel = SKLabelNode(fontNamed: "Arial")
    levelLabel!.text = "Level \(GameLevel)"
    levelLabel!.fontSize = 13
    
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
          lastTick = nil
        }
      } else {
        menuTapped = false
      }
      
    }
     /* Called when a touch begins */
  }

  func pointForColumn(column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + ((CGFloat(column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
    let y: CGFloat = LayerPosition.y - (((CGFloat(row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1
    return CGPointMake(x, y - extraYSpace)
  }
  
  func pointForConnector(dot: GoodDot) -> CGPoint? {
    if let side = dot.sideOfSibling() {
      let x: CGFloat = LayerPosition.x + ((CGFloat(dot.column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
      let y: CGFloat = (LayerPosition.y - (((CGFloat(dot.row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1) - extraYSpace
      
      let halfBlock = BlockSize / 2 - ((BlockSize / 4) / 2)
  
      switch side {
      case .Left:
        return CGPointMake(x - halfBlock, y)
      case .Right:
        return CGPointMake(x + halfBlock, y)
      case .Bottom:
        return CGPointMake(x, y - halfBlock)
      case .Top:
        return CGPointMake(x, y + halfBlock)
      }
    } else {
      return nil
    }

  }
  
  func resumeGame() {
    lastTick = NSDate()
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    if lastTick == nil {
      return
    }
    
    let timePassed = lastTick!.timeIntervalSinceNow * -1000.0
    
    if timePassed > tickLengthMillis {
      lastTick = NSDate()
      tick?()
    }
  }
  
  func addArrayToScene(array: Array2D<Dot>) {
    for row in 0..<NumRows {
      for col in 0..<NumColumns {
        if let dot = array[col,row] {
          addDotToScene(dot, completion: nil)
        }
      }
    }
  }
  
  func addDotToScene(dot:Dot, completion:(() -> ())?) {
    let sprite = SKSpriteNode(imageNamed:dot.spriteName)
    
    sprite.xScale = BlockSize
    sprite.yScale = BlockSize
    sprite.size = CGSize(width: BlockSize, height: BlockSize)
    sprite.position = pointForColumn(dot.column, row: dot.row)
    dot.sprite = sprite
    
    self.addChild(sprite)
        
    if let d = dot as? GoodDot {
      if let p = pointForConnector(d) {
        let size = BlockSize / 4
        let connector = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(size,size))

        connector.position = p
        connector.zPosition = 10 // zPosition to change in which layer the barra appears.
        d.connector = connector
        
        self.addChild(connector)
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
  
  func startTicking() {
    lastTick = NSDate()
  }
  
  func stopTicking() {
    lastTick = nil
  }

  func redrawPiece(piece: Piece, completion:() -> ()) {
    for dot in piece.dots {
      if let sprite = dot.sprite {
        let point = pointForColumn(dot.column, row: dot.row)
        let moveToAction:SKAction = SKAction.moveTo(point, duration: 0.05)
        moveToAction.timingMode = .EaseOut
        sprite.runAction(moveToAction)
        
        if let p = pointForConnector(dot) {
          let connector = dot.connector!
          let movToAction:SKAction = SKAction.moveTo(p, duration: 0.05)
          
          movToAction.timingMode = .EaseOut
          connector.runAction(movToAction)
        }

        runAction(SKAction.waitForDuration(0.05), completion: completion)
      }
    }
  }
  
  func drawGrid() {
    let totalRows = NumRows + 2
    let totalCols = NumColumns + 2
    
    let rowSquare = self.frame.minY  / CGFloat(totalRows) * -1
    let colSquare = self.frame.maxX / CGFloat(totalCols)
    
    let squareSize = rowSquare > colSquare ? colSquare : rowSquare
    BlockSize = squareSize
    
    let rowWidth = (CGFloat(NumColumns) * squareSize)
    let colHeight = (CGFloat(NumRows) * squareSize)
    
    let centerX = ((squareSize * CGFloat(NumColumns + 1)) + squareSize) / 2
    let centerY = ((squareSize * CGFloat(NumRows + 1)) + squareSize) / 2 * -1
    
    extraYSpace = (self.frame.minY * -1) - colHeight - (squareSize * 2)
    
    for row in 1..<totalRows {
      let y = squareSize * CGFloat(row) * -1
      
      let barra = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(rowWidth, 0.5))
      barra.position = CGPoint(x: centerX, y: y - extraYSpace)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      self.addChild(barra)
    }
    
    for col in 1..<totalCols {
      let x = squareSize * CGFloat(col)
      
      let barra = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(0.5, colHeight))
      barra.position = CGPoint(x: x, y: centerY - extraYSpace)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      self.addChild(barra)
    }
    
  }
  
  deinit {
    print("GameScene is being deinitialized")
  }
}
