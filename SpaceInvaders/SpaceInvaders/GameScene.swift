//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/24.
//


import SpriteKit
import CoreMotion

class GameScene: SKScene {
  
  // Private GameScene Properties
  
  var contentCreated = false
  
  // Object Lifecycle Management
  
  // Scene Setup and Content Creation
  override func didMove(to view: SKView) {
    
//    if (!self.contentCreated) {
//      self.createContent()
//      self.contentCreated = true
//    }
      
      setupInvaders()
  }
  
  func createContent() {
    
    let invader = SKSpriteNode(imageNamed: "InvaderA_00.png")
    
    invader.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    
    self.addChild(invader)
    
    // black space color
    self.backgroundColor = SKColor.black
  }
  
  // Scene Update
  
  override func update(_ currentTime: TimeInterval) {
    /* Called before each frame is rendered */
  }
  
  // Scene Update Helpers
  
  // Invader Movement Helpers
  
  // Bullet Helpers
  
  // User Tap Helpers
  
  // HUD Helpers
  
  // Physics Contact Helpers
  
  // Game End Helpers
  
}


extension GameScene {
    
    func makeInvader(ofType invaderType: InvaderType) -> SKNode {
      
        let invader = SKSpriteNode(color: invaderType.color, size: InvaderType.size)
      invader.name = InvaderType.name
      
      return invader
    }
    
    func setupInvaders() {

        let baseOrigin = CGPoint(x: size.width / 3, y: size.height / 2)  // Spawn Point

        for row in 0..<kInvaderRowCount {

            var invaderType: InvaderType

            if row % 3 == 0 { invaderType = .a }
            else if row % 3 == 1 { invaderType = .b }
            else { invaderType = .c }

            let invaderPositionY = CGFloat(row) * (InvaderType.size.height * 2) + baseOrigin.y
            var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)

            for _ in 1..<kInvaderColCount {
                // 5
                let invader = makeInvader(ofType: invaderType)
                invader.position = invaderPosition

                addChild(invader)

                invaderPosition = CGPoint(
                x: invaderPosition.x + InvaderType.size.width + kInvaderGridSpacing.width,
                y: invaderPositionY
                )
            }
        }
    }


}
