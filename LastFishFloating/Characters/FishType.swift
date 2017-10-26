//
//  FishType.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

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

enum FishType: Int{
    
    case RedFish, BlueFish, OrangeFish, PinkFish, Eel, BlowFish

    static let allPlayerTypes: [FishType] = [.OrangeFish,.RedFish,.BlueFish]
    
    static let allFishTypes: [FishType] = [.OrangeFish,.RedFish,.BlueFish, .PinkFish,.Eel]
    
    func getBasicTexture(forFishType fishType: FishType) -> SKTexture{
        switch self {
            case .RedFish:
                return SKTexture(imageNamed: "RedFish_Right")
            case .BlowFish:
                return SKTexture(imageNamed: "BlowFish_Right")
            case .BlueFish:
                return SKTexture(imageNamed: "BlueFish_Right")
            case .Eel:
                return SKTexture(imageNamed: "Eel_Right")
            case .PinkFish:
                return SKTexture(imageNamed: "PinkFish_Right")
            case .OrangeFish:
                return SKTexture(imageNamed: "OrangeFish_Right")
            }
    }
   
    func getTexture(forOrientation orientation: FishOrientation, andForOutlineState outlineState: FishOutlineState, isDead: Bool) -> SKTexture{
       
        switch (self, orientation,outlineState) {
        case (.RedFish, .Left, .Outlined):
            return isDead ?  SKTexture(imageNamed: "RedFish_Outline_Dead_Left") :  SKTexture(imageNamed: "RedFish_Outline_Left")
        case (.RedFish, .Left, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "RedFish_Dead_Left") :  SKTexture(imageNamed: "RedFish_Left")
        case (.RedFish, .Right, .Outlined):
            return isDead ?  SKTexture(imageNamed: "RedFish_Outline_Dead_Right") :  SKTexture(imageNamed: "RedFish_Outline_Right")
        case (.RedFish, .Right, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "RedFish_Dead_Right") :  SKTexture(imageNamed: "RedFish_Right")
        case (.BlueFish, .Left, .Outlined):
            return isDead ?  SKTexture(imageNamed: "BlueFish_Outline_Dead_Left") :  SKTexture(imageNamed: "BlueFish_Outline_Left")
        case (.BlueFish, .Left, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "BlueFish_Dead_Left") :  SKTexture(imageNamed: "BlueFish_Left")
        case (.BlueFish, .Right, .Outlined):
            return isDead ?  SKTexture(imageNamed: "BlueFish_Outline_Dead_Right") :  SKTexture(imageNamed: "BlueFish_Outline_Right")
        case (.BlueFish, .Right, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "BlueFish_Dead_Right") :  SKTexture(imageNamed: "BlueFish_Right")
        case (.OrangeFish, .Left, .Outlined):
            return isDead ?  SKTexture(imageNamed: "OrangeFish_Outline_Dead_Left") :  SKTexture(imageNamed: "OrangeFish_Outline_Left")
        case (.OrangeFish, .Left, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "OrangeFish_Dead_Left") :  SKTexture(imageNamed: "OrangeFish_Left")
        case (.OrangeFish, .Right, .Outlined):
            return isDead ?  SKTexture(imageNamed: "OrangeFish_Outline_Dead_Right") :  SKTexture(imageNamed: "OrangeFish_Outline_Right")
        case (.OrangeFish, .Right, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "OrangeFish_Dead_Right") :  SKTexture(imageNamed: "OrangeFish_Right")
        case (.Eel, .Left, .Outlined):
            return isDead ?  SKTexture(imageNamed: "Eel_Outline_Dead_Left") :  SKTexture(imageNamed: "Eel_Outline_Left")
        case (.Eel, .Left, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "Eel_Dead_Left") :  SKTexture(imageNamed: "Eel_Left")
        case (.Eel, .Right, .Outlined):
            return isDead ?  SKTexture(imageNamed: "Eel_Outline_Dead_Right") :  SKTexture(imageNamed: "Eel_Outline_Right")
        case (.Eel, .Right, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "Eel_Dead_Right") :  SKTexture(imageNamed: "Eel_Right")
        case (.BlowFish, .Left, .Outlined):
            return isDead ?  SKTexture(imageNamed: "BlowFish_Outline_Dead_Left") :  SKTexture(imageNamed: "BlowFish_Outline_Left")
        case (.BlowFish, .Left, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "BlowFish_Dead_Left") :  SKTexture(imageNamed: "BlowFish_Left")
        case (.BlowFish, .Right, .Outlined):
            return isDead ?  SKTexture(imageNamed: "BlowFish_Outline_Dead_Right") :  SKTexture(imageNamed: "BlowFish_Outline_Right")
        case (.BlowFish, .Right, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "BlowFish_Dead_Right") :  SKTexture(imageNamed: "BlowFish_Right")
            
        case (.PinkFish, .Left, .Outlined):
            return isDead ?  SKTexture(imageNamed: "PinkFish_Outline_Dead_Left") :  SKTexture(imageNamed: "PinkFish_Outline_Left")
        case (.PinkFish, .Left, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "PinkFish_Dead_Left") :  SKTexture(imageNamed: "PinkFish_Left")
        case (.PinkFish, .Right, .Outlined):
            return isDead ?  SKTexture(imageNamed: "PinkFish_Outline_Dead_Right") :  SKTexture(imageNamed: "PinkFish_Outline_Right")
        case (.PinkFish, .Right, .Unoutlined):
            return isDead ?  SKTexture(imageNamed: "PinkFish_Dead_Right") :  SKTexture(imageNamed: "PinkFish_Right")
        }
    }
    
    func getPredator() -> FishType{
        switch self {
        case .OrangeFish:
            return .RedFish
        case .RedFish:
            return .BlueFish
        case .BlueFish:
            return .OrangeFish
        default:
            break
            
        }
        
        return .Eel
    }
    
    func getPrey() -> FishType{
        switch self {
        case .OrangeFish:
            return .BlueFish
        case .RedFish:
            return .OrangeFish
        case .BlueFish:
            return .RedFish
        default:
            break
            
        }
        
        return .PinkFish
    }
    
    func getColliderType() -> ColliderType{
        switch self {
        case .BlowFish:
            return ColliderType.BlowFish
        case .BlueFish:
            return ColliderType.BlueFish
        case .RedFish:
            return ColliderType.RedFish
        case .OrangeFish:
            return ColliderType.OrangeFish
        case .PinkFish:
            return ColliderType.PinkFish
        case .Eel:
            return ColliderType.Eel
        }
    }
}
