//
//  Extensions.swift
//  SpaceInvaders
//
//  Created by Daegeon Choi on 2022/04/04.
//

import Foundation

extension Int {
    var lifeString: String {
        var baseString = ""
        
        for _ in 1...self {
            baseString.append(contentsOf: "♥︎ ")
        }
        
        return baseString
    }
}
