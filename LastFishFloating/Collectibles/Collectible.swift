//
//  Collectible.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/25/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Collectible: NSObject, NSCoding{
    
    private var collectibleType: CollectibleType!
    private var totalQuantity: Int = 1
    private var canBeActivated: Bool = false
    private var isActive: Bool = false
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.canBeActivated, forKey: "canBeActivated")
        aCoder.encode(self.isActive, forKey: "isActive")
        aCoder.encode(Int64(self.totalQuantity), forKey: "totalQuantity")
        aCoder.encode(Int64(self.collectibleType.rawValue), forKey: "collectibleType")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.canBeActivated = aDecoder.decodeBool(forKey: "canBeActivated")
        self.isActive = aDecoder.decodeBool(forKey: "isActive")
        self.totalQuantity = Int(aDecoder.decodeInt64(forKey: "totalQuantity"))
        self.collectibleType = CollectibleType(rawValue: Int(aDecoder.decodeInt64(forKey: "collectibleType")))!
        
    }
    
    init(withCollectibleType someCollectibleType: CollectibleType){
        
        self.collectibleType = someCollectibleType
        self.canBeActivated = someCollectibleType.getCanBeActivatedStatus()
        self.totalQuantity = 1
        
        super.init()
        
        registerNotifications()
        
    }
    
    
    public func registerNotifications(){
      //  NotificationCenter.default.addObserver(self, selector: #selector(activateCollectible(notification:)), name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil)
    }
    
    @objc public func activateCollectible(notification: Notification?){
        
        if let userInfo = notification?.userInfo, let rawValue = userInfo["collectibleRawValue"] as? Int{
            
            if rawValue != self.getCollectibleType().rawValue{
                return
            } else {
                
                
            }
            
            if let activeStatus = userInfo["isActive"] as? Bool{
                
                isActive = activeStatus
                
            }
            
        }
        
    }
    
    
    func setActivatedStatus(to activatedStatus: Bool){
        self.isActive = activatedStatus
    }
    
    
    func setCanBeActivatedStatus(to canBeActivatedStatus: Bool){
        self.canBeActivated = canBeActivatedStatus
    }
    
    public func getCanBeActivatedStatus() -> Bool{
        return self.canBeActivated
    }
    
    public func getActiveStatus() -> Bool{
        return self.isActive
    }
    
    public func getCollectibleName() -> String{
        return collectibleType.getCollectibleName()
    }
    
    public func getCollectibleMetalContent() -> Double{
        return collectibleType.getPercentMetalContentPerUnit()*getCollectibleMass()
    }
    
    public func getCollectibleType() -> CollectibleType{
        return self.collectibleType
    }
    
    public func getCollectibleMonetaryValue() -> Double{
        return self.collectibleType.getMonetaryUnitValue()*Double(self.totalQuantity)
    }
    
    public func getCollectibleUnitValue() -> Double{
        return self.collectibleType.getMonetaryUnitValue()
    }
    
    public func getCollectibleMass() -> Double{
        return self.collectibleType.getUnitMass()*Double(self.totalQuantity)
    }
    
    public func getQuantityOfCollectible() -> Int{
        return self.totalQuantity
    }
    
    public func changeQuantityTo(newQuantity: Int){
        self.totalQuantity = newQuantity
    }
    
    public func getCollectibleTexture() -> SKTexture{
        
        return collectibleType.getTexture()
        
    }
    
    public func getPercentMetalContentByUnit() -> Double{
        
        return collectibleType.getPercentMetalContentPerUnit()
    }
    
    
    
    static func == (lhs: Collectible, rhs: Collectible) -> Bool{
        
        return lhs.collectibleType.rawValue == rhs.collectibleType.rawValue
        
    }
    /** Each collectible item is unique;  override hashValue so that the collectible can be inserted into a set such that only one collectible of a given collectible type can be present in the collectible manager at a given time **/
    
    override var hashValue: Int{
        
        return self.collectibleType.rawValue
    }
    
    public func getDescriptionString() -> String{
        
        return "Collectible Information - Name: \(self.getCollectibleName()), Current Quantity: \(getQuantityOfCollectible()), Total Metal Content: \(getCollectibleMetalContent()), Total Mass: \(getCollectibleMass()), Total Monetary Value: \(getCollectibleMonetaryValue())"
    }
    
    public func showDescription(){
        
        print(getDescriptionString())
        
    }
    
    
    
    
}
