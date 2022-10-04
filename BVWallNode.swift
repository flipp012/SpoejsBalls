//
//  BVWallNode.swift
//  BVVallee
//
//  Created by B. Philippi on 9/28/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import SpriteKit

class BVWallNode: SKNode {
    
    // at top level this is a container for the whole wall
    // I think it's required to be able to create all the walls the same way and then rotate them without messing up their coordinate systems
    
    private let length: Int = 14
    
    var wingsContainer: SKNode!

    // need to create custom WingNode class
    // pWing and nWing will have same position as BVWallNode and wingsContainer
    // drawing of the polygon path will depend on p/n
    // probably don't even need a wings[]...lines to create it and call a loop to layout each in wings = calling wings directly
    var positiveWing: SKNode! // BVWingNode! // BVWingNode!
    var negativeWing: BVWingNode! // BVWingNode!
    
    // then there's the first child, which is also an SKNode container for the actually drawn and colliding nodes
    // it joins with the springAnchors to slide back and forth without going awry, mixing it up with the physics
    
    // then there are the wings where the individual segments are layed out and stored
    // these could be individualized to allow for S curves in insane mode (something special for when players have gotten a bit used to it)
    
    // then the segments themselves which are drawn as trapezoids instead of rectangles, to allow for coverage after rotation
    // while obviating the need for nudging calculations to continually realign segments depending on difficulty configuration
    
    func prepareFor(scene: SKScene) {
        
        scene.addChild(self)
        
        let unit = scene.view?.bounds.width
        
        let base = unit! * 0.5 / CGFloat(length)
        let width = unit! * 0.15
        let nudge = unit! * 0.1
        
        func parentPhysicsBody() -> SKPhysicsBody {
            
            let physicsBody = SKPhysicsBody(circleOfRadius: 1.0)
            
            physicsBody.pinned = true
            physicsBody.allowsRotation = false
            physicsBody.collisionBitMask = 0x00000000
            
            return physicsBody
            
        }
        
        func trapezoidPathFor(parent: SKNode) -> CGPath {
            let path = UIBezierPath() // bezierPath = [UIBezierPath bezierPath];
            
            path.move(to: parent.position) // [bezierPath moveToPoint:CGPointMake(0, 0)];
            
            if (parent.name?.contains("positive"))! {
                path.addLine(to: CGPoint(x: -width, y: -nudge)) // [bezierPath addLineToPoint:CGPointMake(90, 90)];
                path.addLine(to: CGPoint(x: -width, y: base + nudge)) // [bezierPath addLineToPoint:CGPointMake(374, 90)];
                path.addLine(to: CGPoint(x: 0, y: base)) // [bezierPath addLineToPoint:CGPointMake(462, 0)];
            } else {
                path.addLine(to: CGPoint(x: 0, y: -base))
                path.addLine(to: CGPoint(x: -width, y: -base - nudge))
                path.addLine(to: CGPoint(x: -width, y: nudge))
            }
            
            return path.cgPath
        }
        
        let evenColor = UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.5, alpha: 0.5)
        let oddColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        
        func generateWingWith(parent: SKNode) {
            
            var parentNode = parent
            
            for i in 0..<length {
                let activeColor = i % 2 == 0 ? evenColor : oddColor
                
                let trapezoidPath = trapezoidPathFor(parent: parentNode)
                let segment = SKShapeNode(path: trapezoidPath) // SKSpriteNode(color: activeColor, size: segmentSize)
                segment.fillColor = activeColor
                
                let segmentID = String(i)
                segment.name = parent.name! + segmentID // 0 indexed so can multiply by an attenuating factor to determine the curve rotation individually
                
                // set it to same CGPath as SKShapeNode is drawn from
                segment.physicsBody = SKPhysicsBody(polygonFrom: trapezoidPath) // SKPhysicsBody(rectangleOf: segmentSize)
                segment.physicsBody?.allowsRotation = false
                segment.physicsBody?.categoryBitMask = PhysicsCategories.PaddleSegment
                segment.physicsBody?.collisionBitMask = 0x00000000 // PhysicsCategories.Ball
                segment.physicsBody?.pinned = true
                //            segmentPhysicsBodies.append(segment.physicsBody!)
                
                let nextParent = SKNode()
                nextParent.name = "positiveParent" + segmentID
                nextParent.position.y = parent.name!.contains("positive") ? -base : base
                nextParent.physicsBody = parentPhysicsBody()
                // nextParent.position = CGPoint() offset by height of top (short) side of trapezoid
                
                parentNode.addChild(segment)
                parentNode.addChild(nextParent)
                
                parentNode = nextParent
            }
        }
        
        wingsContainer = SKNode()
        wingsContainer.physicsBody = parentPhysicsBody()
//        wingsContainer.physicsBody = SKPhysicsBody(circleOfRadius: 1.0)
//        // wingsContainer.physicsBody?.categoryBitMask = PhysicsCategories.Paddle
//        wingsContainer.physicsBody?.collisionBitMask = 0x00000000 // PhysicsCategories.Ball
//        wingsContainer.physicsBody?.allowsRotation = false
        self.addChild(wingsContainer)
        
        positiveWing = SKNode() // BVWingNode()
        positiveWing.physicsBody = parentPhysicsBody() // SKPhysicsBody(circleOfRadius: 1.0)
//        positiveWing.physicsBody?.pinned = true
//        positiveWing.physicsBody?.allowsRotation = false
//        positiveWing.physicsBody?.collisionBitMask = 0x00000000
        positiveWing.name = "positive"
        self.wingsContainer.addChild(positiveWing)
        generateWingWith(parent: positiveWing)
        
        // positiveWing.orientation = .positive
        // positiveWing.prepareFor(scene: scene)
        
        negativeWing = BVWingNode()
        negativeWing.orientation = .negative
        negativeWing.prepareFor(scene: scene)
        self.wingsContainer.addChild(negativeWing)
        
    }
}
