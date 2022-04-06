//
//  GameOverScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/24.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var contentCreated = false
    var score = 0
    
    override func didMove(to view: SKView) {
        
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
        
        run(SKAction.playSoundFileNamed("over.wav", waitForCompletion: false))
    }
    
    func createContent() {
        
        let gameOverLabel = SKLabelNode(fontNamed: kFontName)
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.75)
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: kFontName)
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .green
        scoreLabel.text = String(format: "Score: %04u", score)
        scoreLabel.position = CGPoint(x: self.size.width/2, y: gameOverLabel.position.y - (scoreLabel.fontSize + 60))
        self.addChild(scoreLabel)
        
        let tapLabel = SKLabelNode(fontNamed: kFontName)
        tapLabel.fontSize = 20
        tapLabel.fontColor = SKColor.white
        tapLabel.text = "(Tap to Play Again)"
        tapLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
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
