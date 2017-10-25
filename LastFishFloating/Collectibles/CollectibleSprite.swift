//
//  CollectibleSprite.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/25/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

struct CollectibleSpriteConfiguration{
    var collectibleTypeRawValue: Int64
    var isRequired: Bool
    var position: CGPoint
}

class CollectibleSprite: SKSpriteNode{
    
    var collectibleType: CollectibleType!
    var isRequired: Bool = false
    
    func getCollectibleSpriteConfiguration() -> CollectibleSpriteConfiguration{
        
        return CollectibleSpriteConfiguration(collectibleTypeRawValue: Int64(self.collectibleType.rawValue), isRequired: self.isRequired, position: self.position)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        let collectibleTypeRawValue = aDecoder.decodeInteger(forKey: "collectibleTypeRawValue")
        self.collectibleType = CollectibleType(rawValue: collectibleTypeRawValue)!
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.collectibleType.rawValue, forKey: "collectibleTypeRawValue")
        super.encode(with: aCoder)
    }
    
    convenience init(collectibleType: CollectibleType,scale: CGFloat = 1.00) {
        
        let texture = collectibleType.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.collectibleType = collectibleType
        
        initializePhysicsProperties(withTexture: texture)
        
        self.xScale *= scale
        self.yScale *= scale
        
    }
    
    public func initializePhysicsProperties(withTexture texture: SKTexture){
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Collectible.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.Collectible.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.Collectible.contactMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        
    }
    
    
    public func getCollectible() -> Collectible{
        
        return Collectible(withCollectibleType: self.collectibleType)
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
    }
    
    
    
    
}
