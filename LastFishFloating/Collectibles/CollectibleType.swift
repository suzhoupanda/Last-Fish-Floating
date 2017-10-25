//
//  CollectibleType.swift
//  LastFishFloating
//
//  Created by Aleksander Makedonski on 10/25/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


/** All collectibles have the follow attributes in comon: monetary value, mass (in grams), percent metal content; the player has a limited carrying capacity and cannot add items in excess of that carrying capacity; some items are required to complete specific missions, while others are generally available throughout the game **/

enum CollectibleType: Int{
    case PowerDrill = 1
    case Sander = 2
    case Wrench = 3
    case SocketWrench = 5
    case Scraper = 6
    case DoubleWrench = 7
    case LockingWrench = 8
    case Pliers = 9
    case Chisel = 10
    case PaintBrush = 11
    case Cutter = 13
    case RollingBrush = 14
    case Saw = 16
    case Screw = 18
    case Tack = 19
    case Axe = 20
    case Shovel = 22
    case Pencil = 24
    case Pen = 25
    case FountainPenRed = 27
    case FountainPenBlue = 28
    case FeatherPen = 29
    case ClosedBook = 35
    case Clipboard = 38
    case Flashlight = 48
    case Labtop1 = 49
    case Labtop2 = 50
    case ScreenMonitor = 51
    case LEDMonitor = 52
    case LEDMonitorWide = 53
    case ComputerTowerGrey = 54
    case ComputerTowerBeige = 55
    case Cellphone1 = 63
    case Cellphone2 = 64
    case iPod = 66
    case iPhone = 67
    case MotherBoard = 75
    case RAMStick1 = 76
    case RAMStick2 = 77
    case RAMStick3 = 78
    case Joystick1 = 79
    case Joystick2 = 80
    case NintendoController = 81
    case SegaController = 82
    case Microphone = 83
    case Headphones =  84
    case CD = 88
    case Syringe = 93
    case Toothbrush = 95
    case RedPills = 99
    case Bandaid = 100
    case Bone = 101
    case MedKit = 102
    case BeakerRed = 107
    case FlaskGreen = 108
    case TestTubes = 109
    case Stethoscope = 110
    case FryingPan = 116
    case Salt = 122
    case Pepper = 123
    case Coffee = 124
    case Bottle = 127
    case Fork = 129
    case Spoon = 130
    case Knife = 131
    case Tongs = 136
    case Blender = 137
    case Toaster = 138
    case CoffeeMaker = 139
    case Briefcase = 141
    case SteeringWheel = 147
    case IDTag = 149
    case InkBottle = 150
    case Keys1 = 154
    case Keys2 = 155
    case Camera = 200
    case WallBullet = 201
    case Microscope = 111
    case CompassPointB = 500
    case CompassPointD = 501
    case Bullet1 = 502
    case Bullet2 = 503
    case RiceBowl1 = 504
    case RiceBowl2 = 505
    case RedEnvelope1 = 506
    case RedEnvelope2 = 507
    case SilverBullet = 508
    case Bomb = 510
    case WordScroll = 511
    case Grenade = 512
    
    
    
    static let PowerUpItems: [CollectibleType] = [
        
        
    ]
    
    static let SpecialItems: [CollectibleType] = [
       
    ]
    
    
    
    static let allCollectibleTypes:[CollectibleType] = {
        
        print("Generating random collectible items")
        
        var collectibleTypeArray = [CollectibleType]()
        
        for rawValue in 1...115{
            
            if rawValue == 111{
                break
            }
            
            if let anotherCollectibleType = CollectibleType(rawValue: rawValue){
                
                collectibleTypeArray.append(anotherCollectibleType)
                
            }
        }
        
        return collectibleTypeArray
        
    }()
    
    static func getRandomCollectibleType() -> CollectibleType{
        
        print("Getting a random collectible item....")
        
        let randomIdx = arc4random_uniform(UInt32(allCollectibleTypes.count))
        
        print("Random collectible with index \(randomIdx) obtained")
        
        return allCollectibleTypes[Int(randomIdx)]
    }
    
    
    func getDetailInformation() -> String{
        
        switch self {
        case .Syringe:
            return "Activating the syringe will make the player temporarily invulnerable to zombie bullets."
        case .BeakerRed:
            return "Activating the red beaker will make the player temporarily invisible to zombies"
        case .SilverBullet:
            return "Activate the silver bullet to enable the player to shoot bullets through walls."
        case .Grenade:
            return "Activate the grenade and then shake the screen.  This will cause all zombies currently in pursuit of the player to be destroyed."
            
        default:
            return "\(self.getCollectibleName()) has percent metal content of \(self.getPercentMetalContentPerUnit()) per unit and per unit value of \(self.getMonetaryUnitValue()). It cannot be activated"
        }
    }
    
    
    func getTexture() -> SKTexture{
        
        let baseStr = "genericItem_color_"
        
        var finalStr: String = String()
        
        if(self.rawValue >= 100){
            
            finalStr = baseStr.appending("\(self.rawValue)")
            
        } else if(self.rawValue >= 10){
            
            finalStr = baseStr.appending("0\(self.rawValue)")
            
        } else {
            
            finalStr = baseStr.appending("00\(self.rawValue)")
            
        }
        
        
        return SKTexture(imageNamed: finalStr)
    }
    
    public func getCanBeActivatedStatus() -> Bool{
        
        switch self {
        case .Grenade:
            return true
        case .SilverBullet:
            return true
        case .Syringe:
            return true
        case .Camera:
            return true
        case .PowerDrill:
            return true
        case .Cellphone1:
            return true
        case .Bomb:
            return true
        case .FlaskGreen:
            return true
        case .BeakerRed:
            return true
        default:
            return false
        }
    }
    
    public func getMonetaryUnitValue() -> Double{
        
        switch self{
        case .PowerDrill:
            return 30.0
        case .Sander:
            return 20.0
        case .Wrench:
            return 35.00
        case .SocketWrench:
            return 38.00
        case .Scraper:
            return 25.00
        case .DoubleWrench:
            return 11.0
        case .LockingWrench:
            return 39.00
        case .Pliers:
            return 20.0
        case .Chisel:
            return 24.0
        case .PaintBrush:
            return 44.0
        case .Cutter:
            return 50.0
        case .RollingBrush:
            return 11.00
        case .Saw:
            return 6.00
        case .Screw:
            return 3.00
        case .Tack:
            return 5.00
        case .Axe:
            return 43.0
        case .Shovel:
            return 15.00
        case .Pencil:
            return 8.00
        case .Pen:
            return 18.0
        case .FountainPenRed:
            return 21.0
        case .FountainPenBlue:
            return 29.0
        case .FeatherPen:
            return 22.0
        case .ClosedBook:
            return 31.0
        case .Clipboard:
            return 21.0
        case .Flashlight:
            return 70.0
        case .Labtop1:
            return 200.00
        case .Labtop2:
            return 250.0
        case .ScreenMonitor:
            return 340.0
        case .LEDMonitor:
            return 400.0
        case .LEDMonitorWide:
            return 450.0
        case .ComputerTowerGrey:
            return 200.0
        case .ComputerTowerBeige:
            return 230.0
        case .Cellphone1:
            return 230.0
        case .Cellphone2:
            return 250.0
        case .iPod:
            return 300.0
        case .iPhone:
            return 350.0
        case .MotherBoard:
            return 400.0
        case .RAMStick1:
            return 200.0
        case .RAMStick2:
            return 210.0
        case .RAMStick3:
            return 190.0
        case .Joystick1:
            return 180.0
        case .Joystick2:
            return 170.0
        case .NintendoController:
            return 160.0
        case .SegaController:
            return 150.0
        case .Microphone:
            return 200.0
        case .Headphones:
            return 100.0
        case .CD:
            return 140.0
        case .Syringe:
            return 90.0
        case .Toothbrush:
            return 55.0
        case .RedPills:
            return 60.0
        case .Bandaid:
            return 65.0
        case .Bone:
            return 1.00
        case .MedKit:
            return 60.0
        case .BeakerRed:
            return 100.0
        case .FlaskGreen:
            return 90.0
        case .TestTubes:
            return 90.0
        case .Stethoscope:
            return 80.0
        case .FryingPan:
            return 80.0
        case .Salt:
            return 59.0
        case .Pepper:
            return 55.0
        case .Coffee:
            return 51.0
        case .Bottle:
            return 56.0
        case .Fork:
            return 45.0
        case .Spoon:
            return 30.0
        case .Knife:
            return 40.0
        case .Tongs:
            return 55.0
        case .Blender:
            return 400.0
        case .Toaster:
            return 400.0
        case .CoffeeMaker:
            return 450.0
        case .Briefcase:
            return 60.0
        case .SteeringWheel:
            return 140.0
        case .IDTag:
            return 110.0
        default:
            return 20.0
        }
    }
    
    public func getCollectibleName() -> String{
        switch self{
        case .Axe:
            return "Axe"
        case .Bandaid:
            return "Bandaid"
        case .BeakerRed:
            return "Red Beaker"
        case .Blender:
            return "Blender"
        case .Bone:
            return "Bone"
        case .Bottle:
            return "Bottle"
        case .Briefcase:
            return "Briefcase"
        case .CD:
            return "CD"
        case .Cellphone1,.Cellphone2:
            return "Cell Phone"
        case .Chisel:
            return "Chisel"
        case .Clipboard:
            return "Clipboard"
        case .Coffee:
            return "Coffee"
        case .CoffeeMaker:
            return "Coffee Maker"
        case .ComputerTowerBeige,.ComputerTowerGrey:
            return "Computer Tower"
        case .Cutter:
            return "Box Cutter"
        case .DoubleWrench:
            return "Double-Ended Wrench"
        case .FeatherPen:
            return "Feather Pen"
        case .Flashlight:
            return "Flash Light"
        case .Camera:
            return "Camera"
        case .FlaskGreen:
            return "Green Flask"
        case .Fork:
            return "Fork"
        case .FountainPenBlue, .FountainPenRed:
            return "Fountain Pen"
        case .FryingPan:
            return "Frying Pan"
        case .Headphones:
            return "Headphones"
        case .IDTag:
            return "ID Tag"
        case .InkBottle:
            return "Ink Bottle"
        case .iPhone:
            return "iPhone"
        case .iPod:
            return "iPod"
        case .Joystick1,.Joystick2:
            return "Joystick"
        case .Keys1,.Keys2:
            return "Keys"
        case .Knife:
            return "Knife"
        case .Labtop1,.Labtop2:
            return "Labtop"
        case .LEDMonitor:
            return "LED Monitor"
        case .LEDMonitorWide:
            return "Wide LED Monitor"
        case .MedKit:
            return "MedKit"
        case .LockingWrench:
            return "Locking Wrench"
        case .MotherBoard:
            return "MotherBoard"
        case .NintendoController:
            return "Nintendo Controller"
        case .Pepper:
            return "Pepper"
        case .Pliers:
            return "Pliers"
        case .PowerDrill:
            return "Power Drill"
        case .Pen:
            return "Ballpoint Pen"
        case .Pencil:
            return "Pencil"
        case .RAMStick1,.RAMStick2,.RAMStick3:
            return "RAM Stick"
        case .RedPills:
            return "Red Pills"
        case .RollingBrush:
            return "Roller Brush"
        case .Salt:
            return "Salt"
        case .Saw:
            return "Saw"
        case .Wrench:
            return "Wrench"
        case .Toothbrush:
            return "Tooth Brush"
        case .Tongs:
            return "Tongs"
        case .Toaster:
            return "Toaster"
        case .TestTubes:
            return "Test Tubes"
        case .Tack:
            return "Tack"
        case .Syringe:
            return "Syringe"
        case .Stethoscope:
            return "Stethoscope"
        case .SteeringWheel:
            return "Steering Wheel"
        case .Spoon:
            return "Spoon"
        case .SocketWrench:
            return "Socket Wrench"
        case .Shovel:
            return "Shovel"
        case .Screw:
            return "Screw"
        case .SegaController:
            return "Sega Controller"
        case .Scraper:
            return "Scraper"
        case .Sander:
            return "Sander"
        case .Grenade:
            return "Grenade"
        case .SilverBullet:
            return "Silver Bullet"
        case .PaintBrush:
            return "Paintbrush"
        case .Microphone:
            return "Microphone"
        case .ClosedBook:
            return "Book"
        case .Microscope:
            return "Microscope"
        case .CompassPointB,.CompassPointD:
            return "Map Location"
        case .RedEnvelope1,.RedEnvelope2:
            return "Red Envelope"
        case .RiceBowl1,.RiceBowl2:
            return "RiceBowl"
        case .Bullet1,.Bullet2:
            return "Bullet"
        case .Bomb:
            return "Bomb"
        default:
            return "Collecible Item"
        }
    }
    
    /** Use the unit mass to set the corresponding physics property of the collecible item **/
    
    public func getUnitMass() -> Double{
        switch self{
        case .PowerDrill:
            return 500.0
        case .Sander:
            return 50.0
        case .Wrench:
            return 65.00
        case .SocketWrench:
            return 68.00
        case .Scraper:
            return 65.00
        case .DoubleWrench:
            return 90.0
        case .LockingWrench:
            return 39.00
        case .Pliers:
            return 80.0
        case .Chisel:
            return 86.0
        case .PaintBrush:
            return 56.0
        case .Cutter:
            return 86.0
        case .RollingBrush:
            return 50.00
        case .Saw:
            return 85.00
        case .Screw:
            return 3.00
        case .Tack:
            return 50.00
        case .Axe:
            return 400.0
        case .Shovel:
            return 300.00
        case .Pencil:
            return 50.00
        case .Pen:
            return 58.0
        case .FountainPenRed:
            return 51.0
        case .FountainPenBlue:
            return 59.0
        case .FeatherPen:
            return 52.0
        case .ClosedBook:
            return 61.0
        case .Clipboard:
            return 61.0
        case .Flashlight:
            return 90.0
        case .Labtop1:
            return 600.00
        case .Labtop2:
            return 650.0
        case .ScreenMonitor:
            return 740.0
        case .LEDMonitor:
            return 700.0
        case .LEDMonitorWide:
            return 650.0
        case .ComputerTowerGrey:
            return 900.0
        case .ComputerTowerBeige:
            return 930.0
        case .Cellphone1:
            return 130.0
        case .Cellphone2:
            return 150.0
        case .iPod:
            return 100.0
        case .iPhone:
            return 150.0
        case .MotherBoard:
            return 120.0
        case .RAMStick1:
            return 120.0
        case .RAMStick2:
            return 120.0
        case .RAMStick3:
            return 120.0
        case .Joystick1:
            return 120.0
        case .Joystick2:
            return 120.0
        case .NintendoController:
            return 120.0
        case .SegaController:
            return 190.0
        case .Microphone:
            return 90.0
        case .Headphones:
            return 90.0
        case .CD:
            return 40.0
        case .Syringe:
            return 40.0
        case .Toothbrush:
            return 45.0
        case .RedPills:
            return 10.0
        case .Bandaid:
            return 15.0
        case .Bone:
            return 20.00
        case .MedKit:
            return 30.0
        case .BeakerRed:
            return 10.0
        case .FlaskGreen:
            return 9.0
        case .TestTubes:
            return 9.0
        case .Stethoscope:
            return 100.0
        case .FryingPan:
            return 120.0
        case .Salt:
            return 10.0
        case .Pepper:
            return 10.0
        case .Coffee:
            return 10.0
        case .Bottle:
            return 56.0
        case .Fork:
            return 12.0
        case .Spoon:
            return 39.0
        case .Knife:
            return 340.0
        case .Tongs:
            return 32.0
        case .Blender:
            return 200.0
        case .Toaster:
            return 300.0
        case .CoffeeMaker:
            return 350.0
        case .Briefcase:
            return 80.0
        case .SteeringWheel:
            return 190.0
        case .IDTag:
            return 50.0
        default:
            return 0.0
            
        }
    }
    
    
    public func getPercentMetalContentPerUnit() -> Double{
        
        switch self {
        case .PowerDrill:
            return 0.90
        case .Sander:
            return 0.2
        case .Wrench:
            return 1.00
        case .SocketWrench:
            return 1.00
        case .Scraper:
            return 1.00
        case .DoubleWrench:
            return 1.00
        case .LockingWrench:
            return 0.90
        case .Pliers:
            return 0.90
        case .Chisel:
            return 0.90
        case .PaintBrush:
            return 0.10
        case .Cutter:
            return 0.8
        case .RollingBrush:
            return 0.20
        case .Saw:
            return 0.89
        case .Screw:
            return 1.00
        case .Tack:
            return 1.00
        case .Axe:
            return 0.60
        case .Shovel:
            return 0.40
        case .Pencil:
            return 0.10
        case .Pen:
            return 0.10
        case .FountainPenRed:
            return 0.10
        case .FountainPenBlue:
            return 0.10
        case .FeatherPen:
            return 0.10
        case .ClosedBook:
            return 0.05
        case .Clipboard:
            return 0.10
        case .Flashlight:
            return 0.50
        case .Labtop1:
            return 0.60
        case .Labtop2:
            return 0.60
        case .ScreenMonitor:
            return 0.70
        case .LEDMonitor:
            return 0.76
        case .LEDMonitorWide:
            return 0.75
        case .ComputerTowerGrey:
            return 0.70
        case .ComputerTowerBeige:
            return 0.7
        case .Cellphone1:
            return 0.70
        case .Cellphone2:
            return 0.70
        case .iPod:
            return 0.67
        case .iPhone:
            return 0.75
        case .MotherBoard:
            return 0.70
        case .RAMStick1:
            return 0.80
        case .RAMStick2:
            return 0.8
        case .RAMStick3:
            return 0.70
        case .Joystick1:
            return 0.60
        case .Joystick2:
            return 0.70
        case .NintendoController:
            return 0.75
        case .SegaController:
            return 0.67
        case .Microphone:
            return 0.67
        case .Headphones:
            return 0.76
        case .CD:
            return 0.40
        case .Syringe:
            return 0.10
        case .Toothbrush:
            return 0.10
        case .RedPills:
            return 0.0
        case .Bandaid:
            return 0.0
        case .Bone:
            return 0.0
        case .MedKit:
            return 0.20
        case .BeakerRed:
            return 0.0
        case .FlaskGreen:
            return 0.0
        case .TestTubes:
            return 0.0
        case .Stethoscope:
            return 0.20
        case .FryingPan:
            return 0.90
        case .Salt:
            return 0.20
        case .Pepper:
            return 0.20
        case .Coffee:
            return 0.10
        case .Bottle:
            return 0.00
        case .Fork:
            return 1.00
        case .Spoon:
            return 1.00
        case .Knife:
            return 1.00
        case .Tongs:
            return 1.00
        case .Blender:
            return 0.80
        case .Toaster:
            return 0.70
        case .CoffeeMaker:
            return 0.70
        case .Briefcase:
            return 0.40
        case .SteeringWheel:
            return 0.40
        case .IDTag:
            return 0.06
        default:
            return 00.0
        }
    }
    
    
    public func getCollectibleSprite(withScale scale: CGFloat = 1.00) -> CollectibleSprite{
        
        return CollectibleSprite(collectibleType: self, scale: scale)
        
    }
    
    public func getCollectible() -> Collectible{
        
        return Collectible(withCollectibleType: self)
        
    }
    
    func description() -> String{
        
        return "Collectible with name \(self.getCollectibleName()) and a unit monetary value of \(self.getMonetaryUnitValue()) units, and also a unit mass of \(self.getUnitMass()) and percent metal content for unit of \(self.getPercentMetalContentPerUnit())"
    }
    
    
}
