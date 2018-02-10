//
//  Player.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Player: Fish{
    
    override init(baseScene: BaseScene, fishType: FishType, position: CGPoint, zRotation: CGFloat, radius: Float) {
        
        super.init(baseScene: baseScene, fishType: fishType, position: position, zRotation: zRotation, radius: radius)
        
    }

    override func configurePhysicsProperties(withTexture texture: SKTexture) {
        
        self.node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        self.node.physicsBody?.affectedByGravity = false
        self.node.physicsBody?.allowsRotation = false
        self.node.physicsBody?.categoryBitMask = self.colliderType.categoryMask | ColliderType.Player.categoryMask
        self.node.physicsBody?.collisionBitMask = self.colliderType.collisionMask | ColliderType.Player.collisionMask
        self.node.physicsBody?.contactTestBitMask = self.colliderType.contactMask | ColliderType.Player.contactMask
    }
    
    
}
