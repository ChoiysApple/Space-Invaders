//
//  InvaderType.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/25.
//

import SpriteKit

enum InvaderType {
  case a
  case b
  case c
  
  static var size: CGSize {
    return CGSize(width: 24, height: 16)
  }
  
  static var name: String {
    return "invader"
  }
}
