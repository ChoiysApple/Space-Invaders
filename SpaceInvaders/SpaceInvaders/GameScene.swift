//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/24.
//


import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let motionManager = CMMotionManager()
    
    var invaderMovementDirection: InvaderMovementDirection = .right
    var timeOfLastMove: CFTimeInterval = 0.0
    let timePerMove: CFTimeInterval = 1.0

    
  
  // Scene Setup and Content Creation
  override func didMove(to view: SKView) {

      setupHud()
      setupInvaders()
      setupShip()
      
      motionManager.startAccelerometerUpdates()

  }
  
  // Scene Update
  override func update(_ currentTime: TimeInterval) {
    
      moveInvaders(forUpdate: currentTime)
      processUserMotion(forUpdate: currentTime)
  }
  
  // Scene Update Helpers
  
  // Invader Movement Helpers
  
  // Bullet Helpers
  
  // User Tap Helpers
  
  // HUD Helpers
  
  // Physics Contact Helpers
  
  // Game End Helpers
  
}


//MARK: Invaders
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
            
            stop.pointee = true
          }
        case .left:
          if (node.frame.minX <= 1.0) {
            proposedMovementDirection = .downThenRight
            
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
      
      //7
      if (proposedMovementDirection != invaderMovementDirection) {
        invaderMovementDirection = proposedMovementDirection
      }
    }



}

//MARK: Ship
extension GameScene {
    
    func makeShip() -> SKNode {
        let ship = SKSpriteNode(color: SKColor.green, size: kShipSize)
        ship.name = kShipName
        return ship
    }
    
    func setupShip() {
        
        let ship = makeShip()

        ship.position = CGPoint(x: size.width / 2.0, y: kShipSize.height / 2.0)
        addChild(ship)
    }
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
      
        if let ship = childNode(withName: kShipName) as? SKSpriteNode {

            if let data = motionManager.accelerometerData {
          
                if fabs(data.acceleration.x) > 0.2 {
            
                    print("Acceleration: \(data.acceleration.x)")
                    //TODO: Move Ship
                }
            }
        }
    }



}


//MARK: HUD
extension GameScene {
    func setupHud() {
    
      let scoreLabel = SKLabelNode(fontNamed: "Courier")
      scoreLabel.name = kScoreHudName
      scoreLabel.fontSize = 25
      scoreLabel.fontColor = SKColor.green
      scoreLabel.text = String(format: "Score: %04u", 0)
      
      scoreLabel.position = CGPoint(
        x: frame.size.width / 2,
        y: size.height - (40 + scoreLabel.frame.size.height/2)
      )
      addChild(scoreLabel)
      
      let healthLabel = SKLabelNode(fontNamed: "Courier")
      healthLabel.name = kHealthHudName
      healthLabel.fontSize = 25
      healthLabel.fontColor = SKColor.red
      healthLabel.text = String(format: "Health: %.0f%%", 100.0)
      
      healthLabel.position = CGPoint(
        x: frame.size.width / 2,
        y: size.height - (80 + healthLabel.frame.size.height/2)
      )
      addChild(healthLabel)
    }

}
