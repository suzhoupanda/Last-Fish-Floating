//
//  DFSceneA.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/26/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class DynamicFishBaseScene: BaseScene{
    
    var dynamicFishManager: DynamicFishManager!
    
    var levelSnapshot: LevelSnapshot?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        dynamicFishManager = DynamicFishManager(baseScene: self)
        dynamicFishManager.addRedFish()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        self.dynamicFishManager.update(currentTime: currentTime)
        
        
   
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    
   
}
