//
//  Rules.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/26/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//



/**
import GameplayKit

enum Fact: String {
    
    case preyPercentageLow = "PreyPercentageLow"
    case preyPercentageMedium = "PreyPercentageMedium"
    case preyPercentageHigh = "PreyPercentageHigh"
    
    case predatorPercentageLow = "PredatorPercentageLow"
    case predatorPercentageMedium = "PredatorPercentageMedium"
    case predatorPercentageHigh = "PredatorPercentageHigh"
    
    case playerFishNear = "PlayerFishNear"
    case playerFishMedium = "PlayerFishMedium"
    case playerFishFar = "PlayerFishFar"
}


class FuzzyDynamicFishRule: GKRule {
    // MARK: Properties
    
    var snapshot: FishSnapshot!
    
    func grade() -> Float { return 0.0 }
    
    let fact: Fact
    
    // MARK: Initializers
    
    init(fact: Fact) {
        self.fact = fact
        
        super.init()
        
        // Set the salience so that 'fuzzy' rules will evaluate first.
        salience = Int.max
    }
    
    // MARK: GPRule Overrides
    
    override func evaluatePredicate(in system: GKRuleSystem) -> Bool {
        snapshot = system.state["snapshot"] as! FishSnapshot
        
        if grade() >= 0.0 {
            return true
        }
        
        return false
    }
    
    override func performAction(in system: GKRuleSystem) {
        system.assertFact(fact.rawValue as NSObject, grade: grade())
    }
}

/// Asserts whether the number of "bad" `TaskBot`s is considered "low".
class PreyPercentageLow: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        return max(0.0, 1.0 - 3.0 * snapshot.badBotPercentage)
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .preyPercentageLow) }
}

/// Asserts whether the number of "bad" `TaskBot`s is considered "medium".
class PreyPercentageMedium: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        if snapshot.badBotPercentage <= 1.0 / 3.0 {
            return min(1.0, 3.0 * snapshot.badBotPercentage)
        }
        else {
            return max(0.0, 1.0 - (3.0 * snapshot.badBotPercentage - 1.0))
        }
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .preyPercentageMedium) }
}

/// Asserts whether the number of "bad" `TaskBot`s is considered "high".
class BadTaskBotPercentageHighRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        return min(1.0, max(0.0, (3.0 * snapshot.badBotPercentage - 1)))
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .badTaskBotPercentageHigh) }
}

/// Asserts whether the `PlayerBot` is considered to be "near" to this `TaskBot`.
class PlayerBotNearRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        guard let distance = snapshot.playerBotTarget?.distance else { return 0.0 }
        let oneThird = snapshot.proximityFactor / 3
        return (oneThird - distance) / oneThird
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .playerBotNear) }
}

/// Asserts whether the `PlayerBot` is considered to be at a "medium" distance from this `TaskBot`.
class PlayerBotMediumRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        guard let distance = snapshot.playerBotTarget?.distance else { return 0.0 }
        let oneThird = snapshot.proximityFactor / 3
        return 1 - (fabs(distance - oneThird) / oneThird)
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .playerBotMedium) }
}

/// Asserts whether the `PlayerBot` is considered to be "far" from this `TaskBot`.
class PlayerBotFarRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        guard let distance = snapshot.playerBotTarget?.distance else { return 0.0 }
        let oneThird = snapshot.proximityFactor / 3
        return (distance - oneThird) / oneThird
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .playerBotFar) }
}

// MARK: TaskBot Proximity Rules

/// Asserts whether the nearest "good" `TaskBot` is considered to be "near" to this `TaskBot`.
class GoodTaskBotNearRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        guard let distance = snapshot.nearestGoodTaskBotTarget?.distance else { return 0.0 }
        let oneThird = snapshot.proximityFactor / 3
        return (oneThird - distance) / oneThird
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .goodTaskBotNear) }
}

/// Asserts whether the nearest "good" `TaskBot` is considered to be at a "medium" distance from this `TaskBot`.
class GoodTaskBotMediumRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        guard let distance = snapshot.nearestGoodTaskBotTarget?.distance else { return 0.0 }
        let oneThird = snapshot.proximityFactor / 3
        return 1 - (fabs(distance - oneThird) / oneThird)
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .goodTaskBotMedium) }
}

/// Asserts whether the nearest "good" `TaskBot` is considered to be "far" from this `TaskBot`.
class GoodTaskBotFarRule: FuzzyDynamicFishRule {
    // MARK: Properties
    
    override func grade() -> Float {
        guard let distance = snapshot.nearestGoodTaskBotTarget?.distance else { return 0.0 }
        let oneThird = snapshot.proximityFactor / 3
        return (distance - oneThird) / oneThird
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .goodTaskBotFar) }
}
 
 **/
