//
//  MenuScene.swift
//  Midi Run
//
//  Created by Athanasia on 5/7/19.
//  Copyright © 2019 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var fontSize: CGFloat!

    
    override func didMove(to view: SKView) {
        layoutView()
        
        scoreLabel = SKLabelNode(fontNamed: "Press Start K")
        scoreLabel.text = "Highscore: 0"
        scoreLabel.fontSize = 22
        scoreLabel.position = CGPoint(x: 170.0, y: 200.0)
        scoreLabel.zPosition = GameConstants.ZPositions.hudZ
        addChild(scoreLabel)
    }
    
    func layoutView() {
        let gameLogo = SKSpriteNode(imageNamed: GameConstants.StringConstants.gameName)
        gameLogo.scale(to: frame.size, width: true, multiplier: 0.8) //80% of the frame's width
        gameLogo.position = CGPoint(x: frame.midX, y: frame.maxY*0.75 - gameLogo.frame.size.height/2)
        addChild(gameLogo)
        
        let startGame =  SKSpriteNode(imageNamed: GameConstants.StringConstants.startGame)
        startGame.scale(to: frame.size, width: false, multiplier: 0.035) //0.1 for multiplier is a tenth of the height of the screen
        startGame.position = CGPoint(x: frame.midX, y: frame.midY) //center
        addChild(startGame)
    }

    func goToGame(_: Int) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        
        // use a transition to the gameScene
        let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
        
        // transition from current scene to the new scene
        view!.presentScene(gameScene, transition: reveal)
        
        
        
    }
    

}
