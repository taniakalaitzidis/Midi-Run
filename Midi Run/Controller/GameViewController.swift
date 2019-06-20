//
//  GameViewController.swift
//  Midi Run
//
//  Created by Athanasia on 12/26/18.
//  Copyright © 2018 Athanasia Kalaitzidis. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentHighScore = UserDefaults.standard.integer(forKey: "midiRun_highscore")
    //putting in the highscore here in order to access it in different scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            
            scene.scaleMode = .aspectFill
            //entire scene will be filled
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
          //  child nodes within scene do not have to be rendered hierarchically = better performance
            
           // below is debugging information = efficiency of code thats written
            
            view.showsFPS = true
            //shows frames per seconds

            view.showsNodeCount = true
            // shows amount of nodes

            view.showsPhysics = true
            //shows the blue lines around any physics
         
        }
  
    }
}

