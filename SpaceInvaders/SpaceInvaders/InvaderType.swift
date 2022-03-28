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
