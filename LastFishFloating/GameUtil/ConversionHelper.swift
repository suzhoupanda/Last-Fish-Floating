//
//  ConversionHelper.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

extension vector_float2{
    
    func getCGPoint() -> CGPoint{
        
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    
    func getDistanceTo(point: vector_float2) -> Float{
        
        let dx = self.x - point.x
        let dy = self.y - point.y
        let dxSquared = powf(dx, 2.0)
        let dySquared = powf(dy, 2.0)
        
        return sqrtf(dxSquared + dySquared)
        
    }
}

extension CGPoint{
    
    func getVectorFloat2() -> vector_float2{
        
        return vector_float2(x: Float(self.x), y: Float(self.y))
    }
}
