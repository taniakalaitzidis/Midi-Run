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
    var highscoreBorderTopLayer: RepeatingLayer!
    var fontSize: CGFloat!
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0

   
    override func didMove(to view: SKView) {
        layoutView()
        highscoreBorders()

        
        highScoreLabel = SKLabelNode(fontNamed: "Press Start K")
        highScoreLabel.text = "Highscore: \(currentHighScore)"
      //  highScoreLabel.fontSize = 12
      //  highScoreLabel.fontColor = UIColor.yellow
        highScoreLabel.scale(to: frame.size, width: false, multiplier: 0.03)
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY/4)
        highScoreLabel.zPosition = GameConstants.ZPositions.hudZ
        addChild(highScoreLabel)
      
    }
    
    // frame.midX and frame.midY is center of screen
    
    
   
    func highscoreBorders() {

        for i in 0...1 {
            let highscoreBorderBottom = SKSpriteNode(imageNamed: "highscoreBorderBottom")
           // highscoreBorderBottom.alpha = 0.0
            highscoreBorderBottom.name = String(i)
            highscoreBorderBottom.scale(to: frame.size, width: true, multiplier: 1)
            highscoreBorderBottom.anchorPoint = CGPoint.zero
           // background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)

            highscoreBorderBottom.position = CGPoint(x: 0.0 + CGFloat(i) * highscoreBorderBottom.size.width, y: frame.maxY/7)
            addChild(highscoreBorderBottom)

            
            let moveLeft = SKAction.moveBy(x: -highscoreBorderBottom.size.width, y: 0, duration: 2)
            let moveReset = SKAction.moveBy(x: highscoreBorderBottom.size.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            highscoreBorderBottom.run(moveForever)
            
        }
        

//        let highscoreBorderBottom = SKSpriteNode(imageNamed: "highscoreBorderBottom")
//        highscoreBorderBottom.scale(to: frame.size, width: true, multiplier: 1)
//        highscoreBorderBottom.position = CGPoint(x: frame.midX, y: frame.maxY/5.3)
//        addChild(highscoreBorderBottom)
        
    }
    
    
    
    func layoutView() {
        
        //self.backgroundColor = UIColor(red: 53.0/255, green: 72.0/255, blue: 77.0/255, alpha: 1.0)
        self.backgroundColor = .black

        
        let gameLogo = SKSpriteNode(imageNamed: GameConstants.StringConstants.gameName)
        gameLogo.scale(to: frame.size, width: true, multiplier: 0.9) //80% of the frame's width
        gameLogo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameLogo)
        
        let startGame =  SKSpriteNode(imageNamed: GameConstants.StringConstants.startGame)
        startGame.scale(to: frame.size, width: false, multiplier: 0.045) //0.1 for multiplier is a tenth of the height of the screen
        startGame.position = CGPoint(x: frame.midX, y: frame.maxY*0.7) //center
        addChild(startGame)
        
//        let glowBox = SKSpriteNode(imageNamed: "glowBoxHighScore")
//        glowBox.scale(to: frame.size, width: false, multiplier: 0.18)
//        glowBox.position = CGPoint(x: frame.midX-6, y: frame.maxY/4)
//        addChild(glowBox)


        let musicOnOff = SKSpriteNode(imageNamed: "musicOnOff")
        musicOnOff.scale(to: frame.size, width: false, multiplier: 0.07)
        musicOnOff.position = CGPoint(x: self.frame.width*0.15, y: frame.maxY*0.9)
        addChild(musicOnOff)
        
        let instructions = SKSpriteNode(imageNamed: "instructions")
        instructions.name = "Instructions"
        instructions.scale(to: frame.size, width: false, multiplier: 0.07)
        instructions.position = CGPoint(x: frame.midX, y: frame.maxY*0.9)
        addChild(instructions)
        
        let credits = SKSpriteNode(imageNamed: "credits")
        credits.scale(to: frame.size, width: false, multiplier: 0.07)
        credits.position = CGPoint(x: self.frame.width*0.85, y: frame.maxY*0.9)
        addChild(credits)
        
       // highscoreBorders()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        
        // use a transition to the gameScene
        let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
        
        // transition from current scene to the new scene
        view!.presentScene(gameScene, transition: reveal)
        
        
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Instructions" {
                let transition:SKTransition = SKTransition.fade(withDuration: 0.4)
                let instructionScene = InstructionsScene(size: size)
                view!.presentScene(instructionScene, transition: transition)
                
            }
           
           // let location = touch.location(in: self)
//            if atPoint(location).name == "Instructions" {
//                if let view = self.view as! SKView? {
//                    let scene = InstructionsScene(size: view.bounds.size)
//
//                    scene.scaleMode = .aspectFill
//                    view.presentScene(scene)
//                    view.ignoresSiblingOrder = true

                    
                }
            }
    
    
        }
      
        

    

