//
//  ColliderType.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/25/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SpriteKit

struct ColliderType: OptionSet, Hashable{
    
    
    //MARK: Static properties
    
    //A dictionary of which ColliderType's should collide with other ColliderType's
    static var definedCollisions: [ColliderType:[ColliderType]] = [
        
        ColliderType.RedFish : [ColliderType.BlowFish,ColliderType.Barrier],
        ColliderType.OrangeFish: [ColliderType.BlowFish,ColliderType.Barrier],
        ColliderType.BlueFish: [ColliderType.BlowFish,ColliderType.Barrier],
        ColliderType.BlowFish: [ColliderType.BlowFish, ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlueFish,ColliderType.PinkFish,ColliderType.Eel,ColliderType.Barrier],
        ColliderType.PinkFish: [ColliderType.BlowFish,ColliderType.Barrier],
        ColliderType.Eel: [ColliderType.Eel,ColliderType.BlowFish],
        ColliderType.Barrier: [ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlueFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Eel,ColliderType.Player],
        ColliderType.Player: [ColliderType.Player,ColliderType.Barrier]
      
        
    ]
    
    //A dictionary to specify which ColliderType's should be notified of contact with other ColliderType's
    static var requestedContactNotifications: [ColliderType:[ColliderType]] =  [
        
        ColliderType.RedFish : [ColliderType.BlueFish,ColliderType.OrangeFish,ColliderType.PinkFish,ColliderType.Eel,ColliderType.BlowFish,ColliderType.Barrier],
        ColliderType.OrangeFish: [ColliderType.RedFish,ColliderType.BlueFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Eel,ColliderType.Barrier],
        ColliderType.BlueFish: [ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Eel,ColliderType.Barrier],
        ColliderType.BlowFish: [ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlueFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Barrier],
        ColliderType.PinkFish: [ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlueFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Eel,ColliderType.Barrier],
        ColliderType.Eel: [ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlueFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Eel],
        ColliderType.Barrier: [ColliderType.RedFish,ColliderType.OrangeFish,ColliderType.BlueFish,ColliderType.BlowFish,ColliderType.PinkFish,ColliderType.Eel],
        ColliderType.Player: [ColliderType.Collectible,ColliderType.Barrier]
    ]
    
    
    //MARK: Properties
    
    let rawValue: UInt32
    
    static var Player: ColliderType { return self.init(rawValue: 0 << 0)}
    static var Barrier: ColliderType { return self.init(rawValue: 1 << 0)}
    static var Obstacle: ColliderType { return self.init(rawValue: 1 << 1)}
    static var OrangeFish: ColliderType { return self.init(rawValue: 1 << 2)}
    static var PinkFish: ColliderType { return self.init(rawValue: 1 << 3)}
    static var BlowFish: ColliderType { return self.init(rawValue: 1 << 4)}
    static var BlueFish: ColliderType { return self.init(rawValue: 1 << 5)}
    static var Eel: ColliderType { return self.init(rawValue: 1 << 6)}
    static var RedFish: ColliderType { return self.init(rawValue: 1 << 7)}
    static var Collectible: ColliderType { return self.init(rawValue: 1 << 8)}

    //MARK: Hashable
    
    var hashValue: Int{
        return Int(self.rawValue)
    }
    
    //MARK: SpriteKit Physics Convenience
    
    //A value that can be assigned to an SKPhysicsBody's category mask property
    
    var categoryMask: UInt32{
        return rawValue
    }
    
    //A value that can be assigned to an SKPhysicsBody's collision mask property
    
    var collisionMask: UInt32{
        let mask = ColliderType.definedCollisions[self]?.reduce(ColliderType()){
            
            initial, colliderType in
            
            return initial.union(colliderType)
        }
        
        return mask?.rawValue ?? 0
    }
    
    //A value that can be assigned to an SKPhysicsBody's contact mask property
    
    var contactMask: UInt32{
        let mask = ColliderType.requestedContactNotifications[self]?.reduce(ColliderType()){
            
            initial, colliderType in
            
            return initial.union(colliderType)
            
        }
        
        return mask?.rawValue ?? 0
    }
    
}


