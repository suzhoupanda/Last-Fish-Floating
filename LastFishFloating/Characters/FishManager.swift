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
    var pathFollowingFishGroup: [Fish]?
    var avoidingFish: [Fish]?
    
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
    
    lazy var huntGoal: GKGoal = {
        
        let goal =GKGoal(toSeekAgent: self.player.agent)
        
        return goal
        
    }()
    
    lazy var wanderingGoal: GKGoal = {
        
        let goal = GKGoal(toWander: 500.0)
        return goal
    }()
    
    let maxFleeingDistance: Float = 200.0
    
    var paths: [GKPath]?
    
    var obstacles: [GKObstacle]?
    
    
    
 var pathGoal: GKGoal{
        
        guard let paths = self.paths else {
            fatalError("Error: paths array was not initialized; first provide the necessary path information, then proceed to initialize the path goal")
        }
        
        let count = paths.count
        let idx = Int(arc4random_uniform(UInt32(count)))
        let randomPath = paths[idx]
        
        let goal = GKGoal(toFollow: randomPath, maxPredictionTime: 1.5, forward: true)
        
        return goal
    }
    
    var avoidObstaclesGoal: GKGoal?{
    
        guard let obstacles = baseScene.obstacles else { return nil }
        
        return GKGoal(toAvoid: obstacles, maxPredictionTime: 1.5)
    }
    
    func addPaths(withPathConfigurations pathConfigurations: [PathConfiguration]){
        
        let gkPaths = pathConfigurations.map({
            
            return GKPath(points: $0.points, radius: $0.radius, cyclical: $0.isCyclical)
        })
        
        self.paths = gkPaths
    }
    
    func addPath(withPathConfiguration pathConfiguration: PathConfiguration){
        
        if paths == nil{
            
            paths = [GKPath]()
            
        } else {
            
            let newPath = GKPath(points: pathConfiguration.points, radius: pathConfiguration.radius, cyclical: pathConfiguration.isCyclical)
            
            paths!.append(newPath)
            
        }
    }
    
    
    func addPredatorFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        self.pathFollowingFishGroup = fishGroup
        
        self.pathFollowingFishGroup?.forEach({
            
            fish in
            
            fish.agent.behavior = GKBehavior(goal: self.huntGoal, weight: 1.00)
            
            
            if let avoidsObstaclesGoal = self.avoidObstaclesGoal, avoidsObstacles{
                fish.agent.behavior = GKBehavior(goal: avoidsObstaclesGoal, weight: 1.0)
            }
            
            baseScene.agentSystem.addComponent(fish.agent)
            
        })
    }


    
    func addPathFollowingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        self.pathFollowingFishGroup = fishGroup
        
        self.pathFollowingFishGroup?.forEach({
            
            fish in
            
            fish.agent.behavior = GKBehavior(goal: self.pathGoal, weight: 1.00)
            
            
            if let avoidsObstaclesGoal = self.avoidObstaclesGoal, avoidsObstacles{
                fish.agent.behavior = GKBehavior(goal: avoidsObstaclesGoal, weight: 1.0)
            }
            
            baseScene.agentSystem.addComponent(fish.agent)
            
        })
    }
    
    func addWanderingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
    
        self.wanderingFishGroup = fishGroup
        
        self.wanderingFishGroup?.forEach({
            fish in
            
            fish.agent.behavior = GKBehavior(goal: self.wanderingGoal, weight: 1.00)
            
            if let avoidsObstaclesGoal = self.avoidObstaclesGoal, avoidsObstacles{
                fish.agent.behavior = GKBehavior(goal: avoidsObstaclesGoal, weight: 1.0)
            }
            
            baseScene.agentSystem.addComponent(fish.agent)
            
        })
    }
    
    func addFleeingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        self.fleeingFishGroup = fishGroup
        
        self.fleeingFishGroup!.forEach({
            fish in
            
            
            fish.agent.behavior = GKBehavior(goals: [self.fleeGoal,self.stopGoal])
            
            if let avoidsObstaclesGoal = self.avoidObstaclesGoal, avoidsObstacles{
                fish.agent.behavior = GKBehavior(goal: avoidsObstaclesGoal, weight: 1.0)
            }
            
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
