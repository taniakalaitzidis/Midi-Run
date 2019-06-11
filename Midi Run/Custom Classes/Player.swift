//
//  Player.swift
//  Midi Run
//
//  Created by Athanasia on 12/27/18.
//  Copyright © 2018 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

enum PlayerState {
    case idle, running
}

class Player: SKSpriteNode {
    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    var state = PlayerState.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    var airborne = false
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerIdleAtlas), withName: GameConstants.StringConstants.idlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerRunAtlas), withName: GameConstants.StringConstants.runPrefixKey)
        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerJumpAtlas), withName: GameConstants.StringConstants.jumpPrefixKey)
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerDieAtlas), withName: GameConstants.StringConstants.diePrefixKey)
        
    }
    
    //you can change the timePerFrame rate to change the speed
    func animate(for state: PlayerState) {
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.2, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.09, resize: true, restore: true)))
        }
        
    }
    
}


