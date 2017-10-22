//
//  BaseScene.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit


class BaseScene: SKScene{
    
    let agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    let trackingAgent = GKAgent2D()
    var player: Player!

    
    /** The StopGoal and SeekGoal are fundamental to every scene, since they handle the mechanics of player movement, and are therefore defined as stored properties on the BaseScene**/
    
    lazy var stopGoal: GKGoal = {
        
        let goal = GKGoal(toReachTargetSpeed: 0.00)
        
        return goal
    }()
    
    lazy var seekGoal: GKGoal = {
        
        let goal =  GKGoal(toSeekAgent: self.trackingAgent)
        
        return goal
        
    }()
    
    lazy var seekingSpeedGoal: GKGoal = {
        
        let goal = GKGoal(toReachTargetSpeed: 500.0)
        
        return goal
        
    }()
    
    var _seeking: Bool = false
    
    var seeking: Bool{
        
        set(isSeeking){
            
            _seeking = isSeeking
            
            if(isSeeking){
                self.player.agent.behavior?.setWeight(0.00, for: self.stopGoal)
                self.player.agent.behavior?.setWeight(1.00, for: self.seekGoal)
                self.player.agent.behavior?.setWeight(1.00, for: self.seekingSpeedGoal)
            } else {
                self.player.agent.behavior?.setWeight(1.00, for: self.stopGoal)
                self.player.agent.behavior?.setWeight(0.00, for: self.seekGoal)
                self.player.agent.behavior?.setWeight(0.00, for: self.seekingSpeedGoal)

            }
        }
        
        get{
            return _seeking
        }
    }
    
    
   
    
    var lastUpdateTime = 0.00
    
    
    let backgroundNode: SKNode!
    let worldNode: SKNode!
    let overlayNode: SKNode!
    let graphNode: SKNode!
    
    
    
    override init(size: CGSize) {
        
        overlayNode = SKNode()
        worldNode = SKNode()
        backgroundNode = SKNode()
        graphNode = SKNode()
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        addChild(overlayNode)
        addChild(worldNode)
        addChild(backgroundNode)
        addChild(graphNode)
        
        self.player = Player(baseScene: self, fishType: .BlueFish, position: CGPoint.zero, radius: 50.0)
        
        self.player.agent.behavior = GKBehavior(goals: [self.seekGoal,self.stopGoal,self.seekingSpeedGoal])
        
        self.player.configureAgent(withMaxSpeed: 150, andWithMaxAccelerationOf: 100)
        
        self.agentSystem.addComponent(self.player.agent)
        
        
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _seeking = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        _seeking = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _seeking = true
        
        let touch = touches.first! as UITouch
        let touchPosition = touch.location(in: worldNode)
        
        self.trackingAgent.position = vector_float2(x: Float(touchPosition.x), y: Float(touchPosition.y))
        
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime
        }
        
        let delta = currentTime - lastUpdateTime
        
        self.agentSystem.update(deltaTime: delta)
        
        lastUpdateTime = currentTime
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        
    }
    
}

