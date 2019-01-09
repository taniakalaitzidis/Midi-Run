//
//  SKNode+Extensions.swift
//  Midi Run
//
//  Created by Athanasia on 12/26/18.
//  Copyright © 2018 Athanasia Kalaitzidis. All rights reserved.
//

import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file: String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let url = URL(fileURLWithPath: path)
            do {
                
                let archiver = try NSKeyedUnarchiver(forReadingFrom: Data(contentsOf: url, options: .mappedIfSafe))
                print(archiver)
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                archiver.requiresSecureCoding = false
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? SKNode
                archiver.finishDecoding()
                return scene
                
                //below is old code that doesn't work with latest Swift 4.2.
               // let sceneData = try Data(contentsOf: url, options: .mappedIfSafe)
              //  let archiver = try NSKeyedUnarchiver(forReadingFrom: sceneData)
                //archiver.setClass(self.classForKeyedArchiver(), forClassName: "SKScene")
              //  let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
               // archiver.finishDecoding()
               // return scene
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (screenSize.width * multiplier) / self.frame.size.width : (screenSize.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
    
    func turnGravity(on value: Bool) {
        physicsBody?.affectedByGravity = value
        //this value allows us to turn on the gravity of certain physics bodies
    }
    
    func createUserData(entry: Any, forKey key: String) {
        if userData == nil {
            let userDataDictionary = NSMutableDictionary()
            userData = userDataDictionary
        }
        userData!.setValue(entry, forKey: key)
    }

}



    //load scene editor file
