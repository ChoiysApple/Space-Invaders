//
//  InvaderType.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/25.
//

import SpriteKit

enum InvaderType {
    case a, b, c

    static var size: CGSize {
        return CGSize(width: 24, height: 16)
    }

    static var name: String {
        return "invader"
    }
    
    var color: SKColor {
        switch self {
        case .a: return SKColor.red
        case .b: return SKColor.green
        case .c: return SKColor.blue
        }
    }
    
}

enum InvaderMovementDirection {
  case right
  case left
  case downThenRight
  case downThenLeft
  case none
}


enum BulletType {
    case shipFired, invaderFired
    
//    var color: SKColor {
//        switch self {
//        case .shipFired: return SKColor.green
//        case .invaderFired: return SKColor.magenta
//        }
//    }
    
    var bullet: SKNode {
        switch self {
        case .shipFired:
            let bullet = SKSpriteNode(color: SKColor.green, size: kBulletSize)
            bullet.name = kShipFiredBulletName
            return bullet
        case .invaderFired:
            let bullet = SKSpriteNode(color: SKColor.magenta, size: kBulletSize)
            bullet.name = kInvaderFiredBulletName
            return bullet
        }
    }
}
