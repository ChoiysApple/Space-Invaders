//
//  MainMenuScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/31.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        createContent()
    }

    
    func createContent() {
        
        let gameOverLabel = SKLabelNode(fontNamed: kFontName)
        gameOverLabel.fontSize = 30
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.text = "Space Invaders"
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        self.addChild(gameOverLabel)
        
        let tapLabel = SKLabelNode(fontNamed: kFontName)
        tapLabel.fontSize = 20
        tapLabel.fontColor = SKColor.white
        tapLabel.text = "Tap Anywhere"
        tapLabel.position = CGPoint(x: self.size.width/2, y: gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
        self.addChild(tapLabel)
        
        // black space color
        self.backgroundColor = SKColor.black

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
        
    }

}
