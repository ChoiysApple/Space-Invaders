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
    
    let motionManager = CMMotionManager()
    
    var invaderMovementDirection: InvaderMovementDirection = .right
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0

    var tapQueue = [Int]()  // This queue can handel multiple tap action
    var contactQueue = [SKPhysicsContact]()
    
    var score: Int = 0
    var shipHealth: Float = 1.0

    // Scene Setup and Content Creation
    //MARK: Init
    override func didMove(to view: SKView) {

        setupHud()
        setupInvaders()
        setupShip()
      
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = kSceneEdgeCategory
        physicsWorld.contactDelegate = self
    }
  
    //MARK: Scene Update
    override func update(_ currentTime: TimeInterval) {
    
        moveInvaders(forUpdate: currentTime)
        fireInvaderBullets(forUpdate: currentTime)
        
        processUserMotion(forUpdate: currentTime)
        processUserTaps(forUpdate: currentTime)
        
        processContacts(forUpdate: currentTime)
        
        checkGameOver()
    }
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.tapCount == 1) {
                tapQueue.append(1)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in (touches) {
            let location = touch.location(in: self)

            if(location.x < self.size.width*0.3){
                print("Left")
            } else if(location.x > self.size.width*0.7){
                
                print("Right")
            } else {
                
                print("Middle")
            }
        }
    }

}


//MARK: Invaders
extension GameScene {
    
    func makeInvader(ofType invaderType: InvaderType) -> SKNode {
        
        let invaderTextures = [SKTexture(imageNamed: "Invader\(invaderType.rawValue)_00"),
                               SKTexture(imageNamed: "Invader\(invaderType.rawValue)_01")]

        let invader = SKSpriteNode(texture: invaderTextures[0])
        invader.name = InvaderType.name
        
        invader.run(SKAction.repeatForever(SKAction.animate(with: invaderTextures, timePerFrame: timePerMove)))
        
        invader.physicsBody = SKPhysicsBody(rectangleOf: invader.frame.size)
        invader.physicsBody!.isDynamic = false
        invader.physicsBody!.categoryBitMask = kInvaderCategory
        invader.physicsBody!.contactTestBitMask = 0x0
        invader.physicsBody!.collisionBitMask = 0x0
      
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
        }   // END of loop
    }   // END of Funciton
    
    //MARK: Invader Movement
    func moveInvaders(forUpdate currentTime: CFTimeInterval) {
      
      if (currentTime - timeOfLastMove < timePerMove) { return }
        
        determineInvaderMovementDirection()
      
        enumerateChildNodes(withName: InvaderType.name) { node, stop in
            switch self.invaderMovementDirection {
            case .right:
              node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
            case .left:
              node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            case .downThenLeft, .downThenRight:
              node.position = CGPoint(x: node.position.x, y: node.position.y - 10)
            case .none:
              break
        }
        self.timeOfLastMove = currentTime
      }
        
    }
    
    func determineInvaderMovementDirection() {

      var proposedMovementDirection: InvaderMovementDirection = invaderMovementDirection
      
      enumerateChildNodes(withName: InvaderType.name) { node, stop in
        
        switch self.invaderMovementDirection {
        case .right:
          if (node.frame.maxX >= node.scene!.size.width - 1.0) {
            proposedMovementDirection = .downThenLeft
            self.adjustInvaderMovement(to: self.timePerMove * 0.8)
              
            stop.pointee = true
          }
        case .left:
          if (node.frame.minX <= 1.0) {
            proposedMovementDirection = .downThenRight
            self.adjustInvaderMovement(to: self.timePerMove * 0.8)
              
            stop.pointee = true
          }
          
        case .downThenLeft:
          proposedMovementDirection = .left
          
          stop.pointee = true
          
        case .downThenRight:
          proposedMovementDirection = .right
          
          stop.pointee = true
          
        default:
          break
        }
        
      }
      
      if proposedMovementDirection != invaderMovementDirection { invaderMovementDirection = proposedMovementDirection }
    }

    func adjustInvaderMovement(to timePerMove: CFTimeInterval) {
      
        if self.timePerMove <= 0 { return }
      
        let ratio: CGFloat = CGFloat(self.timePerMove / timePerMove)
        self.timePerMove = timePerMove
      
        enumerateChildNodes(withName: InvaderType.name) { node, stop in
            node.speed = node.speed * ratio
        }
    }

}

//MARK: Ship
extension GameScene {
    
    func makeShip() -> SKNode {
        let ship = SKSpriteNode(imageNamed: "Ship.png")
        ship.name = kShipName
        
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        ship.physicsBody!.isDynamic = true
        ship.physicsBody!.affectedByGravity = false
        ship.physicsBody!.mass = 0.02
        
        ship.physicsBody!.categoryBitMask = kShipCategory
        ship.physicsBody!.contactTestBitMask = 0x0
        ship.physicsBody!.collisionBitMask = kSceneEdgeCategory

        return ship
    }
    
    func setupShip() {

        let ship = makeShip()
        let bottomInset = self.view?.safeAreaInsets.bottom ?? CGFloat(34)
        print(bottomInset)

        ship.position = CGPoint(x: size.width / 2.0, y: kShipSize.height / 2.0 + bottomInset)
        addChild(ship)
    }
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
      
        if let ship = childNode(withName: kShipName) as? SKSpriteNode {

            if let data = motionManager.accelerometerData {
          
                if fabs(data.acceleration.x) > 0.2 {
                    ship.physicsBody!.applyForce(CGVector(dx: 40 * CGFloat(data.acceleration.x), dy: 0))
                }
            }
        }
    }

}

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
            bullet.physicsBody!.contactTestBitMask = kInvaderCategory
        case .invaderFired:
            bullet = SKSpriteNode(color: SKColor.magenta, size: kBulletSize)
            bullet.name = kInvaderFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.categoryBitMask = kInvaderFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kShipCategory
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
    
    func processUserTaps(forUpdate currentTime: CFTimeInterval) {
        
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


//MARK: HUD
extension GameScene {
    func setupHud() {
        
        let topInset = self.view?.safeAreaInsets.top ?? CGFloat(34)
        
        let healthLabel = SKLabelNode(fontNamed: "Courier")
        healthLabel.name = kHealthHudName
        healthLabel.fontSize = 17
        healthLabel.fontColor = SKColor.red
        healthLabel.text = String(format: "Health: %.0f%%", shipHealth * 100.0)
      
        healthLabel.position = CGPoint(
            x: healthLabel.frame.size.width/2 + 20,
            y: size.height - (healthLabel.frame.size.height/2 + topInset + 10)
        )
        addChild(healthLabel)

        
        let scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 17
        scoreLabel.fontColor = SKColor.green
        scoreLabel.text = String(format: "Score: %04u", 0)
      
        scoreLabel.position = CGPoint(
            x: frame.size.width - (scoreLabel.frame.size.width/2 + 20),
            y: size.height - (scoreLabel.frame.size.height/2 + topInset + 10)
        )
        addChild(scoreLabel)
      
    }
    
    func adjustScore(by points: Int) {
        score += points
      
        if let score = childNode(withName: kScoreHudName) as? SKLabelNode {
            score.text = String(format: "Score: %04u", self.score)
        }
    }

    func adjustShipHealth(by healthAdjustment: Float) {
      
        shipHealth = max(shipHealth + healthAdjustment, 0)
      
        if let health = childNode(withName: kHealthHudName) as? SKLabelNode {
            health.text = String(format: "Health: %.0f%%", self.shipHealth * 100)
        }
    }


}

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
            
            adjustShipHealth(by: -0.334)
            
            if shipHealth <= 0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            } else {
                if let ship = childNode(withName: kShipName) {
                    ship.alpha = CGFloat(shipHealth)
                  
                    if contact.bodyA.node == ship {
                        contact.bodyB.node!.removeFromParent()
                    } else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }

            
        } else if nodeNames.contains(InvaderType.name) && nodeNames.contains(kShipFiredBulletName) {
            
            run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            adjustScore(by: 100)
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
            motionManager.stopAccelerometerUpdates()
            
            let gameOverScene: GameOverScene = GameOverScene(size: size)
            view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }

}
