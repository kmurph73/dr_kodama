//
//  MainScene.swift
//  MadDots
//
//  Created by Kyle Murphy on 11/10/15.
//  Copyright © 2015 Kyle Murphy. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
  var playButton = SKSpriteNode()
  let playButtonTex = SKTexture(imageNamed: "newgamebtn")
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0, y: 1.0)
    
    playButton = SKSpriteNode(texture: playButtonTex)
    playButton.position = CGPointMake(frame.midX, frame.midY)
    self.addChild(playButton)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}