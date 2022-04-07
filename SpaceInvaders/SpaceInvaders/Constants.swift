//
//  Constants.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/03/25.
//

import SpriteKit

// Physics Category
let kInvaderCategory: UInt32 = 0x1 << 0
let kShipFiredBulletCategory: UInt32 = 0x1 << 1
let kShipCategory: UInt32 = 0x1 << 2
let kSceneEdgeCategory: UInt32 = 0x1 << 3
let kInvaderFiredBulletCategory: UInt32 = 0x1 << 4
let kUFOCategoty: UInt32 = 0x1 << 5

// Invaders
let kInvaderGridSpacing = CGSize(width: 12, height: 12)
let kInvaderRowCount = 6
let kInvaderColCount = 8
let kInvaderSize = CGSize(width: 32, height: 21)

// UFO
let kUFOName = "ufo"
let kUFOAppearancePercent = 30

// Ship
let kShipSize = CGSize(width: 30, height: 16)
let kShipName = "ship"
let kShipRelativeControlSize = 0.3

// HUD
let kScoreHudName = "scoreHud"
let kHealthHudName = "healthHud"
let kFontName = "Minecraft"

// Bullet
let kShipFiredBulletName = "shipFiredBullet"
let kInvaderFiredBulletName = "invaderFiredBullet"
let kBulletSize = CGSize(width:4, height: 8)

// Cover
let kCoverName = "cover"
let kCoverRowCount = 2
let kCoverColCount = 5
let kCoverSize = 10

// rule
let kMinInvaderBottomHeight: Float = 32.0
