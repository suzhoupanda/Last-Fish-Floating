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

/**
 
 Information about predator-prey relationships can be found in the FishType enum.  The pink fish can serve as prey for any fish, while the opposite if true of the eel, which is a predator for all fish.  Blowfish are general-purpose obstalces and cause damage to an fish which contacts them. They are neither predator nor prey for any fish.
 
 Other Predator-Prey relationships are as below:
 
 OrangeFish hunts   BlueFish
 BlueFish   hunts   Redfish
 RedFish    hunts   OrangeFish
 
 OrangeFish     is hunted by    RedFish
 RedFish        is hunted by    BlueFish
 BlueFish       is hunted by    OrangeFish
 **/

class DynamicFishManager{
    
    unowned var baseScene: BaseScene

    var _redFish: [DynamicFish]?
    var _orangeFish: [DynamicFish]?
    var _blueFish: [DynamicFish]?
    var _pinkFish: [DynamicFish]?
    var _blowFish: [DynamicFish]?
    var _eelFish: [DynamicFish]?

    func getFishGroup(forFishType fishType: FishType) -> [DynamicFish]?{
        switch fishType {
        case .BlowFish:
            return _blowFish
        case .BlueFish:
            return _blueFish
        case .PinkFish:
            return _pinkFish
        case .RedFish:
            return _redFish
        case .OrangeFish:
            return _orangeFish
        case .Eel:
            return _eelFish
            
        }
    }
    
    func getPreyGroup(forFishType fishType: FishType) -> [DynamicFish]?{
        switch fishType {
        case .OrangeFish:
            return _blueFish
        case .BlueFish:
            return _redFish
        case .RedFish:
            return _orangeFish
        default:
            return _pinkFish
        }
    }
    
    func getPredatorFishGroup(forFishType fishType: FishType) -> [DynamicFish]?{
        switch fishType {
        case .OrangeFish:
            return _redFish
        case .RedFish:
            return _blueFish
        case .BlueFish:
            return _orangeFish
        default:
            return _eelFish
        }
        
    }
    
    var allFishGroups: [[DynamicFish]]{
        
        var allFishGroups = [[DynamicFish]]()
        
        if let redFish = self._redFish{
            allFishGroups.append(redFish)
        }
        
        if let blueFish = self._blueFish{
            allFishGroups.append(blueFish)
        }
        
        if let orangeFish = self._orangeFish{
            allFishGroups.append(orangeFish)
        }
        
        if let eelFish = self._eelFish{
            allFishGroups.append(eelFish)
        }
        
        if let pinkFish = self._pinkFish{
            allFishGroups.append(pinkFish)
        }
        
        return allFishGroups
        
    }
    
    var allFish: [DynamicFish]{
        
        var allFish = [DynamicFish]()
        
        if let redFish = self._redFish{
            allFish = allFish + redFish
        }
        
        if let blueFish = self._blueFish{
            allFish = allFish + blueFish
        }
        
        if let orangeFish = self._orangeFish{
            allFish = allFish + orangeFish
        }
        
        if let eelFish = self._eelFish{
            allFish = allFish + eelFish
        }
        
        if let pinkFish = self._pinkFish{
            allFish = allFish + pinkFish
        }
        
        return allFish
    }

    init(baseScene: DynamicFishBaseScene) {
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
