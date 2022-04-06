//
//  Cover.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/06.
//

import SpriteKit

extension GameScene {
    
    func setUpCover(position: CGPoint) {

        
        // make position is center-bottom point of cover blocks
        let baseOrigin = CGPoint(x: position.x - CGFloat(kCoverSize*kCoverColCount)/2.0, y: position.y + CGFloat(kCoverSize*kCoverRowCount))
      
        for row in 0..<kCoverRowCount {
        
            let positionY = CGFloat(row * (kCoverSize)) + baseOrigin.y
            var position = CGPoint(x: baseOrigin.x, y: positionY)
        
            for _ in 0..<kCoverColCount {
          
                let cover = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 10))
                cover.name = kCoverName
                cover.position = position
          
                addChild(cover)
            
                position = CGPoint(x: position.x + CGFloat(kCoverSize), y: positionY)
            }
        }
        
    }

}

