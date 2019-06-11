//
//  MenuScene.swift
//  Midi Run
//
//  Created by Athanasia on 5/7/19.
//  Copyright © 2019 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var currentHighScore = UserDefaults.standard.integer(forKey: "midiRun_highscore")
    var highScoreLabel: SKLabelNode!
    var fontSize: CGFloat!

    
    override func didMove(to view: SKView) {
        layoutView()
        
        highScoreLabel = SKLabelNode(fontNamed: "Press Start K")
        highScoreLabel.text = "Highscore: \(currentHighScore)"
      //  highScoreLabel.fontSize = 12
        highScoreLabel.fontColor = UIColor.yellow
        highScoreLabel.scale(to: frame.size, width: false, multiplier: 0.03)
        highScoreLabel.position = CGPoint(x: frame.midX-6, y: frame.midY)
        highScoreLabel.zPosition = GameConstants.ZPositions.hudZ
        addChild(highScoreLabel)
      
    }
   
    func layoutView() {
        self.backgroundColor = .black

        let gameLogo = SKSpriteNode(imageNamed: GameConstants.StringConstants.gameName)
        gameLogo.scale(to: frame.size, width: true, multiplier: 0.9) //80% of the frame's width
        gameLogo.position = CGPoint(x: frame.midX, y: frame.maxY*0.85 - gameLogo.frame.size.height/2)
        addChild(gameLogo)
        
        let startGame =  SKSpriteNode(imageNamed: GameConstants.StringConstants.startGame)
        startGame.scale(to: frame.size, width: false, multiplier: 0.045) //0.1 for multiplier is a tenth of the height of the screen
        startGame.position = CGPoint(x: frame.midX, y: frame.maxY*0.6) //center
        addChild(startGame)
        
        let instructions = SKLabelNode(fontNamed: "Press Start K")
        instructions.text = "Instructions"
        instructions.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
       // instructions.fontSize = 18
        instructions.scale(to: frame.size, width: false, multiplier: 0.02)
        instructions.position = CGPoint(x: self.frame.width*0.04, y: frame.maxY/3)
        addChild(instructions)
        
        let musicOnOff = SKLabelNode(fontNamed: "Press Start K")
        musicOnOff.text = "Music on"
        musicOnOff.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        musicOnOff.scale(to: frame.size, width: false, multiplier: 0.02)
        musicOnOff.position = CGPoint(x: self.frame.width*0.04, y: frame.maxY/4)
        addChild(musicOnOff)
        
        let credits = SKLabelNode(fontNamed: "Press Start K")
        credits.text = "Credits"
        credits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        credits.scale(to: frame.size, width: false, multiplier: 0.02)
        credits.position = CGPoint(x: self.frame.width*0.04, y: frame.maxY/6)
        addChild(credits)


        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        
        // use a transition to the gameScene
        let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
        
        // transition from current scene to the new scene
        view!.presentScene(gameScene, transition: reveal)
    }
    
}
