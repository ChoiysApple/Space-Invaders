//
//  UFO.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/06.
//

import SpriteKit

extension GameScene {
    
    func randomEncounter() {
        
    }
    
    func encountUFO() {
    
        let ufo = SKSpriteNode(imageNamed: "ufo")
        ufo.name = kUFOName
        ufo.size = CGSize(width: 32, height: 21)
        
        ufo.physicsBody = SKPhysicsBody(rectangleOf: ufo.frame.size)
        ufo.physicsBody!.isDynamic = false
        ufo.physicsBody!.categoryBitMask = kInvaderCategory
        ufo.physicsBody!.contactTestBitMask = 0x0
        ufo.physicsBody!.collisionBitMask = 0x0
      
        self.addChild(ufo)
        
        
    }
}
