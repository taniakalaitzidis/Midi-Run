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

}
