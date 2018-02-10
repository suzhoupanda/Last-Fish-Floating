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

class Fish: FishAgentDelegate{
  
    
  
    
    var isDead: Bool = false
    
    var fishType: FishType = .BlueFish

    var colliderType: ColliderType{
        return self.fishType.getColliderType()
    }
    
    
    var node: SKSpriteNode!
    var agent: FishAgent!
    
   
    var previousOrientation: FishOrientation?
    var currentOrientation: FishOrientation?{
        
        didSet{
            
            if let previousOrientation = oldValue, let currentOrientation = self.currentOrientation, previousOrientation != currentOrientation{
                
                let newTexture = self.fishType.getTexture(forOrientation: currentOrientation, andForOutlineState: .Unoutlined, isDead: false)
                
                self.node.run(SKAction.setTexture(newTexture))
                
            }
            
        }
    }
    
    init(baseScene: BaseScene,fishType: FishType, position: CGPoint, zRotation: CGFloat, radius: Float) {
        
        
        let defaultTexture = fishType.getTexture(forOrientation: .Right, andForOutlineState: .Unoutlined, isDead: false)
        
        self.node = SKSpriteNode(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        self.node.position = position

        baseScene.worldNode.addChild(self.node)
        
        self.fishType = fishType
        
        self.agent = FishAgent(radius: radius, position: position, zRotation: zRotation)
        self.agent.fishAgentDelegate = self
        
        configurePhysicsProperties(withTexture: defaultTexture)

        
    }
    
    
    
   
    
    func configureAgent(withMaxSpeed maxSpeed: Float, andWithMaxAccelerationOf maxAcceleration: Float){
        self.agent.configureAgent(withMaxSpeed: maxSpeed, andWithMaxAccelerationOf: maxAcceleration, withRadius: 100.0)
        
    }


    
     func configurePhysicsProperties(withTexture texture: SKTexture){
        
        self.node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        self.node.physicsBody?.affectedByGravity = false
        self.node.physicsBody?.allowsRotation = false
        self.node.physicsBody?.categoryBitMask = self.colliderType.categoryMask
        self.node.physicsBody?.collisionBitMask = self.colliderType.collisionMask
        self.node.physicsBody?.contactTestBitMask = self.colliderType.contactMask
    }
    
    /** Fish Agent Delegate Methods **/
    
    internal func fishAgentWillUpdatePosition(_ agent: GKAgent2D, to agentPosition: CGPoint) {
        print("Agent will upate position to x: \(self.node.position.x), y: \(self.node.position.y)")

    }
    
    internal func fishAgentWillUpdateOrientation(_ agent: GKAgent2D, to agentOrientation: FishOrientation) {
        print("Agent will upate orientation to: \(agentOrientation.rawValue)")

    }
    
    internal func fishAgentDidUpdatePosition(_ agent: GKAgent2D, to agentPosition: CGPoint) {
        print("Agent did upate position to x: \(self.node.position.x), y: \(self.node.position.y)")
        
        self.node.position = agentPosition
    }
    
    internal func fishAgentDidUpdateOrientation(_ agent: GKAgent2D, to agentOrientation: FishOrientation) {
        print("Agent did upate orientation to: \(agentOrientation.rawValue)")
        
        self.currentOrientation = agentOrientation
        
    }
   
    
    
    

 
}
