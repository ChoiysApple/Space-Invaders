//
//  UFO.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/06.
//

import SpriteKit

extension GameScene {
    
    func randomUFO() {
        
        if Int.random(in: 1...100) <= kUFOAppearancePercent {
            spwanUFO()
        }
    }
    
    func spwanUFO() {
    
        let ufo = SKSpriteNode(imageNamed: "ufo")
        ufo.name = kUFOName
        ufo.size = CGSize(width: 32, height: 21)
        
        ufo.physicsBody = SKPhysicsBody(rectangleOf: ufo.frame.size)
        ufo.physicsBody!.isDynamic = false
        ufo.physicsBody!.categoryBitMask = kHostileCategory
        ufo.physicsBody!.contactTestBitMask = 0x0
        ufo.physicsBody!.collisionBitMask = 0x0
        
        
        let spawnYpoint = CGFloat(kInvaderRowCount) * (InvaderType.size.height * 2) + self.size.height/2 + ufo.size.height
        var departure = CGPoint(x: -ufo.size.width , y: spawnYpoint)
        var destination = CGPoint(x: self.size.width + ufo.size.width*2 , y: spawnYpoint)
        if Bool.random() { swap(&departure, &destination) }
        
        ufo.position = departure
        
        self.addChild(ufo)
        
        let moveAction = SKAction.sequence([
            SKAction.move(to: destination, duration: 2.5),
            SKAction.wait(forDuration: 3.0 / 60.0),
            SKAction.removeFromParent()
            ])
        let soundAction = SKAction.playSoundFileNamed("ufo.wav", waitForCompletion: true)
        let actionMoveDone = SKAction.removeFromParent()
            
        ufo.run(SKAction.sequence([SKAction.group([moveAction, soundAction]), actionMoveDone]) )
        
    }
}
