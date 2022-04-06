//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/24.
//


import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    var safeAreaInset = UIEdgeInsets()
    
    var invaderMovementDirection: InvaderMovementDirection = .right
    var invaderMovementCount = 0
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0

    var tapQueue = [Int]()  // This queue can handel multiple tap action
    var contactQueue = [SKPhysicsContact]()
    
    var score: Int = 0
    var shipLife: Int = 3
    
    var shipDirection = ShipMovementDireciton.idle

    // Scene Setup and Content Creation
    //MARK: Init
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .black

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = kSceneEdgeCategory
        physicsWorld.contactDelegate = self

        setupHud()
        setupInvaders()
        setupShip()
        setUpCover(position: CGPoint(x: self.frame.width*0.5, y: 80))
        setUpCover(position: CGPoint(x: self.frame.width*0.2, y: 80))
        setUpCover(position: CGPoint(x: self.frame.width*0.8 , y: 80))
    }
  
    //MARK: Scene Update
    override func update(_ currentTime: TimeInterval) {
    
        moveInvaders(forUpdate: currentTime)
        fireInvaderBullets(forUpdate: currentTime)

        processContacts(forUpdate: currentTime)
        
        checkGameOver()
        
        moveShip(direction: shipDirection, speed: 3)
    }
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.tapCount == 1) {
                tapQueue.append(1)
            }
        }
        
        shipDirection = .idle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches) {
            let location = touch.location(in: self)

            if(location.x < self.size.width*kShipRelativeControlSize){
                shipDirection = .left
            } else if(location.x > self.size.width*(1-kShipRelativeControlSize)){
                shipDirection = .right
            } else {
                processMiddleTaps()
            }
        }
        
        
    }

}


//MARK: Collision
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }
    
    func handle(_ contact: SKPhysicsContact) {
    
        // Ensure you haven't already handled this contact and removed its nodes
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil { return }
      
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        if nodeNames.contains(kShipName) && nodeNames.contains(kInvaderFiredBulletName) {
        
            run(SKAction.playSoundFileNamed("ShipHit.wav", waitForCompletion: false))
            
            adjustShipHealth(by: -1)
            
            if shipLife <= 0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            } else {
                if let ship = childNode(withName: kShipName) {
                    ship.alpha = CGFloat(shipLife)
                  
                    if contact.bodyA.node == ship {
                        contact.bodyB.node!.removeFromParent()
                    } else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }
        } else if nodeNames.contains(kCoverName) && nodeNames.contains(kInvaderFiredBulletName) {
            
            run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        
        } else if nodeNames.contains(InvaderType.name) && nodeNames.contains(kShipFiredBulletName) {
            
            run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            adjustScore(by: 100)
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            
            
        } else if nodeNames.contains(kUFOName) && nodeNames.contains(kShipFiredBulletName) {
            
            run(SKAction.playSoundFileNamed("UFOHit.wav", waitForCompletion: false))
            adjustScore(by: 1000)
            print("ufo")
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
    }
    
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            if let index = contactQueue.firstIndex(of: contact) { contactQueue.remove(at: index) }
      }
    }
}

//MARK: Game Over
extension GameScene {
    func checkGameOver() {
      
        var isInvaderTooLow = false
        enumerateChildNodes(withName: InvaderType.name) { node, stop in
        
            if (Float(node.frame.minY) <= kMinInvaderBottomHeight)   {
                isInvaderTooLow = true
                stop.pointee = true
            }
        }
      
        if childNode(withName: InvaderType.name) == nil || isInvaderTooLow || childNode(withName: kShipName) == nil {
            
            let gameOverScene: GameOverScene = GameOverScene(size: size)
            gameOverScene.score = score
            view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }

}
