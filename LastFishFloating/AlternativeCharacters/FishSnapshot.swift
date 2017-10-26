//
//  FishSnapshot.swift
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


struct FishDistance{
    let source: DynamicFish
    let target: DynamicFish
    let distance: Float

}

class LevelSnapshotv2{
    
    var fishShapshots: [DynamicFish: FishSnapshot] = [:]
    
    func agentForFish(fish: DynamicFish) -> GKAgent2D {
        
        return fish.agent
        
    }
    
    init(dynamicFishBaseScene: DynamicFishBaseScene) {
        
        for fishType in FishType.allPlayerTypes{
            if let allPlayerFish = dynamicFishBaseScene.dynamicFishManager.getFishGroup(forFishType: fishType){
                
                
               
                for playerFish in allPlayerFish{
                    
                    let sourceAgent = agentForFish(fish: playerFish)
                    
                    var predatorDistances = [FishDistance]()
                    var preyDistances = [FishDistance]()
                    

                    if let predatorFishGroup = dynamicFishBaseScene.dynamicFishManager.getPredatorFishGroup(forFishType: fishType){
                    
                        for predator in predatorFishGroup{
                            let targetAgent = agentForFish(fish: predator)
                            
                            // Calculate the distance between the two agents.
                            let dx = targetAgent.position.x - sourceAgent.position.x
                            let dy = targetAgent.position.y - sourceAgent.position.y
                            let distance = hypotf(dx, dy)
                            predatorDistances.append(FishDistance(source: playerFish, target: predator, distance: distance)
)
                        }
                    }
                
                    if let preyFishGroup = dynamicFishBaseScene.dynamicFishManager.getPreyGroup(forFishType: fishType){
                    
                        for prey in preyFishGroup{
                            let targetAgent = agentForFish(fish: prey)
                            
                            // Calculate the distance between the two agents.
                            let dx = targetAgent.position.x - sourceAgent.position.x
                            let dy = targetAgent.position.y - sourceAgent.position.y
                            let distance = hypotf(dx, dy)
                            
                            preyDistances.append(FishDistance(source: playerFish, target: prey, distance: distance)
)
                        
                        }
                    }
                    
                }
                
            }
        }
        
      
        
    }
}

class LevelSnapshot{
    
    var fishShapshots: [DynamicFish: FishSnapshot] = [:]
    
    func agentForFish(fish: DynamicFish) -> GKAgent2D {
       
        return fish.agent
        
    }
    

    init(dynamicFishBaseScene: DynamicFishBaseScene) {
        
        
        // A dictionary that will contain a temporary array of `FishDistance` instances for each fish.
        var fishDistances: [DynamicFish: [FishDistance]] = [:]
        
    
        // Add an empty array to the dictionary for each entity, ready for population below.
        for fish in dynamicFishBaseScene.dynamicFishManager.allFish {
            
            fishDistances[fish] = []
        
        }
        
        let allFish = dynamicFishBaseScene.dynamicFishManager.allFish
        
        for currentIndex in 0..<allFish.count {
            
            
            let sourceFish = allFish[currentIndex]
            
            // Retrieve the `GKAgent` for the source fish.
            let sourceAgent = agentForFish(fish: sourceFish)
            
            // Iterate over the remaining fish to calculate their distance from the source agent.
            for targetFish in allFish[(currentIndex+1)..<allFish.count] {
                
                // Retrieve the `GKAgent` for the target fish.
                let targetAgent = agentForFish(fish: targetFish)
                
                // Calculate the distance between the two agents.
                let dx = targetAgent.position.x - sourceAgent.position.x
                let dy = targetAgent.position.y - sourceAgent.position.y
                let distance = hypotf(dx, dy)
                
                // Save this distance to both the source and target entity distance arrays.
                fishDistances[sourceFish]!.append(FishDistance(source: sourceFish, target: targetFish, distance: distance))
                fishDistances[targetFish]!.append(FishDistance(source: targetFish, target: sourceFish, distance: distance))
       
                
            }
   
        }

        
        for fish in allFish {
        
            let playerAgentPos = dynamicFishBaseScene.player.agent.position
            let fishAgentPos = agentForFish(fish: fish).position
            
            let dx = fishAgentPos.x - playerAgentPos.x
            let dy = fishAgentPos.y - playerAgentPos.y
            
            let distanceToPlayer = hypotf(dx, dy)
            
            let fishSnapshot = FishSnapshot(source: fish, distanceToPlayer: distanceToPlayer,fishDistances: fishDistances[fish]!)
            
            fishShapshots[fish] = fishSnapshot
        }
        

    }

    
}
class FishSnapshot{
    
    
    let fishDistances: [FishDistance]
    
    var preyDistances = [Double]()
    var predatorDistances = [Double]()
    var eelDistances = [Double]()
    var pinkFishDistances = [Double]()
    var sameSpeciesDistances = [Double]()
    
    
    var combinedPredatorDistances: Double{
        return predatorDistances.reduce(0.00, {$0+$1})
    }
    
    var combinedPreyDistances: Double{
        return preyDistances.reduce(0.00, {$0+$1})
    }
    
    var closestPreyDistance: Double{
        
        if(preyDistances.isEmpty){
            return 5000.00
        }
        
        return preyDistances.max()!
    }
    
    var closestPredatorDistance: Double{
        
        if(predatorDistances.isEmpty){
            return 5000.00
        }
        
        return predatorDistances.min()!
    }
    
    
    var predatorCount: Int{
        return predatorDistances.count
    }
    
    var preyCount: Int{
        return preyDistances.count
    }
    
    var predatorPercentage: Double{
        
        if(preyCount + predatorCount <= 0){
            return 0.00
        }
        
        return Double(predatorCount)/(Double(preyCount) + Double(predatorCount))
    }
    
    var preyPercentage: Double{
        
        if(preyCount + predatorCount <= 0){
            return 0.00
        }
        
        return Double(preyCount)/(Double(preyCount) + Double(predatorCount))
    }
    
    let source: DynamicFish
    
    let distanceToPlayer: Float
    
    var predatorType: FishType{
        return source.fishType.getPredator()
    }
    
    var preyType: FishType{
        return source.fishType.getPrey()
    }
    
   
    
    init(source: DynamicFish, distanceToPlayer: Float, fishDistances: [FishDistance]) {
        self.source = source
        self.distanceToPlayer = distanceToPlayer
        
        self.fishDistances = fishDistances.sorted(by: {
            
            return $0.distance < $1.distance
            
        })
        
       
        
        for fishDistance in self.fishDistances{
            if fishDistance.target.fishType == source.fishType.getPredator(){
                predatorDistances.append(Double(fishDistance.distance))
            }
            
            if fishDistance.target.fishType == source.fishType.getPrey(){
                preyDistances.append(Double(fishDistance.distance))

            }
            
            if fishDistance.target.fishType == FishType.PinkFish{
                pinkFishDistances.append(Double(fishDistance.distance))

            }
            
            if fishDistance.target.fishType == FishType.Eel{
                eelDistances.append(Double(fishDistance.distance))

            }
            
            if fishDistance.target.fishType == source.fishType{
                sameSpeciesDistances.append(Double(fishDistance.distance))
                
            }
        }
        
        
        
       
    }
}
