//
//  FIsh.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Fish: AgentNode{
    
    
    var isDead: Bool = false
    
    var colliderType: ColliderType{
        return self.fishType.getColliderType()
    }
    
    convenience init(baseScene: BaseScene, fishType: FishType, position: CGPoint, radius: Float) {
        
        
        let defaultTexture = fishType.getTexture(forOrientation: .Right, andForOutlineState: .Unoutlined, isDead: false)
        
        self.init(withScene: baseScene, texture: defaultTexture, radius: radius, position: position)
        
        self.fishType = fishType
        configurePhysicsProperties(withTexture: defaultTexture)

        
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
    
 
    
}
