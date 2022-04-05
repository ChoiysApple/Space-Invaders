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
                
        let logoImageView = SKSpriteNode(imageNamed: "Logo")
        logoImageView.size = CGSize(width: self.size.width/1.5, height: logoImageView.size.height)
        logoImageView.position = CGPoint(x: self.size.width/2, y: self.size.height + logoImageView.size.height)
        self.addChild(logoImageView)
        

        
        let tapLabel = SKLabelNode(fontNamed: kFontName)
        tapLabel.fontSize = 20
        tapLabel.fontColor = SKColor.white
        tapLabel.text = "< Tap Anywhere >"
        tapLabel.position = CGPoint(x: self.size.width/2, y: -tapLabel.frame.size.height)
        self.addChild(tapLabel)
        
        // black space color
        self.backgroundColor = SKColor.black
        
        
        let logoAction = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height/1.5), duration: 2.0)
        let labelAction = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height/1.5 - logoImageView.frame.size.height - 40), duration: 2.0)
        
        logoImageView.run(logoAction)
        tapLabel.run(labelAction)


    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
        
    }

}
