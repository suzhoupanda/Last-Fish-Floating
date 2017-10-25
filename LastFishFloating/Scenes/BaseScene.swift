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

    /** Some background files may contain placeholder nodes for paths followed by specific fish or for obstacles avoided by specific fish **/
    
    
    var obstacleFish: [Fish]?
    
    var obstaclesAgents: [GKAgent2D]?{
        
        guard let obstacleFish = self.obstacleFish else { return nil }
        
            return obstacleFish.map({$0.agent})
    }
    
    var obstacles: [GKPolygonObstacle]?{
        didSet{
            if(obstacles != nil){
                
            }
        }
    }
    
    
    
    var flockFish: [Fish]?{
        
        guard let flockNode = self.flockNode else { return nil }
        
        return flockNode.children.map({
            
            placeholder in
            
            let pos = placeholder.position
            
            var fishType: FishType = .RedFish
            var radius: Float = 5.00
            
            if let fishTypeRawValue = placeholder.userData?["fishType"] as? Int{
                
                fishType =  FishType(rawValue: fishTypeRawValue)!
            }
            
            if let agentRadius = placeholder.userData?["radius"] as? Float{
                
                radius = agentRadius
                
            }
            
            return Fish(baseScene: self, fishType: fishType, position: pos, radius: radius)
            
        })
    }
    
    var flockNode: SKNode?
    
    
    var obstacleNode: SKNode?{
        didSet{
            if(obstacleNode != nil){
                
                
                var obstacleFish: [Fish] = [Fish]()
                
                obstacleNode!.children.forEach({
                    
                    node in
                    
                    if(node.name == "blowfish"){
                        
                        let pos = node.position
                        
                        let blowFish = Fish(baseScene: self, fishType: .BlowFish, position: pos, radius: 5.00)
                        
                        obstacleFish.append(blowFish)
                        agentSystem.addComponent(blowFish.agent)
                        blowFish.move(toParent: worldNode)
                    }
                })
                
                self.obstacleFish = obstacleFish

            }
        }
    }
    
    var pathNode: SKNode?{
        didSet{
            if(pathNode != nil){
                
                let paths: [GKPath] = pathNode!.children.map({
                    
                    let points: [float2] = $0.children.map({
                        
                        let x = Float($0.position.x)
                        let y = Float($0.position.y)
                        
                        return float2(x: x, y: y)

                    })
                    
                    return GKPath(points: points, radius: 5.00, cyclical: true)
                })
                
                self.paths = paths
            }
        }
    }

    var paths: [GKPath]?
    
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
    
    /** The filename for the SKS file providing the background graphics, obstacle, path, and other information for the scene **/
    
    var sceneName: String{
        return "background1"
    }
    
    var bgMusicFilename: String{
        return "Polka Train.mp3"
    }
    
    
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
        
    
        self.physicsWorld.contactDelegate = self
        
        if let scene = SKScene(fileNamed: self.sceneName){
            
            if let background = scene.childNode(withName: "Root"){
                
                background.move(toParent: backgroundNode)
                
              
                
            }
            
            if let obstacleNode = scene.childNode(withName: "Obstacles"){
                
                self.obstacleNode = obstacleNode
                
            }
            
            if let flockNode = scene.childNode(withName: "Flock"){
                
                
                self.flockNode = flockNode
        
            }
            
            if let pathNode = scene.childNode(withName: "PathNode"){
                
                
                self.pathNode = pathNode
                
            }
            
           
        }
        
        let backgroundSound = SKAudioNode(fileNamed: "Polka Train.mp3")
        self.addChild(backgroundSound)
        
        self.player = Player(baseScene: self, fishType: .BlueFish, position: CGPoint.zero, radius: 50.0)
        
        self.player.agent.behavior = GKBehavior(goals: [self.seekGoal,self.stopGoal,self.seekingSpeedGoal])
        
        self.player.configureAgent(withMaxSpeed: 150, andWithMaxAccelerationOf: 100)
        
        self.agentSystem.addComponent(self.player.agent)
        
        let cam = SKCameraNode()
        self.camera = cam
        worldNode.addChild(self.camera!)
    
        
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
        
        if self.camera != nil{
            camera!.position = player.position
        }
        
    }
    
}

extension BaseScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        
        
        
        switch (contactA.categoryBitMask,contactB.categoryBitMask) {
        case (let x, let y) where x == ColliderType.RedFish.categoryMask ||  y == ColliderType.RedFish.categoryMask:
            break
        case (let x, let y) where x == ColliderType.BlueFish.categoryMask || y == ColliderType.BlueFish.categoryMask:
            break
        case (let x, let y) where x == ColliderType.OrangeFish.categoryMask ||  y == ColliderType.OrangeFish.categoryMask:
            break
        case (let x, let y) where x == ColliderType.PinkFish.categoryMask ||  y == ColliderType.PinkFish.categoryMask:
            break
        case (let x, let y) where x == ColliderType.BlowFish.categoryMask ||  y == ColliderType.BlowFish.categoryMask:
            break
        case (let x, let y) where x == ColliderType.Eel.categoryMask ||  y == ColliderType.Eel.categoryMask:
            break
        case (let x, let y) where x == ColliderType.Barrier.categoryMask ||  y == ColliderType.Barrier.categoryMask:
            break
        case (let x, let y) where x == ColliderType.Player.categoryMask || y == ColliderType.Player.categoryMask:
            break
        default:
            break
        }
        
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
    func handlePlayerContacts(contact: SKPhysicsContact){
        
        
    }
    
    func handleRedFishContacts(contact: SKPhysicsContact){
        
        
    }
    
    func handleBlueFishContacts(contact: SKPhysicsContact){
        
        
    }
    
    func handleOrangeFishContacts(contact: SKPhysicsContact){
        
        
    }
    
    func handlePinkFishContacts(contact: SKPhysicsContact){
        
        
    }


    func handleEelContacts(contact: SKPhysicsContact){
        
        
    }
    
    func handleBlowFishContacts(contact: SKPhysicsContact){
        
        
    }
    
    func handleBarrierContacts(contact: SKPhysicsContact){
        
        
    }





    func handleCollectibleContacts(contact: SKPhysicsContact){
        
        
    }
}

