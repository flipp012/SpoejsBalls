//
//  BVBall.swift
//  BVVallee
//
//  Created by B. Philippi on 3/9/20.
//  Copyright © 2020 HipstaarFolies. All rights reserved.
//

import SpriteKit

class BVBall: SKSpriteNode {

//    private func newBall() -> SKSpriteNode {
//
//        // move to bvball class, like wallnode does it
//        // then ball can cancel redundant wall contacts
//        let ball = SKSpriteNode(imageNamed: "ball")
//        ball.size = CGSize(width: 15, height: 15)
//        ball.name = "ball"
//        ball.physicsBody = SKPhysicsBody(circleOfRadius: 7.5)
//        ball.physicsBody?.usesPreciseCollisionDetection = true
//        ball.physicsBody?.angularDamping = 0.0
//        ball.physicsBody?.friction = 0.0
//        ball.physicsBody?.density = 0.1
//        ball.physicsBody?.linearDamping = 0.0
//        ball.physicsBody?.restitution = 1.0
//        ball.physicsBody?.mass = 0.01
//        ball.physicsBody?.categoryBitMask = PhysicsCategories.Ball
//        ball.physicsBody?.collisionBitMask = PhysicsCategories.PaddleSegment // 0x00000000
//        ball.physicsBody?.contactTestBitMask = PhysicsCategories.GameFrame + PhysicsCategories.PaddleSegment
//        ball.position = CGPoint(x: 0, y: 0)
//        self.addChild(ball)
//
//        ballTrax = SKEmitterNode(fileNamed: "BallTrax.sks")
//        ball.addChild(ballTrax)
//
//        return ball
//    }
//
//    func prepareFor(scene: GameScene) {
//
//    }
    var mostRecentContactName: String = "out"
}
