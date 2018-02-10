//
//  DynamicFish.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/26/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AssertedFact: NSObject{
    
    var name: String
    
    init(name: String) {
        
        self.name = name
      
        super.init()
        
    }
    
   
}

/**
struct DynamicFishConfiguration{
    
    static let DefaultConfiguration = DynamicFishConfiguration(fleeSpeed: 100.0, huntSpeed: 100.0, cohereSpeed: 100.0, wanderSpeed: 100.0, fleeGoalWeight: 1.00, huntGoalWeight: 1.00, cohereGoalWeight: 1.00, wanderGoalWeight: 1.00, reachSpeedGoalWeight: 10.0)
    
    var fleeSpeed: Float
    var huntSpeed: Float
    var cohereSpeed: Float
    var wanderSpeed: Float
    
    var fleeGoalWeight: Double
    var huntGoalWeight: Double
    var cohereGoalWeight: Double
    var wanderGoalWeight: Double
    var reachSpeedGoalWeight: Double
}


class DynamicFish: Fish{
    
    
    enum FishMandate{
        
        case HuntPlayer(Player)
        case FleePlayer(Player)
        case Wander(Float)
        case AvoidObstacles([GKObstacle],TimeInterval)
        case AvoidAgentObstacles([GKAgent2D],TimeInterval)
        case ReachVelocity(Float)
        case FollowPath(GKPath,TimeInterval,Bool)
        case Stop
        case CohereWithPlayer(Player)
        case AlignWithPlayer(Player)
        
        
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
            case .CohereWithPlayer(let player):
                return GKGoal(toCohereWith: [player.agent], maxDistance: 100.0, maxAngle: 2.0*Float.pi)
            case .AlignWithPlayer(let player):
                return GKGoal(toAlignWith: [player.agent], maxDistance: 100.0, maxAngle: 2.0*Float.pi)
            }
        }
        
    }
    
    var _huntPlayerFact: AssertedFact?
    var _fleePlayerFact: AssertedFact?
    var _cohereWithPlayerFact: AssertedFact?
    
    
    var cohereWithPlayerFact: AssertedFact{
        if(_cohereWithPlayerFact == nil){
            _cohereWithPlayerFact = AssertedFact(name: "cohereWithPlayer")
        }
        
        return _cohereWithPlayerFact!
    }
    
    var huntPlayerFact: AssertedFact{
        
        if(_huntPlayerFact == nil){
            _huntPlayerFact = AssertedFact(name: "huntPlayer")
        }
        
        return _huntPlayerFact!
    }
    
    var fleePlayerFact: AssertedFact{
        
        if(_fleePlayerFact == nil){
            _fleePlayerFact = AssertedFact(name: "fleePlayer")
        }
        
        return _fleePlayerFact!
    }
    
    
    var player: Player{
    
        return self.baseScene.player
    }
    
    var fishType: FishType!
    
    var distanceToPlayer: Double{
        
        let vectorPos = self.position.getVectorFloat2()
        
        let playerPos = player.position.getVectorFloat2()
        
        let distanceToPlayer = vectorPos.getDistanceTo(point: playerPos)
    
        return Double(distanceToPlayer)
    }
    
    var ruleSystem: GKRuleSystem!
    
    var isDead: Bool = false
    
    
    var colliderType: ColliderType{
        return self.fishType.getColliderType()
    }
    
    var fleeSpeed: Float = 100.0
    var huntSpeed: Float = 100.0
    var cohereSpeed: Float = 100.0
    var wanderSpeed: Float = 1.0
    
    var fleeGoalWeight: Double = 10.0
    var huntGoalWeight: Double = 10.0
    var cohereGoalWeight: Double = 10.0
    var wanderGoalWeight: Double = 1.0
    var reachSpeedGoalWeight: Double = 1.0
    
    init(baseScene: BaseScene, fishType: FishType, position: CGPoint, radius: Float, fishConfiguration: DynamicFishConfiguration = DynamicFishConfiguration.DefaultConfiguration) {
        
        
        let defaultTexture = fishType.getTexture(forOrientation: .Right, andForOutlineState: .Unoutlined, isDead: false)
        
        super.init(withScene: baseScene, texture: defaultTexture, radius: radius, position: position)
        
        self.fleeSpeed = fishConfiguration.fleeSpeed
        self.huntSpeed = fishConfiguration.huntSpeed
        self.cohereSpeed = fishConfiguration.cohereSpeed
        self.wanderSpeed = fishConfiguration.wanderSpeed
        
        self.fleeGoalWeight = fishConfiguration.fleeGoalWeight
        self.huntGoalWeight = fishConfiguration.huntGoalWeight
        self.cohereGoalWeight = fishConfiguration.cohereGoalWeight
        self.wanderGoalWeight = fishConfiguration.wanderGoalWeight
        
        
        
        self.fishType = fishType
        
        self.baseScene.agentSystem.addComponent(self.agent)
        
        configurePhysicsProperties(withTexture: defaultTexture)
        configureRuleSystem()
        
        
        
    }
    
    override init(withScene scene: BaseScene, texture: SKTexture, radius: Float, position: CGPoint) {
        
        super.init(withScene: scene, texture: texture, radius: radius, position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func configurePhysicsProperties(withTexture texture: SKTexture){
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = self.colliderType.categoryMask
        physicsBody?.collisionBitMask = self.colliderType.collisionMask
        physicsBody?.contactTestBitMask = self.colliderType.contactMask
    }
    
    
    func configureRuleSystem(){
        
        self.ruleSystem = GKRuleSystem()
    
        if(self.fishType.getPrey() == self.player.fishType){
            
            let playerFarPredicate = NSPredicate(format: "$distanceToPlayer.doubleValue <= 200.0")
            
            let playerFarRule = GKRule(predicate: playerFarPredicate, assertingFact:self.huntPlayerFact, grade: 1.00)
            
            ruleSystem.add(playerFarRule)
            
            let playerNearPredicate = NSPredicate(format: "$distanceToPlayer.doubleValue >= 200.0")
            
            let playerNearRule = GKRule(predicate: playerNearPredicate, retractingFact: self.huntPlayerFact, grade: 1.00)
            
            ruleSystem.add(playerNearRule)
            
        } else if (self.fishType.getPredator() == self.player.fishType){
            
            let playerFarPredicate = NSPredicate(format: "$distanceToPlayer.doubleValue >= 100.0")
            
            let playerFarRule = GKRule(predicate: playerFarPredicate, retractingFact:self.fleePlayerFact, grade: 1.00)
            
            ruleSystem.add(playerFarRule)
            
            let playerNearPredicate = NSPredicate(format: "$distanceToPlayer.doubleValue <= 100.0")
            
            let playerNearRule = GKRule(predicate: playerNearPredicate, assertingFact: self.fleePlayerFact, grade: 1.00)
            
            ruleSystem.add(playerNearRule)
        } else if(self.fishType == self.player.fishType){
            
          
        
            let playerFarPredicate = NSPredicate(format: "$distanceToPlayer.doubleValue >= 100.0")
            
            let playerFarRule = GKRule(predicate: playerFarPredicate, retractingFact:self.cohereWithPlayerFact, grade: 1.00)
            
            ruleSystem.add(playerFarRule)
            
            let playerNearPredicate = NSPredicate(format: "$distanceToPlayer.doubleValue <= 100.0")
            
            let playerNearRule = GKRule(predicate: playerNearPredicate, assertingFact: self.cohereWithPlayerFact, grade: 1.00)
            
            ruleSystem.add(playerNearRule)
            
        }
        
        
        
        
    }
    
    
    func checkIsCoheringStatus(){
        let isCohering = self.ruleSystem.grade(forFact: self.cohereWithPlayerFact) > 0.0
        
        if (isCohering) {
            print("Current fish is cohereing...")
            
            
            self.agent.behavior = GKBehavior(goals: [
                FishMandate.AlignWithPlayer(self.player).FishGoal,
                FishMandate.ReachVelocity(self.cohereSpeed).FishGoal
                ], andWeights: [
                    NSNumber(floatLiteral: self.cohereGoalWeight),
                    NSNumber(floatLiteral: self.reachSpeedGoalWeight)
                ])
            
        }else {
            print("Current fish is not cohering...")
            
            self.agent.behavior = GKBehavior(goals: [
                FishMandate.Wander(10.0).FishGoal,
                FishMandate.ReachVelocity(self.wanderSpeed).FishGoal
                ], andWeights: [
                    NSNumber(floatLiteral: self.wanderGoalWeight),
                    NSNumber(floatLiteral: self.reachSpeedGoalWeight)

                ])
            
        }
    }
    
    func checkIsFleeingStatus(){
        let isFleeing = self.ruleSystem.grade(forFact: self.fleePlayerFact) > 0.0

        if (isFleeing) {
            
            
            self.agent.behavior = GKBehavior(goals: [
                FishMandate.FleePlayer(self.player).FishGoal,
                FishMandate.ReachVelocity(self.fleeSpeed).FishGoal
                ], andWeights: [
                    NSNumber(floatLiteral: self.fleeGoalWeight),
                    NSNumber(floatLiteral: self.reachSpeedGoalWeight)
                ])
            
        }else {
            
            self.agent.behavior = GKBehavior(goals: [
                FishMandate.Wander(10.0).FishGoal,
                FishMandate.ReachVelocity(self.wanderSpeed).FishGoal
                ], andWeights: [
                    NSNumber(floatLiteral: self.wanderGoalWeight),
                    NSNumber(floatLiteral: self.reachSpeedGoalWeight)

                ])
            
        }

    }
    
    func checkIsHuntingStatus(){
        let isHunting = self.ruleSystem.grade(forFact: self.huntPlayerFact) > 0.0
        
        if (isHunting) {
            
            
            self.agent.behavior = GKBehavior(goals: [
                FishMandate.HuntPlayer(self.player).FishGoal,
                FishMandate.ReachVelocity(self.huntSpeed).FishGoal
                ], andWeights: [
                    NSNumber(floatLiteral: self.huntGoalWeight),
                    NSNumber(floatLiteral: self.reachSpeedGoalWeight)
                ])
            
        }else {
            
            self.agent.behavior = GKBehavior(goals: [
                FishMandate.Wander(10.0).FishGoal,
                FishMandate.ReachVelocity(self.wanderSpeed).FishGoal
                ], andWeights: [
                    NSNumber(floatLiteral: self.wanderGoalWeight),
                    NSNumber(floatLiteral: self.reachSpeedGoalWeight)

                ])
            
        }


    }
    
    func update(currentTime: TimeInterval){
        
    
        self.ruleSystem.state["distanceToPlayer"] = NSNumber(value: self.distanceToPlayer)
        
        self.ruleSystem.reset()
        self.ruleSystem.evaluate()
        
        
        if(player.fishType == self.fishType.getPredator()){
            checkIsFleeingStatus()
        } else if(player.fishType == self.fishType.getPrey()){
            checkIsHuntingStatus()
        } else if(player.fishType == self.fishType){
            checkIsCoheringStatus()
        }
        
        
        
    }
}

**/

