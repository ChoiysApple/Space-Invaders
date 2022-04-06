//
//  Invaders.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/05.
//

import SpriteKit

//MARK: Invaders
extension GameScene {
    
    func makeInvader(ofType invaderType: InvaderType) -> SKNode {
        
        let invaderTextures = [SKTexture(imageNamed: "Invader\(invaderType.rawValue)_00"),
                               SKTexture(imageNamed: "Invader\(invaderType.rawValue)_01")]

        let invader = SKSpriteNode(texture: invaderTextures[0])
        invader.name = InvaderType.name
        invader.size = CGSize(width: 32, height: 21)
        
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
        
        // Sound Effect
        let soundIndex: Int = invaderMovementCount % 4 + 1
        run(SKAction.playSoundFileNamed(soundIndex.invaderMovementSound, waitForCompletion: false))
        invaderMovementCount += 1
    }
    
    func determineInvaderMovementDirection() {

      var proposedMovementDirection: InvaderMovementDirection = invaderMovementDirection
      
      enumerateChildNodes(withName: InvaderType.name) { node, stop in
        
        switch self.invaderMovementDirection {
        case .right:
            if (node.frame.maxX >= node.scene!.size.width - node.frame.width/2) {
            proposedMovementDirection = .downThenLeft
            self.adjustInvaderMovement(to: self.timePerMove * 0.8)
              
            stop.pointee = true
          }
        case .left:
          if (node.frame.minX <= node.frame.width/2) {
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
