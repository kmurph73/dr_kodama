//
//  GameScene.swift
//  MadDots
//
//  Created by Kyle Murphy on 10/6/15.
//  Copyright (c) 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

let BlockSize:CGFloat = 25
let TickLengthLevelOne = NSTimeInterval(1024)

class GameScene: SKScene {
  let LayerPosition = CGPoint(x: 1, y: 1)
  
  var tick:(() -> ())?
  var tickLengthMillis = TickLengthLevelOne
  var lastTick:NSDate?
  var added = false

  override func didMoveToView(view: SKView) {
      /* Setup your scene here */
//      let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//      myLabel.text = "Hello, World!"
//      myLabel.fontSize = 45
//      myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    
//      self.addChild(myLabel)
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0, y: 1.0)
    
//    let background = SKSpriteNode(imageNamed: "background")
//    background.position = CGPoint(x: 0, y: 0)
//    background.anchorPoint = CGPoint(x: 0, y: 1.0)
    
//    let gameBoardTexture = SKTexture()
//    let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSizeMake(BlockSize * CGFloat(NumColumns), BlockSize * CGFloat(NumRows)))
//    gameBoard.anchorPoint = CGPoint(x:0, y:1.0)
//    gameBoard.position = LayerPosition
//    
//    addChild(gameBoard)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("NSCoder not supported")
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
     /* Called when a touch begins */
      
//      for touch in touches {
//          let location = touch.locationInNode(self)
//          print("loc: \(location)")
//        
//          let sprite = SKSpriteNode(imageNamed:"reddot")
//          
//          sprite.xScale = 100
//          sprite.yScale = 100
//          sprite.position = CGPoint(x: 350, y:  650)
//          
//          self.addChild(sprite)
//      }
  }

  func pointForColumn(column: Int, row: Int) -> CGPoint {
    let x: CGFloat = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
    let y: CGFloat = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
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
}
