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
        
        createScoreInfo()
        createControlGuide()
    }
    
    //MARK: Score Advance Table
    private func createScoreInfo() {
        
        let spacing: CGFloat = 10.0
        let duration = 0.5
        
        let leftStart: CGFloat = -100.0
        let rightStart: CGFloat = self.frame.size.width + 100
        
        let scoreTitle = SKLabelNode(fontNamed: kFontName)
        scoreTitle.fontSize = 23
        scoreTitle.fontColor = SKColor.white
        scoreTitle.text = "< SCORE ADVANCE TABLE >"
        scoreTitle.position = CGPoint(x: rightStart*2, y: self.size.height*0.8)
        self.addChild(scoreTitle)
        scoreTitle.run(SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height*0.8), duration: duration))
        
        let ufoSprite = SKSpriteNode(imageNamed: "ufo")
        ufoSprite.size = kInvaderSize
        let ufoScore = SKLabelNode(fontNamed: kFontName)
        ufoScore.fontSize = 20
        ufoScore.fontColor = SKColor.white
        ufoScore.text = "= ?? POINTS"
        ufoScore.position = CGPoint(x: leftStart, y: scoreTitle.position.y - scoreTitle.frame.height - spacing*2)
        ufoSprite.position = CGPoint(x: leftStart, y: scoreTitle.position.y - scoreTitle.frame.height - spacing*2)
        self.addChild(ufoScore)
        self.addChild(ufoSprite)
        
        ufoSprite.run(SKAction.move(to: CGPoint(x: self.size.width/2+ufoSprite.frame.width - (ufoSprite.frame.width+ufoScore.frame.size.width/2), y: scoreTitle.position.y - scoreTitle.frame.height - spacing), duration: duration))
        ufoScore.run(SKAction.move(to: CGPoint(x: self.size.width/2+ufoSprite.frame.width, y: scoreTitle.position.y - scoreTitle.frame.height - spacing*2), duration: duration))
        
        
        let ASprite = SKSpriteNode(imageNamed: "InvaderA_00")
        ASprite.size = kInvaderSize
        let AScore = SKLabelNode(fontNamed: kFontName)
        AScore.fontSize = 20
        AScore.fontColor = SKColor.white
        AScore.text = "= 10 POINTS"
        AScore.position = CGPoint(x: rightStart, y: ufoScore.position.y - ufoScore.frame.height - spacing)
        ASprite.position = CGPoint(x: rightStart, y: ufoScore.position.y - ufoScore.frame.height)
        self.addChild(AScore)
        self.addChild(ASprite)
        
        ASprite.run(SKAction.move(to: CGPoint(x: self.size.width/2+ASprite.frame.width - (ASprite.frame.width+AScore.frame.size.width/2), y: ufoScore.position.y - ufoScore.frame.height), duration: duration))
        AScore.run(SKAction.move(to: CGPoint(x: self.size.width/2+ASprite.frame.width, y: ufoScore.position.y - ufoScore.frame.height - spacing), duration: duration))
        
        let BSprite = SKSpriteNode(imageNamed: "InvaderB_00")
        BSprite.size = kInvaderSize
        let BScore = SKLabelNode(fontNamed: kFontName)
        BScore.fontSize = 20
        BScore.fontColor = SKColor.white
        BScore.text = "= 10 POINTS"
        BScore.position = CGPoint(x: leftStart, y: AScore.position.y - AScore.frame.height - spacing)
        BSprite.position = CGPoint(x: leftStart, y: AScore.position.y - AScore.frame.height)
        self.addChild(BScore)
        self.addChild(BSprite)
        
        BScore.run(SKAction.move(to: CGPoint(x: self.size.width/2+BSprite.frame.width, y: AScore.position.y - AScore.frame.height - spacing), duration: duration))
        BSprite.run(SKAction.move(to: CGPoint(x: self.size.width/2+BSprite.frame.width - (BSprite.frame.width+BScore.frame.size.width/2), y: AScore.position.y - AScore.frame.height), duration: duration))
        
        let CSprite = SKSpriteNode(imageNamed: "InvaderC_00")
        CSprite.size = kInvaderSize
        let CScore = SKLabelNode(fontNamed: kFontName)
        CScore.fontSize = 20
        CScore.fontColor = SKColor.white
        CScore.text = "= 10 POINTS"
        CScore.position = CGPoint(x: rightStart, y: BScore.position.y - BScore.frame.height - spacing)
        CSprite.position = CGPoint(x: rightStart, y: BScore.position.y - BScore.frame.height)
        self.addChild(CScore)
        self.addChild(CSprite)
        
        CScore.run(SKAction.move(to: CGPoint(x: self.size.width/2+CSprite.frame.width, y: BScore.position.y - BScore.frame.height - spacing), duration: duration))
        CSprite.run(SKAction.move(to: CGPoint(x: self.size.width/2+CSprite.frame.width - (CSprite.frame.width+CScore.frame.size.width/2), y: BScore.position.y - BScore.frame.height), duration: duration))

        let startLabel = SKLabelNode(fontNamed: kFontName)
        startLabel.fontSize = 20
        startLabel.fontColor = SKColor.green
        startLabel.text = "TAP ANYWHERE TO START"
        startLabel.position = CGPoint(x: leftStart*2, y: CScore.position.y - CScore.frame.height - spacing*5)
        addChild(startLabel)

        startLabel.run(SKAction.move(to: CGPoint(x: self.size.width/2, y: CScore.position.y - CScore.frame.height - spacing*5), duration: duration))
        

    }

    //MARK: Control guide
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

        let middleLabel = SKLabelNode(fontNamed: kFontName)
        middleLabel.fontSize = 40
        middleLabel.fontColor = SKColor.white
        middleLabel.text = "FIRE!"
        middleLabel.position = CGPoint(x: self.size.width/2, y: (guidePanel.frame.size.height-rightLabel.fontSize)/2)
        self.addChild(middleLabel)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: .push(with: .left, duration: 1.0))
    }
}
