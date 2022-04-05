//
//  Ship.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/05.
//

import SpriteKit

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

        ship.position = CGPoint(x: size.width / 2.0, y: kShipSize.height / 2.0 + bottomInset)
        addChild(ship)
    }
    
    func moveShip(direction: ShipMovementDireciton, speed: CGFloat) {
        
        guard let ship = childNode(withName: kShipName) as? SKSpriteNode else { return }
        
        let destinationX = ship.position.x + (direction.rawValue * speed)
        
        if (destinationX > ship.size.width/2 || destinationX < frame.size.width - ship.size.width/2) {
            ship.position = CGPoint(x: ship.position.x + (direction.rawValue * speed), y: ship.position.y)
        }
    }
}

