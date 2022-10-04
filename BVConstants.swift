//
//  BVConstants.swift
//  BVVallee
//
//  Created by B. Philippi on 6/26/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import Foundation

struct PhysicsCategories {
    static let Ball: UInt32 = 1
    static let PaddleSegment: UInt32 = 2
    static let Paddle: UInt32 = 3
    static let GameFrame: UInt32 = 4
}

enum GameDifficultySettings: CaseIterable {
    case easy
    case normal
    case hard
    case insane
}
