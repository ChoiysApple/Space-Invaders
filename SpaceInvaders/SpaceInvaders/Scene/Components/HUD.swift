//
//  HUD.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/05.
//

import SpriteKit

//MARK: HUD
extension GameScene {
    func setupHud() {
        
        let topInset = self.view?.safeAreaInsets.top ?? CGFloat(34)
        
        let healthLabel = SKLabelNode(fontNamed: kFontName)
        healthLabel.name = kHealthHudName
        healthLabel.fontSize = 20
        healthLabel.fontColor = SKColor.red
        healthLabel.text = shipLife.lifeString
      
        healthLabel.position = CGPoint(
            x: healthLabel.frame.size.width/2 + 20,
            y: size.height - (healthLabel.frame.size.height/2 + topInset + 10)
        )
        addChild(healthLabel)

        
        let scoreLabel = SKLabelNode(fontNamed: kFontName)
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 20
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

    func adjustShipHealth(by healthAdjustment: Int) {
      
        shipLife = shipLife + healthAdjustment
        
        if shipLife <= 0 { return }
      
        if let health = childNode(withName: kHealthHudName) as? SKLabelNode {
            health.text = shipLife.lifeString
        }
    }


}
