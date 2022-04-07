//
//  GameOverScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/24.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    let defaults = UserDefaults.standard
    
    var contentCreated = false
    var score = 0
    var isHighScore = false
    
    override func didMove(to view: SKView) {
        
        isHighScore = highScoreCheck(score: score)
        
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
        
        run(SKAction.playSoundFileNamed("over.wav", waitForCompletion: false))
    }
    
    private func createContent() {
        
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
        
        let highScoreAlert = SKLabelNode(fontNamed: kFontName)
        highScoreAlert.fontSize = 35
        highScoreAlert.fontColor = .yellow
        highScoreAlert.text = String(format: "New High Score!!!", score)
        highScoreAlert.position = CGPoint(x: self.size.width/2, y: scoreLabel.position.y - (highScoreAlert.fontSize + 50))
        if isHighScore { self.addChild(highScoreAlert) }
        
        
        let tapLabel = SKLabelNode(fontNamed: kFontName)
        tapLabel.fontSize = 20
        tapLabel.fontColor = SKColor.white
        tapLabel.text = "(Tap to Play Again)"
        tapLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        self.addChild(tapLabel)
        
        // black space color
        self.backgroundColor = SKColor.black
    }
    
    private func highScoreCheck(score: Int) -> Bool {
        
        let highScore = defaults.integer(forKey: kHighScoreID)
        
        if highScore == 0 {
            defaults.set(score, forKey: kHighScoreID)
            return false
        } else if score > highScore {
            defaults.set(score, forKey: kHighScoreID)
            return true
        } else {
            return false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: SKTransition.doorsOpenVertical(withDuration: 1.0))
        
    }
}
