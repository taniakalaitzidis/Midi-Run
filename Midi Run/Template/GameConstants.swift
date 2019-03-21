//
//  GameConstants.swift
//  Midi Run
//
//  Created by Athanasia on 12/27/18.
//  Copyright © 2018 Athanasia Kalaitzidis. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
    struct PhysicsCategories {
        static let noCategory: UInt32 = 0
        static let allCategory: UInt32 = UInt32.max
        static let playerCategory: UInt32 = 0x1
        static let groundCategory: UInt32 = 0x1 << 1
        static let finishCategory: UInt32 = 0x1 << 2
        static let collectibleCategory: UInt32 = 0x1 << 3
        static let enemyCategory: UInt32 = 0x1 << 4
        static let frameCategory: UInt32 = 0x1 << 5
        static let ceilingCategory: UInt32 = 0x1 << 6
    }
    
    struct ZPositions {
        static let eveningBG: CGFloat = -1
        static let farBGZ: CGFloat = 0
        static let closeBGZ: CGFloat = 1
        static let worldZ: CGFloat = 2
        static let objectZ: CGFloat = 3
        static let playerZ: CGFloat = 4
        static let hudZ: CGFloat = 5
    }
    
    struct StringConstants {
        static let coloredTilesName = "Colored Tiles"
        static let worldBackgroundNames = ["backgroundsmaller", "clouds"]
        static let playerName = "Player"
        static let playerImageName = "idle0"
        static let groundNodeName = "ground"
        static let enemyName = "Enemy"
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let idlePrefixKey = "idle"
        static let runPrefixKey = "run_"
        static let jumpPrefixKey = "jump"
        static let diePrefixKey = "die_"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendActionKey = "BrakeDescend"
        
        
    }
    
}
