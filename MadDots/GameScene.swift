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
  var added = false
  
  var gridRendered = false

  override func didMoveToView(view: SKView) {
      /* Setup your scene here */
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0, y: 1.0)
    

    drawGrid()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("NSCoder not supported")
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
 
     /* Called when a touch begins */
      
    for touch in touches {
        let location = touch.locationInNode(self)
        print("loc: \(location)")
    }
    
  }

  func pointForColumn(column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + ((CGFloat(column) * BlockSize) + (BlockSize / 2)) + BlockSize
    let y: CGFloat = LayerPosition.y - (((CGFloat(row) * BlockSize) + (BlockSize / 2))) - BlockSize
    return CGPointMake(x, y)
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
    sprite.position = pointForColumn(dot.column, row: dot.row)
    dot.sprite = sprite
    
    self.addChild(sprite)
    
    let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
    let myLine:SKShapeNode = SKShapeNode(path:pathToDraw)
    
    CGPathMoveToPoint(pathToDraw, nil, 100.0, 100)
    let pt = pointForColumn(dot.column, row: dot.row)
    CGPathAddLineToPoint(pathToDraw, nil, pt.x + 200, pt.y + 200)
    
    myLine.path = pathToDraw
    myLine.strokeColor = SKColor.redColor()
    
    self.addChild(myLine)
    
    if let c = completion {
      runAction(SKAction.waitForDuration(0.2), completion: c)
    }

  }
  
  func removeDots(dots: Array<Dot>) {
    for dot in dots {
      dot.sprite?.removeFromParent()
    }
  }
  
  func dropDots(fallenDots: Array<Dot>, completion:() -> ()) {
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
      longestDuration = max(longestDuration, duration + delay)
    }
    
    runAction(SKAction.waitForDuration(longestDuration), completion:completion)
  }
  
  func addPieceToScene(piece: Piece, completion: (() -> ())?) {
    addDotToScene(piece.leftDot, completion: nil)
    addDotToScene(piece.rightDot, completion: completion)
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
    //    let moveTo = pointForColumn(piece.column, row:piece.row)
        let point = pointForColumn(dot.column, row: dot.row)
        let moveToAction:SKAction = SKAction.moveTo(point, duration: 0.05)
        moveToAction.timingMode = .EaseOut
        sprite.runAction(moveToAction)

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
    
    if !gridRendered {
      
      for row in 1..<totalRows {
        let y = squareSize * CGFloat(row) * -1
        
        let barra = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(rowWidth, 1))
        barra.position = CGPoint(x: centerX, y: y)
        barra.zPosition = 9 // zPosition to change in which layer the barra appears.
        
        self.addChild(barra)
      }
      
      for col in 1..<totalCols {
        let x = squareSize * CGFloat(col)
        
        let barra = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(1, colHeight))
        barra.position = CGPoint(x: x, y: centerY)
        barra.zPosition = 9 // zPosition to change in which layer the barra appears.
        
        self.addChild(barra)
      }
      
      gridRendered = true
    }
  }
}
