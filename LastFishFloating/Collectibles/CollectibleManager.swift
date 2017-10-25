//
//  CollectibleManager.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/25/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SpriteKit

class CollectibleManager: NSObject, NSCoding{
    
    var collectibles = Set<Collectible>()
    var carryingCapacity: Double = 3000.00
    
    var enumeratedCollectibles: EnumeratedSequence<Set<Collectible>> {
        return collectibles.enumerated()
    }
    
    var collectibleIterator: SetIterator<Collectible>{
        return collectibles.makeIterator()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.collectibles, forKey: "collectibles")
        aCoder.encode(self.carryingCapacity, forKey: "carryingCapacity")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.carryingCapacity = aDecoder.decodeDouble(forKey: "carryingCapacity")
        self.collectibles = aDecoder.decodeObject(forKey: "collectibles") as! Set<Collectible>
    }
    
    
    
    override init(){
        super.init()
    }
    
    
    func addCollectibleItem(newCollectible: Collectible, andWithQuantityOf quantity: Int = 1){
        
        
        if(self.getTotalMassOfAllCollectibles() + newCollectible.getCollectibleMass() > self.carryingCapacity){
            
            print("Failed to add item: player does not have the carrying capacity to add this item")
            return;
        }
        
        
        if let existingCollectible = collectibles.remove(newCollectible){
            
            let originalQty = existingCollectible.getQuantityOfCollectible()
            
            existingCollectible.changeQuantityTo(newQuantity: originalQty + quantity)
            
            collectibles.insert(existingCollectible)
            
        } else {
            collectibles.insert(newCollectible)
        }
        
        
        
        
    }
    
    
    
    
    func hasItem(collectibleType: CollectibleType) -> Bool{
        
        let collectible = Collectible(withCollectibleType: collectibleType)
        
        return self.collectibles.contains(collectible)
        
    }
    
    func hasItem(collectible: Collectible) -> Bool{
        
        return self.collectibles.contains(collectible)
        
    }
    
    
    func getCollectiblesArray() -> [Collectible]{
        
        return self.collectibles.map({$0})
    }
    
    
    
    func getActiveStatusFor(collectibleType: CollectibleType) -> Bool{
        
        if let collectible = getCollectible(ofType: collectibleType){
            
            return collectible.getActiveStatus()
        }
        
        return false
    }
    
    func getCollectible(ofType collectibleType: CollectibleType) -> Collectible?{
        
        return getCollectiblesArray().first(where: { $0.getCollectibleType() == collectibleType })
        
    }
    
    func getCollectibleAtIndex(index: Int) -> Collectible?{
        
        for (idx,collectible) in enumeratedCollectibles{
            if(index == idx){
                return collectible
            }
        }
        
        return nil
    }
    
    func getMostValueableCollectibleBasedOnTotalValue() -> Collectible?{
        
        return collectibles.max(by: {
            
            c1,c2 in
            
            return c1.getCollectibleMonetaryValue() < c2.getCollectibleMonetaryValue()
            
        })
    }
    
    func getLeastValuableCollectibleBasedOnTotalValue() -> Collectible?{
        
        return collectibles.min(by: { c1,c2 in
            
            return c1.getCollectibleMonetaryValue() < c2.getCollectibleMonetaryValue()
            
        })
    }
    
    
    func getLeastValuableCollectibleBasedOnUnitValue() -> Collectible?{
        
        return collectibles.min(by: { c1,c2 in
            
            return c1.getCollectibleUnitValue() < c2.getCollectibleUnitValue()
            
        })
    }
    
    func getMostValueableCollectibleBasedOnUnitValue() -> Collectible?{
        
        return collectibles.max(by: {
            
            c1,c2 in
            
            return c1.getCollectibleUnitValue() < c2.getCollectibleUnitValue()
            
        })
    }
    
    func getTotalMonetaryValueOfAllCollectibles() -> Double{
        
        if collectibles.isEmpty{
            return 0.00
        }
        
        return self.collectibles.map({ return $0.getCollectibleMonetaryValue() }).reduce(0.00){ $0 + $1 }
        
    }
    
    func getTotalMassOfAllCollectibles() -> Double {
        
        if collectibles.isEmpty{
            return 0.00
        }
        
        return self.collectibles.map({  return $0.getCollectibleMass() }).reduce(0.00){$0+$1}
        
    }
    
    func getTotalMetalContent() -> Double{
        
        if collectibles.isEmpty{
            return 0.00
        }
        
        return self.collectibles.map({ return $0.getCollectibleMetalContent() }).reduce(0.00){$0+$1}
    }
    
    func getTotalNumberOfUniqueItems() -> Int{
        return collectibles.count
    }
    
    func getTotalNumberOfAllItems() -> Int{
        
        let collectibleItemQuantities = collectibles.map({$0.getQuantityOfCollectible()})
        
        return collectibleItemQuantities.reduce(0){$0 + $1}
        
    }
    
    func getTotalCarryingCapacity() -> Double{
        
        return self.carryingCapacity
    }
    
    
    func hasExceededCarryingCapacity() -> Bool{
        
        return getTotalMassOfAllCollectibles() > self.carryingCapacity
    }
    
    
    func showDescriptionForCollectibleManager(){
        
        let descriptionStrings: [String] = [
            String("Total Number of All Items: \(getTotalNumberOfAllItems())"),
            String("Total Number of Unique items: \(getTotalNumberOfUniqueItems())"),
            String("Total Metal Content: \(getTotalMetalContent())"),
            String("Total Mass: \(getTotalMassOfAllCollectibles())"),
            String("Total Monetary Value: \(getTotalMonetaryValueOfAllCollectibles())")
        ]
        
        let summaryString = descriptionStrings.reduce(""){$0 + "\n" + $1}
        
        print(summaryString)
        
    }
    
    func getDescriptionStringForCollectibleSpecs() -> String{
        
        return self.collectibles.map({$0.getDescriptionString()}).reduce(String("Information Summary for All Collectibles:")){$0 + "\n" + $1}
        
        
    }
    
    
    func removeCollectible(ofType collectibleType: CollectibleType){
        
        
        if let collectible = getCollectible(ofType: collectibleType){
            
            removeCollectible(collectible: collectible)
            
        }
        
    }
    
    
    func removeCollectible(collectible: Collectible){
        
        self.collectibles.remove(collectible)
        
    }
    
    
    func increaseCarryingCapacity(by increaseAmount: Double){
        
        self.carryingCapacity += increaseAmount
    }
}

