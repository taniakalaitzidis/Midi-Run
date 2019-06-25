//
//  ObjectHelper.swift
//  Midi Run
//
//  Created by Athanasia on 1/4/19.
//  Copyright © 2019 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

class ObjectHelper {

static func handleChild(sprite: SKSpriteNode, with name: String) {
    
    switch name {
    case GameConstants.StringConstants.enemyName:
        PhysicsHelper.addPhysicsBody(to: sprite, with: name)
    default:
        break
    }
}
    
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint) {
        let coin = SKSpriteNode(imageNamed: GameConstants.StringConstants.coinImageName)
        coin.size = CGSize(width: parent.size.width, height: parent.size.width)

        //coin.scale(to: frame.size, width: true, multiplier: 0.12)
        coin.name = GameConstants.StringConstants.coinName
        
        coin.position = CGPoint(x: position.x * coin.size.width + coin.size.width/2, y: position.y * coin.size.height + coin.size.height/2)
        
        let coinFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.coinRotateAtlas), withName: GameConstants.StringConstants.coinPrefixKey)
        coin.run(SKAction.repeatForever(SKAction.animate(with: coinFrames, timePerFrame: 0.1)))
        
        PhysicsHelper.addPhysicsBody(to: coin, with: GameConstants.StringConstants.coinName)
        
        parent.addChild(coin)
    }

    
}



