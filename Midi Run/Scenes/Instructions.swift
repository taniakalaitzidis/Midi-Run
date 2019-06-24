//
//  Instructions.swift
//  Midi Run
//
//  Created by Athanasia on 6/18/19.
//  Copyright © 2019 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

class InstructionsScene: SKScene {
    
    override func didMove(to view: SKView) {
        layoutView()
        
    }
    
    func layoutView() {
        self.backgroundColor = .black
        
        let startGame =  SKSpriteNode(imageNamed: GameConstants.StringConstants.startGame)
        startGame.scale(to: frame.size, width: false, multiplier: 0.045)
        startGame.position = CGPoint(x: frame.midX, y: frame.maxY*0.3)
        addChild(startGame)


        let instructions = SKLabelNode(fontNamed: "EXEPixelPerfect")
        instructions.numberOfLines = 0
        instructions.text = "Instructions: Avoid monsters by \ntapping on the screen to jump! \n\nBut be careful, don’t get pushed to \nthe edge by the platforms! \n\nCollect flying coins to add more \npoints to your score! \n\nTip: Jump higher by double tapping!"
     //   instructions.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        instructions.scale(to: frame.size, width: false, multiplier: 0.4)
        instructions.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(instructions)
        
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

