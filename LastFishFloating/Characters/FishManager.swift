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
    
    
    
    enum FishMandate{
        
        case HuntPlayer(Player)
        case FleePlayer(Player)
        case Wander(Float)
        case AvoidObstacles([GKObstacle],TimeInterval)
        case AvoidAgentObstacles([GKAgent2D],TimeInterval)
        case ReachVelocity(Float)
        case FollowPath(GKPath,TimeInterval,Bool)
        case Stop
        
  
        var FishGoal: GKGoal{
            
            switch self {
                case .HuntPlayer(let player):
                    return GKGoal(toSeekAgent: player.agent)
                case .FleePlayer(let player):
                    return GKGoal(toFleeAgent: player.agent)
                case .ReachVelocity(let targetVelocity):
                    return GKGoal(toReachTargetSpeed: targetVelocity)
                case .Stop:
                    return GKGoal(toReachTargetSpeed: 0.00)
                case .Wander(let float):
                    return GKGoal(toWander: float)
                case .AvoidObstacles(let obstacles,let predictionTime):
                    return GKGoal(toAvoid: obstacles, maxPredictionTime: predictionTime)
                case .AvoidAgentObstacles(let agents, let predictionTime):
                    return GKGoal(toAvoid: agents, maxPredictionTime: predictionTime)
                case .FollowPath(let path,let predictionTime, let isCyclical):
                    return GKGoal(toFollow: path, maxPredictionTime: predictionTime, forward: isCyclical)
             
            }
        }
        
    }
    
    unowned var baseScene: BaseScene
    
    var fleeingFishGroup: [Fish]?
    var wanderingFishGroup: [Fish]?
    var playerHuntingFishGroup: [Fish]?
    var pathFollowingFishGroup: [Fish]?
    var avoidingFish: [Fish]?
    var flockingPreyFish: [Fish]?
    var flockingPredatorFish: [Fish]?
    
    var player: Player{
        return baseScene.player
    }
    
    
    /** Configure goals for each of the fish groups **/

    let maxFleeingDistance: Float = 200.0
    
    
    
 

    
    func addPlayerHuntingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        self.playerHuntingFishGroup = fishGroup
        
        self.playerHuntingFishGroup?.forEach({
            
            fish in
            
            fish.agent.behavior = GKBehavior(goal: FishMandate.HuntPlayer(self.player).FishGoal, weight: 1.00)
            
            
            if let obstacleAgents = self.baseScene.obstaclesAgents, avoidsObstacles{
    
                
                let weight1 = NSNumber(floatLiteral: 1.00)
                let weight2 = NSNumber(floatLiteral: 100.00)
                
                fish.agent.behavior = GKBehavior(goals: [
                    FishMandate.HuntPlayer(self.player).FishGoal,
                    FishMandate.AvoidAgentObstacles(obstacleAgents, 3.00).FishGoal
                    ], andWeights:
                    
                    [
                        weight1,
                        weight2
                    ])
                
            }
            
            baseScene.agentSystem.addComponent(fish.agent)
            
        })
    }


    
    func addPathFollowingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        self.pathFollowingFishGroup = fishGroup
        
        self.pathFollowingFishGroup?.forEach({
            
            fish in
            
            if let paths = baseScene.paths{
                let randomIdx = Int(arc4random_uniform(UInt32(paths.count)))
                let randomPath = paths[randomIdx]
                
                fish.agent.behavior = GKBehavior(goal: FishMandate.FollowPath(randomPath, 5.00, true).FishGoal, weight: 1.00)
            }
            
            
            if let obstacles = self.baseScene.obstacles, avoidsObstacles{
                //TODO: not yet implemented
            }
            
            baseScene.agentSystem.addComponent(fish.agent)
            
        })
    }
    
    func addWanderingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
    
        self.wanderingFishGroup = fishGroup
        
        self.wanderingFishGroup?.forEach({
            fish in
            
            fish.agent.behavior = GKBehavior(goal: FishMandate.Wander(500.00).FishGoal, weight: 1.00)
            
            if let obstacles = self.baseScene.obstacles, avoidsObstacles{
                fish.agent.behavior = GKBehavior(goals: [
                    
                    FishMandate.Wander(500.00).FishGoal,
                    FishMandate.AvoidObstacles(obstacles, 3.00).FishGoal
                    
                    ], andWeights: [
                        
                    NSNumber(floatLiteral: 10.00),
                    NSNumber(floatLiteral: 100.00)
                ])
            }
            
            baseScene.agentSystem.addComponent(fish.agent)
    
        })
    }
    
    func addFlockingFish(fishGroup: [Fish], avoidsObstacles: Bool){
        
    }
    
    func addFlockingPredatorFish(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        /** Get reference for each fish's agent component **/
        let fishAgents: [GKAgent2D] = fishGroup.map({$0.agent})
        
        let separationRadius: Float =  0.553*50.00
        let separationAngle: Float  = 3*Float.pi/4.0
        let separationWeight: Double =  10.0
        
        let alignmentRadius: Float = 0.83333*50.0
        let alignmentAngle: Float  = Float.pi/4.0
        let alignmentWeight: Double = 12.66
        
        let cohesionRadius: Float = 1.0*100.00
        let cohesionAngle: Float  = Float.pi/2.0
        let cohesionWeight: Double = 8.66
        
        let behavior = GKBehavior(weightedGoals: [
            GKGoal(toAlignWith: fishAgents, maxDistance: alignmentRadius, maxAngle: alignmentAngle): NSNumber(floatLiteral: alignmentWeight),
            GKGoal(toSeparateFrom: fishAgents, maxDistance: separationRadius, maxAngle: separationAngle): NSNumber(floatLiteral: separationWeight),
            GKGoal(toCohereWith: fishAgents, maxDistance: cohesionRadius, maxAngle: cohesionAngle): NSNumber(floatLiteral: cohesionWeight),
            GKGoal(toWander: 500.0): NSNumber(floatLiteral: 100.0)
        
           // GKGoal(toSeekAgent: self.player.agent): NSNumber(floatLiteral: 10.00)
        ])
            
        fishAgents.forEach({
            
            agent in
            
            agent.behavior = behavior
            
            self.baseScene.agentSystem.addComponent(agent)
        })
    }
    
    func addFlockingPreyFish(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        let fishAgents: [GKAgent2D] = fishGroup.map({$0.agent})

        fishAgents.forEach({
            
            agent in
            
            
        })
        
    }
    

    
    func addFleeingFishGroup(fishGroup: [Fish], avoidsObstacles: Bool = false){
        
        self.fleeingFishGroup = fishGroup
        
        self.fleeingFishGroup!.forEach({
            fish in
            
            
            fish.agent.behavior = GKBehavior(goals: [FishMandate.FleePlayer(self.player).FishGoal,FishMandate.Stop.FishGoal])
            
            if let obstacleAgents = self.baseScene.obstaclesAgents, avoidsObstacles{
                fish.agent.behavior = GKBehavior(goals: [
                    
                    FishMandate.AvoidAgentObstacles(obstacleAgents, 3.00).FishGoal,
                    FishMandate.FleePlayer(self.player).FishGoal,
                    FishMandate.Stop.FishGoal],
                                                 
                 andWeights: [
                        NSNumber(value:100.0),
                        NSNumber(value:100.0),
                        NSNumber(value:0.00)
                        ])
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
                    
                     $0.agent.behavior?.setWeight(1.0, for: FishMandate.FleePlayer(self.player).FishGoal)
                    $0.agent.behavior?.setWeight(0.0, for: FishMandate.Stop.FishGoal)
                    
                } else {
                    $0.agent.behavior?.setWeight(0.0, for: FishMandate.FleePlayer(self.player).FishGoal)
                    $0.agent.behavior?.setWeight(1.0, for: FishMandate.Stop.FishGoal)
                }

            })
        }
    }
    
}
