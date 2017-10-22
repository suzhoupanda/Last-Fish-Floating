//
//  SKNode+Extension.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension SKNode{
    
    func getPathConfiguration() ->PathConfiguration?{
        
        
        if ((name == nil) || ((name != nil) && (name! != "path"))){
            
            let points = children.filter({$0.name == "point"})
            
            var pathConfigurations = [PathConfiguration]()
            
            var pointsGroup = [(float2, Int)]()
            
            points.forEach({
                
                if let order = $0.userData?["order"] as? Int{
                    
                    let floatPosition: float2 = float2(Float($0.position.x), Float($0.position.y))
                    
                    let pointGroupElement = (floatPosition, order)
                    
                    pointsGroup.append(pointGroupElement)
                    
                }
                
            })
            
            
            pointsGroup.sort(by: {$0.1 < $1.1})
            
            let floatPoints = pointsGroup.map({$0.0})
            
            if let radius = userData?["radius"] as? Float, let isCyclical = userData?["isCyclical"] as? Bool{
                return PathConfiguration(points: floatPoints, radius: radius, isCyclical: isCyclical)
                
            }  else {
                return PathConfiguration(points: [], radius: 50.0, isCyclical: true)
                
            }
            
            
        } else {
            
            return nil
            
        }
    }
}
