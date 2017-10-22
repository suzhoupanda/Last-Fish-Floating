//
//  SceneLoader.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class SceneLoader{
    
    static func LoadScene(ofType sceneType: SceneType) -> BaseScene{
        
        switch sceneType {
        case .BigFishHuntPlayer:
            return BFHScene(size: GameConstants.ScreenSize)
        case .PlayersHuntsFleeingFish:
            return PHSScene(size: GameConstants.ScreenSize)
        case .PlayersHuntsWanderingFish:
            break
        default:
            return BaseScene(size: GameConstants.ScreenSize)
        }
        
        return BaseScene(size: GameConstants.ScreenSize)

    }
}
