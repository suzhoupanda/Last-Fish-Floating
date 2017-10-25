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
            
            if let background = scene.childNode(withName: "GameBoard"){
                
                background.move(toParent: backgroundNode)
                
                //TODO: add the obstalce graph to the graph node based on the tile map node
                
            }
            
   
            
          
            
            
        }
        
        let backgroundSound = SKAudioNode(fileNamed: "Polka Train.mp3")
        self.addChild(backgroundSound)
        
  
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
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

