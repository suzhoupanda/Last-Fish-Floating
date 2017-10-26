//
//  AgentNode.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

class AgentNode: SKSpriteNode, GKAgentDelegate{
    
    var agent: GKAgent2D!
    
    var baseScene: BaseScene!
    
    var isActiveAgent: Bool = false
    
    var fishType: FishType = .BlueFish

    var previousOrientation: FishOrientation?
    
    var orientation: FishOrientation?{
        
        didSet{
            
            if let previousOrientation = oldValue, let currentOrientation = orientation, previousOrientation != currentOrientation{
                
                let newTexture = self.fishType.getTexture(forOrientation: currentOrientation, andForOutlineState: .Unoutlined, isDead: false)
                
                run(SKAction.setTexture(newTexture))
                
            }
            
        }
    }
    
    init(withScene scene: BaseScene,texture: SKTexture, radius: Float, position: CGPoint) {
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.baseScene = scene
        self.position = position
        self.zPosition = 10
        scene.worldNode.addChild(self)
        
        agent = GKAgent2D()
        agent.radius = radius
        agent.rotation = Float(zRotation)
        agent.position = vector_float2(x: Float(position.x), y: Float(position.y))
        agent.delegate = self
        agent.maxSpeed = 100
        agent.maxAcceleration = 50
    }
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureAgent(withMaxSpeed speed: Float, andWithMaxAccelerationOf acceleration: Float){
        
        self.agent.maxSpeed = speed
        self.agent.maxAcceleration = acceleration
        
    }
    
    //MARK:     ****GKAgentDelegate Methods
    
    func agentWillUpdate(_ agent: GKAgent) {
        
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        
        let agent = agent as! GKAgent2D
        
        if(!isActiveAgent){
            
            let agentPosition = agent.position.getCGPoint()
            self.position = agentPosition
            
            let agentVelocity = agent.velocity.x
            self.orientation = agentVelocity < 0.00 ? .Left : .Right
            
            
        } else {
            
            self.agent.position = self.position.getVectorFloat2()
            
        }
        
        
    }
    
}

