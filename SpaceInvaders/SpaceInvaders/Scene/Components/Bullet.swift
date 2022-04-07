//
//  Bullet.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/05.
//

import SpriteKit

//MARK: Bullet
extension GameScene {
    func makeBullet(ofType bulletType: BulletType) -> SKNode {
        var bullet: SKNode
      
        switch bulletType {
        case .shipFired:
            bullet = SKSpriteNode(color: SKColor.green, size: kBulletSize)
            bullet.name = kShipFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.categoryBitMask = kShipFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kHostileCategory
        case .invaderFired:
            bullet = SKSpriteNode(color: SKColor.magenta, size: kBulletSize)
            bullet.name = kInvaderFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.categoryBitMask = kInvaderFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kFriendlyCategory
            break
        }
        
        bullet.physicsBody!.isDynamic = true
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.collisionBitMask = 0x0

        return bullet
    }
    
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
      
        let bulletAction = SKAction.sequence([
            SKAction.move(to: destination, duration: duration),
            SKAction.wait(forDuration: 3.0 / 60.0),
            SKAction.removeFromParent()
            ])
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

        bullet.run(SKAction.group([bulletAction, soundAction]))
      
        addChild(bullet)
    }

    // Ship Bullet
    func fireShipBullets() {
        if let _ = childNode(withName: kShipFiredBulletName) { return }     // Check is there any existing bullet
        guard let ship = childNode(withName: kShipName) else { return }     // Check is there ship
        
        
        let bullet = makeBullet(ofType: .shipFired)
        bullet.position = CGPoint(x: ship.position.x, y: ship.position.y + ship.frame.size.height - bullet.frame.size.height / 2)
  
        let bulletDestination = CGPoint(x: ship.position.x, y: frame.size.height + bullet.frame.size.height / 2 )
  
        fireBullet(
            bullet: bullet,
            toDestination: bulletDestination,
            withDuration: 1.0,
            andSoundFileName: "ShipBullet.wav"
        )
    }
    
    func processMiddleTaps() {

        for tapCount in tapQueue {
            if tapCount == 1 { fireShipBullets() }
            tapQueue.remove(at: 0)
        }
    }

    // Invader Bullet
    func fireInvaderBullets(forUpdate currentTime: CFTimeInterval) {
        if let _ = childNode(withName: kInvaderFiredBulletName) { return }
      
        var allInvaders = [SKNode]()
        enumerateChildNodes(withName: InvaderType.name) { node, stop in
            allInvaders.append(node)
        }
        
        guard allInvaders.count > 0 else { return }

        // get random invader
        let invader = allInvaders[Int(arc4random_uniform(UInt32(allInvaders.count)))]

        let bullet = makeBullet(ofType: .invaderFired)
        bullet.position = CGPoint(
            x: invader.position.x,
            y: invader.position.y - invader.frame.size.height / 2 + bullet.frame.size.height / 2)

        let bulletDestination = CGPoint(x: invader.position.x, y: -(bullet.frame.size.height / 2))
        fireBullet(
            bullet: bullet,
            toDestination: bulletDestination,
            withDuration: 2.0,
            andSoundFileName: "InvaderBullet.wav")
        
      
    }

}
