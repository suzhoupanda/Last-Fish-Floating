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

protocol FishAgentDelegate{
    
    func fishAgentWillUpdatePosition(_ agent: GKAgent2D,to agentPosition: CGPoint)
    
    func fishAgentWillUpdateOrientation(_ agent: GKAgent2D, to agentOrientation: FishOrientation)
    
    func fishAgentDidUpdatePosition(_ agent: GKAgent2D, to agentPosition: CGPoint)
    
    func fishAgentDidUpdateOrientation(_ agent: GKAgent2D, to agentOrientation: FishOrientation)
    
}

class FishAgent: GKAgent2D, GKAgentDelegate{
    
     var fishAgentDelegate: FishAgentDelegate?


    init(radius: Float, position: CGPoint, zRotation: CGFloat, maxSpeed: Float = 100, maxAcceleration: Float = 50) {
        
        super.init()

        self.radius = radius
        self.rotation = Float(zRotation)
        self.position = vector_float2(x: Float(position.x), y: Float(position.y))
        
        self.delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    func configureAgent(withMaxSpeed speed: Float, andWithMaxAccelerationOf acceleration: Float, withRadius radius: Float){
        
        self.maxSpeed = speed
        self.maxAcceleration = acceleration
        self.radius = radius
        
    }
    
    //MARK:     **** GKAgentDelegate Methods
    
    func agentWillUpdate(_ agent: GKAgent) {
    
        let agent = agent as! GKAgent2D

        let agentPosition = agent.position.getCGPoint()

        fishAgentDelegate?.fishAgentWillUpdatePosition(self, to: agentPosition)
        
        
        let xVelocity = agent.velocity.x
        
        let newOrientation: FishOrientation = xVelocity < 0.00 ? .Left : .Right
        
        fishAgentDelegate?.fishAgentWillUpdateOrientation(self, to: newOrientation)
        
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        
        let agent = agent as! GKAgent2D
        
        let agentPosition = agent.position.getCGPoint()
        
        fishAgentDelegate?.fishAgentDidUpdatePosition(self, to: agentPosition)
        
        
        let xVelocity = agent.velocity.x
        
        let newOrientation: FishOrientation = (xVelocity < 0.00) ? .Left : .Right
        
        fishAgentDelegate?.fishAgentDidUpdateOrientation(self, to: newOrientation)
        
        
        
    }
    
}

