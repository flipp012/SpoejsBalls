//
//  BVSpringAnchorNode.swift
//  BVVallee
//
//  Created by B. Philippi on 8/2/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import SpriteKit

class BVSpringAnchorNode: SKShapeNode {

    func addTo(scene:SKScene) {

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 0x00000000
        self.physicsBody?.collisionBitMask = 0x00000000
        self.strokeColor = .clear
        
        scene.addChild(self)
    }
}
