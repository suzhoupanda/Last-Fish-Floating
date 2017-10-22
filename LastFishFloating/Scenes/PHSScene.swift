//
//  PHSScene.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PHSScene: BaseScene{
    
    var fishManager: FishManager!
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let fish1 = Fish(baseScene: self, fishType: .OrangeFish, position: CGPoint(x: 100, y: 100), radius: 40.0)
        fish1.configureAgent(withMaxSpeed: 20, andWithMaxAccelerationOf: 40)

        let fish2 = Fish(baseScene: self, fishType: .OrangeFish, position: CGPoint(x: 300, y: 40), radius: 40.0)
        fish2.configureAgent(withMaxSpeed: 20, andWithMaxAccelerationOf: 40)

        let fish3 = Fish(baseScene: self, fishType: .OrangeFish, position: CGPoint(x: -50, y: -100), radius: 40.0)
        fish3.configureAgent(withMaxSpeed: 20, andWithMaxAccelerationOf: 40)

        
        self.fishManager = FishManager(baseScene: self)
        
        self.fishManager.addWanderingFishGroup(fishGroup: [fish1,fish2,fish3])
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        self.fishManager.update(currentTime: currentTime)
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}
