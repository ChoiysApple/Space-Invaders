//
//  ReadyScene.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/06.
//

import SpriteKit

class ReadyScene: SKScene {

    override func didMove(to view: SKView) {
        createContent()
    }
    
    private func createContent() {
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }

}
