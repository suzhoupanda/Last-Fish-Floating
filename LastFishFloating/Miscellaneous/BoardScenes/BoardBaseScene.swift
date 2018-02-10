//
//  BoardBaseScene.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/25/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class BoardBaseScene: SKScene{
    
    
    var player: Player!
    


    var lastUpdateTime = 0.00
    
    
    let backgroundNode: SKNode!
    let worldNode: SKNode!
    let overlayNode: SKNode!
    let graphNode: SKNode!
    
    var boardTileMap: SKTileMapNode!
    var gridGraph: GKGridGraph<GKGridGraphNode>!
    
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
    
    /** The filename for the SKS file providing the background graphics, obstacle, path, and other information for the scene **/
    
    var sceneName: String{
        return "boardBackground1"
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
        
        
      
       
        if let scene = SKScene(fileNamed: self.sceneName){
            
            
            if let background = scene.childNode(withName: "Root"){
                
                background.move(toParent: backgroundNode)
                
                
                
            }
            
            if let pathNode = scene.childNode(withName: "PathNode"){
                
                /**
                self.pathNode = pathNode
                
                let fish1 = Fish(baseScene: self, fishType: .OrangeFish, position: CGPoint(x: 100, y: 100), radius: 40.0)
                fish1.configureAgent(withMaxSpeed: 20, andWithMaxAccelerationOf: 40)
                
                let fish2 = Fish(baseScene: self, fishType: .OrangeFish, position: CGPoint(x: 300, y: 40), radius: 40.0)
                fish2.configureAgent(withMaxSpeed: 20, andWithMaxAccelerationOf: 40)
                
                let fish3 = Fish(baseScene: self, fishType: .OrangeFish, position: CGPoint(x: -50, y: -100), radius: 40.0)
                fish3.configureAgent(withMaxSpeed: 20, andWithMaxAccelerationOf: 40)
                
                
                self.fishManager = FishManager(baseScene: self)
                
                self.fishManager.addPathFollowingFishGroup(fishGroup: [fish1,fish2,fish3], avoidsObstacles: false)
                **/
            }
            
            
            
            //let gridGraph = GKGridGraph<GKGridGraphNode>()
        
            var graphNodes = [GKGridGraphNode]()
            
            if let boardTileMap = scene.childNode(withName: "GameBoard") as? SKTileMapNode{
                
                self.boardTileMap = boardTileMap
                self.boardTileMap.move(toParent: worldNode)
                
                for col in 0...boardTileMap.numberOfColumns{
                    for row in 0...boardTileMap.numberOfRows{
                    
        
                        if boardTileMap.tileDefinition(atColumn: col, row: row) != nil{
                            
                            
                            let gridPosition = vector_int2(Int32(col), Int32(row))
                            
                            let graphNode = GKGridGraphNode(gridPosition: gridPosition)
                    
                            graphNodes.append(graphNode)
                           // gridGraph.connectToAdjacentNodes(node: graphNode)
                            
                            
                        }
                        
                    }
                }
                
                self.gridGraph = GKGridGraph(nodes: graphNodes)
                
            }
            
   
            
          
            let camera = SKCameraNode()
            self.camera = camera
            self.camera!.move(toParent: worldNode)
            
        }
        
        let gridPos = vector_int2(x: Int32(5), y: Int32(1))
        let boardPos = getBoardPositionForGridPosition(gridPosition: gridPos)
        
        let rect = CGRect(x: boardPos.x-boardTileMap.tileSize.width/2.00, y: boardPos.y+boardTileMap.tileSize.height/2.00, width: boardTileMap.tileSize.width, height: boardTileMap.tileSize.height)
        let square = SKShapeNode(rect: rect)
        square.strokeColor = UIColor.blue
        square.fillColor = UIColor.orange
        
        let fadeOut = SKAction.fadeAlpha(to: 0.20, duration: 0.40)
        let fadeIn = SKAction.fadeAlpha(to: 0.80, duration: 0.40)
        let fadeAction = SKAction.sequence([fadeOut,fadeIn])
        let fadeAnimation = SKAction.repeatForever(fadeAction)
        
        square.move(toParent: worldNode)
        square.run(fadeAnimation, withKey: "fadeAnimation")

        
        let backgroundSound = SKAudioNode(fileNamed: "Polka Train.mp3")
        self.addChild(backgroundSound)
        
        
        
    }
    
    
    
    func getGridPositionForBoardPosition(boardPosition: CGPoint) -> vector_int2{
        
        let tileWidth = boardTileMap.tileSize.width
        let tileHeight = boardTileMap.tileSize.height
        
        let gridCol = Int((boardPosition.x).truncatingRemainder(dividingBy: tileWidth))
        let gridRow = Int((boardPosition.y).truncatingRemainder(dividingBy: tileHeight))
        
        return vector_int2(x: Int32(gridCol), y: Int32(gridRow))
        
    }
    
    func getBoardPositionForGridPosition(gridPosition: vector_int2)-> CGPoint{
        
        let col  = Int(gridPosition.x)
        let row = Int(gridPosition.y)
        
        let centerPoint = self.boardTileMap.centerOfTile(atColumn: col, row: row)
         
        return centerPoint
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        let touch = touches.first!
        let touchPos = touch.location(in: self.worldNode)
        
        if self.camera != nil{
            
            let isInBoundsX = touchPos.x < 400 && touchPos.x > -400
            let isInBoundsY = touchPos.y < 900 && touchPos.y > -600
            
            if(isInBoundsX && isInBoundsY){
                self.camera!.run(SKAction.move(to: touchPos, duration: 0.50))
            }
        }
        
        let gridPos = getGridPositionForBoardPosition(boardPosition: touchPos)
        print("The corresponding grid position is: (x:\(gridPos.x), y:\(gridPos.y))")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime
        }
        
        let delta = currentTime - lastUpdateTime
        
        
        lastUpdateTime = currentTime
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
      
    
    }
    
    

    
}

