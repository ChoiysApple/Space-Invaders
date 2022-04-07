//
//  ReadyScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/07.
//

import SpriteKit

class ReadyScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .black
        
        
        createControlGuide()
    }
    
    private func crateScoreInfo() {
        
    }

    private func createControlGuide() {
        
        let guidePath = CGMutablePath()
        guidePath.addRect(CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.size.width, height: self.size.width/3)))
        
        let guidePanel = SKShapeNode(path: guidePath)
        guidePanel.strokeColor = .green
        guidePanel.lineWidth = 1
        guidePanel.glowWidth = 1
        self.addChild(guidePanel)
        
        let seperatorL = SKSpriteNode(color: .green, size: CGSize(width: 1, height: self.size.width/3))
        let seperatorR = SKSpriteNode(color: .green, size: CGSize(width: 1, height: self.size.width/3))
        seperatorL.position = CGPoint(x: self.size.width*kShipRelativeControlSize, y: self.size.width/6)
        seperatorR.position = CGPoint(x: self.size.width*(1-kShipRelativeControlSize), y: self.size.width/6)
        self.addChild(seperatorR)
        self.addChild(seperatorL)
        
        let leftLabel = SKLabelNode(fontNamed: kFontName)
        leftLabel.fontSize = 50
        leftLabel.fontColor = SKColor.white
        leftLabel.text = "<"
        leftLabel.position = CGPoint(x: self.size.width*kShipRelativeControlSize/2, y: (guidePanel.frame.size.height-leftLabel.fontSize)/2)
        self.addChild(leftLabel)
        
        let rightLabel = SKLabelNode(fontNamed: kFontName)
        rightLabel.fontSize = 50
        rightLabel.fontColor = SKColor.white
        rightLabel.text = ">"
        rightLabel.position = CGPoint(x: self.size.width*(1-kShipRelativeControlSize/2), y: (guidePanel.frame.size.height-rightLabel.fontSize)/2)
        self.addChild(rightLabel)

        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }
}
