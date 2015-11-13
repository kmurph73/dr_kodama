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

class GameScene: SKScene {
  let LayerPosition = CGPoint(x: 1, y: 1)
  
  var tick:(() -> ())?
  var tickLengthMillis = TickLengthLevelOne
  var lastTick:NSDate?
  var menuTapped = false

  override func didMoveToView(view: SKView) {
      /* Setup your scene here */
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    self.tickLengthMillis = NSTimeInterval(Double(abs(GameSpeed - 14)) * 102.4)

    anchorPoint = CGPoint(x: 0, y: 1.0)
    
    drawGrid()
    
    var myLabel = SKLabelNode(fontNamed: "Arial")
    myLabel.text = "Menu"
    myLabel.name = "menu"
    myLabel.fontSize = 15
    myLabel.fontColor = UIColor(red: 0.1, green: 0.6 , blue: 0.6, alpha: 1)

    myLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - (BlockSize), CGRectGetMaxY(self.frame) - (BlockSize / 2))
    self.addChild(myLabel)

    myLabel = SKLabelNode(fontNamed: "Arial")
    myLabel.text = "Level \(GameLevel)"
    myLabel.fontSize = 13
    
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - (BlockSize / 2))
    self.addChild(myLabel)
    
    myLabel = SKLabelNode(fontNamed: "Arial")
    myLabel.text = "Speed \(GameSpeed)"
    myLabel.fontSize = 13
    
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 80, CGRectGetMaxY(self.frame) - (BlockSize / 2))
    
    self.addChild(myLabel)
    
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
        print("MEEEENNNNUUUUUU")
      } else {
        menuTapped = false
      }
      
    }
     /* Called when a touch begins */
  }

  func pointForColumn(column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + ((CGFloat(column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
    let y: CGFloat = LayerPosition.y - (((CGFloat(row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1
    return CGPointMake(x, y)
  }
  
  func pointForConnector(dot: GoodDot) -> CGPoint? {
    if let side = dot.sideOfSibling() {
      let x: CGFloat = LayerPosition.x + ((CGFloat(dot.column) * BlockSize) + (BlockSize / 2)) + BlockSize - 1
      let y: CGFloat = LayerPosition.y - (((CGFloat(dot.row) * BlockSize) + (BlockSize / 2))) - BlockSize - 1
      
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
//    
//    if dot.side == .Left {
//    } else {
//      return CGPointMake(x - halfBlock, y)
//    }

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
  
  func addDotToScene(dot:Dot, completion:(() -> ())?) {
    let sprite = SKSpriteNode(imageNamed:dot.spriteName)
    
    sprite.xScale = BlockSize
    sprite.yScale = BlockSize
    sprite.size = CGSize(width: BlockSize, height: BlockSize)
    sprite.position = pointForColumn(dot.column, row: dot.row)
    dot.sprite = sprite
    
    self.addChild(sprite)
    
    print("sprite: \(sprite)")
    
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
      print("removeDot: \(dot)")
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
      
      moveAction.timingMode = .EaseOut
      sprite.runAction(
        SKAction.sequence([
          SKAction.waitForDuration(delay),
          moveAction]))
      
      if let p = pointForConnector(dot) {
        print("drop connector")
        let connector = dot.connector!

        let movAction = SKAction.moveTo(p, duration: duration)

        connector.runAction(
          SKAction.sequence([
            SKAction.waitForDuration(delay),
            movAction]))
      }
      
      longestDuration = max(longestDuration, duration + delay)
    }
    
    runAction(SKAction.waitForDuration(longestDuration), completion:completion)
  }
  
  func addPieceToScene(piece: Piece, completion: (() -> ())?) {
    addDotToScene(piece.leftDot, completion: nil)
    addDotToScene(piece.rightDot, completion: completion)
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
    
    for row in 1..<totalRows {
      let y = squareSize * CGFloat(row) * -1
      
      let barra = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(rowWidth, 0.5))
      barra.position = CGPoint(x: centerX, y: y)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      self.addChild(barra)
    }
    
    for col in 1..<totalCols {
      let x = squareSize * CGFloat(col)
      
      let barra = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(0.5, colHeight))
      barra.position = CGPoint(x: x, y: centerY)
      barra.zPosition = 9 // zPosition to change in which layer the barra appears.
      
      self.addChild(barra)
    }
    
  }
}
