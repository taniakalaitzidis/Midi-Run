//
//  GameScene.swift
//  Midi Run
//
//  Created by Athanasia on 12/26/18.
//  Copyright © 2018 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

enum GameState {
    case ready, ongoing, paused, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    //var backgroundClouds: RepeatingLayer!
    var backgroundGround: RepeatingLayer!
    var backgroundSunset: RepeatingLayer!
    
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    //using exclamation point means we won't need an initializer because we initialize the properties below
   
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
            case .finished:
                player.state = .idle
            default:
                break
                
            }
        }
    }
    
    var player: Player!
    
    var touch = false
   // var brake = false

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        // the physicsWorld.gravity is where you can change how fast or slow the player falls in the game
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x:frame.maxX, y:frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        createLayers()
    }
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.ZPositions.worldZ
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        // we want the player to move to the left and right, which is the x value
        // the value of -200 is to move left and right. y is to move up and down
        
        backgroundSunset = RepeatingLayer()
        backgroundSunset.zPosition = GameConstants.ZPositions.eveningBG
        addChild(backgroundSunset)
        
        backgroundLayer = RepeatingLayer()
        backgroundLayer.zPosition = GameConstants.ZPositions.farBGZ
        addChild(backgroundLayer)
        
//        backgroundClouds = RepeatingLayer()
//        backgroundClouds.zPosition = GameConstants.ZPositions.closeBGZ
//        addChild(backgroundClouds)
        
        backgroundGround = RepeatingLayer()
        backgroundGround.zPosition = GameConstants.ZPositions.closeBGZ
        addChild(backgroundGround)
        
       
        
        // the for in 0...1 means it will run twice; repeating effect
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundNames)
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundImage.size.width, y: 135.0)
            backgroundLayer.addChild(backgroundImage)
        }
        
//        for i in 0...1 {
//            let backgroundCloudsImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundNames[1])
//            backgroundCloudsImage.name = String(i)
//            backgroundCloudsImage.scale(to: frame.size, width: false, multiplier: 1.0/4)
//
//           // backgroundCloudsImage.size = CGSize(width: 1251, height: 130)
//            backgroundCloudsImage.anchorPoint = CGPoint.zero
//            backgroundCloudsImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundCloudsImage.size.width, y: 480.0)
//            backgroundClouds.addChild(backgroundCloudsImage)
//
//        }
        
        for i in 0...1 {
            let backgroundGroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.groundNodeName)
            backgroundGroundImage.name = String(i)
            backgroundGroundImage.size = CGSize(width: 1237, height: 142)
            backgroundGroundImage.anchorPoint = CGPoint.zero
            backgroundGroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundGroundImage.size.width, y: 0.0)
            backgroundGroundImage.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: backgroundGroundImage.size.width , height: backgroundGroundImage.size.height * 2.0))
            backgroundGroundImage.physicsBody?.affectedByGravity = false
            backgroundGroundImage.physicsBody?.isDynamic = false
            backgroundGround.addChild(backgroundGroundImage)
            
        }
        
        for i in 0...1 {
            let backgroundSunsetImage = SKSpriteNode(imageNamed: "backgroundSunset")
            backgroundSunsetImage.name = String(i)
            backgroundSunsetImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundSunsetImage.anchorPoint = CGPoint.zero
            backgroundSunsetImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundSunsetImage.size.width, y: 135.0)
            backgroundSunset.addChild(backgroundSunsetImage)
        }
        
        
        
        //change speed of background here
        backgroundLayer.layerVelocity = CGPoint(x: -10.0, y: 0.0)
        //backgroundClouds.layerVelocity = CGPoint(x: -30, y: 0.0)
        backgroundGround.layerVelocity = CGPoint(x: -100.0, y: 0.0)
        backgroundSunset.layerVelocity = CGPoint(x: -10.0, y: 0.0)

        
        load(level: "Level_0-1")
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap() {
        if let coloredTiles = mapNode.childNode(withName: GameConstants.StringConstants.coloredTilesName) as? SKTileMapNode {
            tileMap = coloredTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
            //scaling for different devices
            
            PhysicsHelper.addPhysicsBody(to: tileMap, and: GameConstants.StringConstants.groundNodeName)
            for child in coloredTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        
        addPlayer()
    }
    
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        player.zPosition = GameConstants.ZPositions.playerZ
        player.loadTextures()
        player.state = .idle
        addChild(player)
        addPlayerActions()
        
    }
    
    func addPlayerActions() {
        
        let up = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0.4)
        //again, you can change the duration of the jump
        up.timingMode = .easeOut
        //this means the action will slow down at the end for a more "realistic" jumping look
        
        player.createUserData(entry: up, forKey: GameConstants.StringConstants.jumpUpActionKey)
        
     //   let move = SKAction.moveBy(x: 0.0, y: player.size.height/4, duration: 0.4)
      //  let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.4/Double(player.jumpFrames.count))
       // let group = SKAction.group([move,jump])
        
       // player.createUserData(entry: group, forKey: GameConstants.StringConstants.brakeDescendActionKey)

    }
    
    func jump() {
        player.airborne = true
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction) {
            if self.touch {
                self.player.run(self.player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction, completion: {
                    self.player.turnGravity(on: true)
                })
            }
        }
    }
    
   // func brakeDescend() {
    //    brake = true
    //    player.physicsBody!.velocity.dy = 0.0
        
     //   player.run(player.userData?.value(forKey: GameConstants.StringConstants.brakeDescendActionKey) as! SKAction)
  //  }
    
    func handleEnemyContact() {
        die(reason: 0)
    }
    
    func die(reason: Int) {
        gameState = .finished
        player.turnGravity(on: false)
        let deathAnimation: SKAction!
        switch reason {
        case 0:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case 1:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.25)
            let wait = SKAction.wait(forDuration: 0.1)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
            deathAnimation = SKAction.sequence([up,wait,down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)

        }
        
        player.run(deathAnimation) {
            self.player.removeFromParent()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            touch = true
            if !player.airborne {
                jump()
         //   } else if !brake {
           //     brakeDescend()
            }
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    
    //over here, we have a parameter "currentTime" as a time interval, which is the system time.
    //long story short, it'll result in smooth animation and will allow the map to move from left to right
    override func update(_ currentTime: TimeInterval) {
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        lastTime = currentTime
        
        if gameState == .ongoing {
            worldLayer.update(dt)
            backgroundLayer.update(dt)
           // backgroundClouds.update(dt)
            backgroundGround.update(dt)
            backgroundSunset.update(dt)

        }
      
    }
    
    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.StringConstants.groundNodeName] {
            if let groundNode = node as? GroundNode {
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height/3
                groundNode.isBodyActivated = playerY > groundY
            }
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = false
         //   brake = false
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.enemyCategory:
            handleEnemyContact()
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.frameCategory:
            physicsBody = nil
            die(reason: 1)
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = true
        default:
            break
        }
    }
}
