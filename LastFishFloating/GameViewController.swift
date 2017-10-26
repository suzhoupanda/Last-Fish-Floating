//
//  GameViewController.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
            
        
        
                // Present the scene
                if let view = self.view as! SKView? {
                    
                    let scene = SceneLoader.LoadScene(ofType: .PlayersHuntsFleeingFish)
                    let boardBaseScene = BoardBaseScene(size: CGSize(width: GameConstants.ScreenWidth, height: GameConstants.ScreenHeight))
                    
                    let dfSceneA = DFSceneA(size: GameConstants.ScreenSize)
                    
                    view.presentScene(dfSceneA)
                    
                   
                }
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
