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
            
   
            
          
            
            
        }
        
        let gridPos = vector_int2(x: Int32(5), y: Int32(1))
        let boardPos = getBoardPositionForGridPosition(gridPosition: gridPos)
        
        let rect = CGRect(x: boardPos.x-boardTileMap.tileSize.width/2.00, y: boardPos.y+boardTileMap.tileSize.height/2.00, width: boardTileMap.tileSize.width, height: boardTileMap.tileSize.height)
        let square = SKShapeNode(rect: rect)
        square.strokeColor = UIColor.blue
        square.fillColor = UIColor.orange
        
        square.move(toParent: worldNode)
        
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

