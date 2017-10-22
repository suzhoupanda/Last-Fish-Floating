//
//  FishManager.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FishManager{
    
    unowned var baseScene: BaseScene
    
    var fleeingFishGroup: [Fish]?
    
    var wanderingFishGroup: [Fish]?
    
    var player: Player{
        return baseScene.player
    }
    
    
    /** Configure goals for each of the fish groups **/
    
    lazy var stopGoal: GKGoal = {
        
        let goal = GKGoal(toReachTargetSpeed: 0.00)
        return goal
    }()
    
    
    lazy var fleeGoal: GKGoal  = {
    
        let goal = GKGoal(toFleeAgent: self.player.agent)
        return goal
        
        
    }()
    
    lazy var wanderingGoal: GKGoal = {
        
        let goal = GKGoal(toWander: 500.0)
        return goal
    }()
    
    let maxFleeingDistance: Float = 200.0
    
    
    func addWanderingFishGroup(fishGroup: [Fish]){
    
        self.wanderingFishGroup = fishGroup
        
        self.wanderingFishGroup?.forEach({
            fish in
            
            fish.agent.behavior = GKBehavior(goal: self.wanderingGoal, weight: 1.00)
            baseScene.agentSystem.addComponent(fish.agent)
            
        })
    }
    
    func addFleeingFishGroup(fishGroup: [Fish]){
        
        self.fleeingFishGroup = fishGroup
        
        self.fleeingFishGroup!.forEach({
            fish in
            
            fish.agent.behavior = GKBehavior(goals: [self.fleeGoal,self.stopGoal])
            baseScene.agentSystem.addComponent(fish.agent)
        })
    }
    
    init(baseScene: BaseScene){
        self.baseScene = baseScene
    }
    
    func update(currentTime: TimeInterval){
        
        if let fleeingFishGroup = self.fleeingFishGroup{
            fleeingFishGroup.forEach({
                
                let distanceFromPlayer = $0.agent.position.getDistanceTo(point: self.player.agent.position)
                
                if(distanceFromPlayer < maxFleeingDistance){
                    
                     $0.agent.behavior?.setWeight(1.0, for: self.fleeGoal)
                    $0.agent.behavior?.setWeight(0.0, for: self.stopGoal)
                    
                } else {
                    $0.agent.behavior?.setWeight(0.0, for: self.fleeGoal)
                    $0.agent.behavior?.setWeight(1.0, for: self.stopGoal)
                }

            })
        }
    }
    
}
