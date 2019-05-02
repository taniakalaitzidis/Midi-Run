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
    
    var pipesHolder: SKSpriteNode!
    //var platformHolder: SKSpriteNode!

    var platformTimer: Timer?

    
    
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    //using exclamation point means we won't need an initializer because we initialize the properties below
   
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var ableToJump = true
    
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
            backgroundGroundImage.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.groundCategory
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
    

    func startTimers() {
        platformTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createPlatform()
        })
    }

    func createPlatform() {
        let platform = SKSpriteNode(imageNamed: GameConstants.StringConstants.platformsName)
      //  platform.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        platform.size = CGSize(width: 141, height: 47)
        platform.zPosition = GameConstants.ZPositions.objectZ

        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: platform.size.width, height: platform.size.height))
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.groundCategory
        //platform.physicsBody?.collisionBitMask = 0
        addChild(platform)

        let maxY = size.height   - platform.size.height
        let minY = -size.height  + platform.size.height 
        let range = maxY - minY
        let platformY = maxY - CGFloat(arc4random_uniform(UInt32(range)))

        platform.position = CGPoint(x: size.width / 2 + platform.size.width / 2, y: platformY)


      //  platform.position = CGPoint(x: size.width / 2 + platform.size.width / 2, y: coinY)

        let moveLeft = SKAction.moveBy(x: -size.width - platform.size.width, y: 0, duration: 4)

        platform.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
//
//    func createPlatforms() {
//        platformHolder = SKSpriteNode()
//        platformHolder.name = "Holder"
//
//        let platformDown = SKSpriteNode(imageNamed: GameConstants.StringConstants.platformsName)
//
//        platformDown.name = "Platform"
//        platformDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        //  pipeDown.position = CGPoint(x: 7, y: 200)
//        platformDown.position = CGPoint(x: 0.0, y: 119)
//
//        platformDown.physicsBody = SKPhysicsBody(rectangleOf: platformDown.size)
//
//        platformDown.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.groundCategory
//        platformDown.physicsBody?.affectedByGravity = false
//        platformDown.physicsBody?.isDynamic = false
//
//        platformHolder.zPosition = 5
//        platformHolder.position.x = self.frame.width + 100
//
//        //       pipesHolder.position.y = CGFloat.randomBetweenNumbers(firstNum: 800)
//        //pipesHolder.position = CGPoint(x: 300, y: 0);
//
//        platformHolder.addChild(platformDown)
//        self.addChild(platformHolder)
//
//        let destination = self.frame.width
//        let move = SKAction.moveTo(x: -destination, duration: TimeInterval(8.5))
//        let remove = SKAction.removeFromParent()
//
//        platformHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
//
//    }
//
//    func spawnPlatforms() {
//        let spawn = SKAction.run({ () -> Void in
//            self.createPlatforms()
//        })
//
//        let delay = SKAction.wait(forDuration: 2, withRange: 10)
//        //   let delay = SKAction.wait(forDuration: TimeInterval(2))
//        let sequence = SKAction.sequence([spawn, delay])
//
//        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
//
//    }
    
    
    func createPipes() {
        pipesHolder = SKSpriteNode()
        pipesHolder.name = "Holder"
                
        let pipeDown = SKSpriteNode(imageNamed: GameConstants.StringConstants.enemyName)

        pipeDown.name = "Pipe"
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      //  pipeDown.position = CGPoint(x: 7, y: 200)
        pipeDown.position = CGPoint(x: 0.0, y: 119)

        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        
        pipeDown.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.enemyCategory
        pipeDown.physicsBody?.affectedByGravity = false
        pipeDown.physicsBody?.isDynamic = false
        
        pipesHolder.zPosition = 5
        pipesHolder.position.x = self.frame.width + 100

//       pipesHolder.position.y = CGFloat.randomBetweenNumbers(firstNum: 800)
        //pipesHolder.position = CGPoint(x: 300, y: 0);
        
        pipesHolder.addChild(pipeDown)
        self.addChild(pipesHolder)
        
        let destination = self.frame.width 
        let move = SKAction.moveTo(x: -destination, duration: TimeInterval(8.5))
        let remove = SKAction.removeFromParent()
        
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
        
    }
    
    func spawnObstacles() {
        let spawn = SKAction.run({ () -> Void in
            self.createPipes()
        })
       
        let delay = SKAction.wait(forDuration: 2, withRange: 10)
     //   let delay = SKAction.wait(forDuration: TimeInterval(2))
        let sequence = SKAction.sequence([spawn, delay])
        
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
        
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
                spawnObstacles()
                //spawnPlatforms()
                startTimers()

            }
            
         //   } else if !brake {
           //     brakeDescend()
            
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
            
            if player.physicsBody?.velocity.dy == 0 {
                ableToJump = true
            }
            else {
                ableToJump = false
            }

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
            print("Touched Ground")
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
            player.airborne = false
        default:
            break
        }
    }
}
