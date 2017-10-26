//
//  DynamicFishManager.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/26/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DynamicFishManager{
    
    unowned var baseScene: BaseScene

    var _redFish: [DynamicFish]?
    var _orangeFish: [DynamicFish]?
    var _blueFish: [DynamicFish]?
    var _pinkFish: [DynamicFish]?
    var _blowFish: [DynamicFish]?
    var _eelFish: [DynamicFish]?

  

    init(baseScene: BaseScene) {
        self.baseScene = baseScene
    }
    
    
    func addRedFish(){
        
        if(_redFish == nil){
            _redFish = [DynamicFish]()
        }
        
        let spawnPos = CGPoint(x: 100.0, y: 100.0)
        
        let aRedFish = DynamicFish(baseScene: self.baseScene, fishType: .RedFish, position: spawnPos, radius: 10.0)
        
       
        _redFish!.append(aRedFish)
        
    }
    
    func update(currentTime: TimeInterval){
        
        if _redFish != nil{
            _redFish!.forEach({$0.update(currentTime: currentTime)})
        }
        
        if(_orangeFish != nil){
            _orangeFish!.forEach({$0.update(currentTime: currentTime)})
        }
        
        if(_blueFish != nil){
            _blueFish!.forEach({$0.update(currentTime: currentTime)})
        }
        
        if(_pinkFish != nil){
            _pinkFish!.forEach({$0.update(currentTime: currentTime)})
        }
        
        if(_eelFish != nil){
            _eelFish!.forEach({$0.update(currentTime: currentTime)})
        }
        
        if(_blowFish != nil){
            _blowFish!.forEach({$0.update(currentTime: currentTime)})
        }
        
    }
}
