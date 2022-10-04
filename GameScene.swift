//
//  GameScene.swift
//  BVVallee
//
//  Created by B. Philippi on 6/26/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol BVGameSceneDelegate: AnyObject {
    func quitGame()
}

class GameScene: SKScene, SKPhysicsContactDelegate, BVPauseScreenDelegate, BVGameOverScreenDelegate {
    
     /*
     
     Proxy for segment id hit mapping with sound: Center offset along relevant wall
     
     Walls' anti-tilt detection
        Contact test picks up corner blocking (overlap)
        Activate wall to show foul
        Colorize to warn of pending deactivation
        Shake (rotate back and forth about center)
            or alternately Jiggle (slide back and forth quickly)
            to warn (same as prev.)
     
            maybe increase rate as tilt continues
        If neglected, lock back at home base for a certain amount of time
            colorize back to normal, or pulse, something
     
     Faster / slower bonuses
        Blinking dot (in for slower <> out for faster)
        Arpeggiated tune a la "Wishes" by Beach House
     
     x  Verify only one ball contact and acceleration per wall interaction
            ball keeps track of last wall in contact with
            clear on exit/start
         
            ball does it via its own class
                just to hold a var specifying which wall it hit
         
     BallSpeed controlled to always match established rate now
        Think that takes care of berzerker balls
        Problem is ball receives multiple increments with each intuitive impact
            Hitting with a moving wall seems to do this
            Fix that...tedious, but shouldn't be too bad
     
     Colors change now
        But odd, r <-> b works like expected, -> g <- is super hitchy
        Initially all go to green
            But not the same green as initially set
     
     Colors generally look harsh right now
        Sneaky Sergei episode of Justin Go! for inspiration
     
     What effects on
        ball/segment impact?
        ball fission (alt. name fissBalls)
     
     Walls moving as swipe changes orientation
        penalize Tilt lock a different way--animate the walls back to their origin if they touch, make them a different color while unavailable
     
     Style everything
        Get insane mode working with transitions
     Correct the reflection after the fact if necessary
        Will ball skip above certain speed? Deeper walls then?
            Seems like overlapped trapezoidal segments prevents this
     Countdown to ball drop
     Basic instruction before first ball drop
     ball starts to change color before change in velocity? shift!
     
        pause
     reset (instead of save? or should it even be there?)
        quit
     lives (one per ball split?) penalize one when all balls are gone
        restart speed ups each time?
     
        Increase speed with each wall contact
     
        In wall class
            countdown to morph (insane mode) moreph (wtf?)
     
     GlowTrax
        null at the start
        first contact initialize
        after a few, develop comet tail
     */
    
    weak var bvgsDelegate: BVGameSceneDelegate!
    
    var reset = false
    
    var contacts = 0

    var bounds: CGRect!
    
    var difficulty: GameDifficultySettings!
    
    var nBalls = 0 // this might be stupid...could just query the parent node for children of this type
    var ballVelocity : CGFloat { sumVelocity / CGFloat(nBalls) - CGFloat(nBalls) * 10.0 }
    
    var sumVelocity : CGFloat = 200.0 // ballVelocityScalar
    var ballTrax : SKEmitterNode!
    
    var gameFrame : SKShapeNode!
    
    //var walls: [BVVallNode] = [] // why this array again?
    
    var movingWall: BVVallNode!
    var dragScalar: CGFloat = 0.1
    
    var topWall : BVVallNode!
    var rightWall : BVVallNode!
    var bottomWall : BVVallNode!
    var leftWall: BVVallNode!
    
    var topSpringAnchor : BVSpringAnchorNode!
    var rightSpringAnchor : BVSpringAnchorNode!
    var bottomSpringAnchor : BVSpringAnchorNode!
    var leftSpringAnchor : BVSpringAnchorNode!
    
    var lastTouchPoint = CGPoint(x: 0.0, y: 0.0)
    var touchPoint = CGPoint(x: 0.0, y: 0.0) { didSet { lastTouchPoint = oldValue  } }
    
    let bounceSound = SKAction.playSoundFileNamed("WET HI2 W_PING.wav", waitForCompletion: false)

    var pauseScreen: BVPauseScreen!
    var gameOverScreen: BVGameOverScreen!
    
    let hudFont = UIFont.init(name: "Helvetica Neue Bold", size: 24)
    var score = 0
    let scoreLabel = UILabel()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        bounds = self.view?.bounds
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        gameFrame = SKShapeNode(rect: self.frame)
        if #available(iOS 13.0, *) {
            gameFrame.fillColor = .black // .systemBackground
        } else {
            gameFrame.fillColor = .black
        }
        gameFrame.strokeColor = .clear
        gameFrame.position = CGPoint(x: 0, y: 0)
        gameFrame.physicsBody = SKPhysicsBody(rectangleOf: gameFrame.frame.size)
        gameFrame.physicsBody?.isDynamic = false
        gameFrame.physicsBody?.categoryBitMask = PhysicsCategories.GameFrame
        self.addChild(gameFrame)
            
        // let ball = newBall()
        // setupBallTrax()
        setupWalls()
        setupSpringAnchors()
        setupSpringJoints()
        newGame()
        
        self.isUserInteractionEnabled = true
                
        let pauseButton = UIButton(frame: CGRect(x: bounds.width - 40, y: bounds.height * 0.01, width: 40, height: 40))
        pauseButton.setTitle("ll", for: .normal)
        pauseButton.titleLabel?.font = hudFont
        pauseButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        self.view?.addSubview(pauseButton)
        
        // let scoreLabel = UILabel(frame: CGRect(x: 40, y: bounds.height * 0.01, width: 300, height: 40))
        scoreLabel.frame = CGRect(x: 40, y: bounds.height * 0.01, width: 300, height: 40)
        scoreLabel.text = String(score)
        scoreLabel.font = hudFont
        self.view?.addSubview(scoreLabel)
    }
    
    private func newBall() -> SKSpriteNode {
        let ball = BVBall(imageNamed: "ball")
        ball.size = CGSize(width: 9, height: 9)
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4.5)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.density = 0.1
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.mass = 0.01
        ball.physicsBody?.categoryBitMask = PhysicsCategories.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCategories.PaddleSegment // 0x00000000
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.GameFrame + PhysicsCategories.PaddleSegment
        ball.position = CGPoint(x: 0, y: 0)
        self.addChild(ball)

        ballTrax = SKEmitterNode(fileNamed: "BallTrax.sks")
        ball.addChild(ballTrax)

        return ball
    }

    /*
    private func setupBallTrax() {
        ballTrax = SKEmitterNode(fileNamed: "BallTrax.sks")
        ball.addChild(ballTrax)
    }
    */
    
    private func setupWalls() {
        
        let ratio: CGFloat = 0.47 // was 0.82
        
        topWall = BVVallNode()

        let topWallContainer = SKNode()
        topWallContainer.position.y = self.bounds.width * ratio
        topWallContainer.addChild(self.topWall)
        self.addChild(topWallContainer)
        
        topWall.zRotation = CGFloat(GLKMathDegreesToRadians(270.0))
        topWall.name = "topWall"
        // topWall.scalar = CGVector(dx: dragScalar, dy: 0.0)
        topWall.prepareFor(scene:self)
//        walls.append(self.topWall)
        
        rightWall = BVVallNode()
        
        let rightWallContainer = SKNode()
        rightWallContainer.position.x = self.bounds.width * ratio
        rightWallContainer.addChild(self.rightWall)
        self.addChild(rightWallContainer)
        
        rightWall.zRotation = CGFloat(GLKMathDegreesToRadians(180.0))
        rightWall.name = "rgtWall"
        // rightWall.scalar = CGVector(dx: 0.0, dy: dragScalar)
        rightWall.prepareFor(scene:self)
//        self.walls.append(self.rightWall)
        
        bottomWall = BVVallNode()
        
        let bottomWallContainer = SKNode()
        bottomWallContainer.position.y = self.bounds.width * -ratio
        bottomWallContainer.addChild(self.bottomWall)
        self.addChild(bottomWallContainer)
        
        bottomWall.zRotation = CGFloat(GLKMathDegreesToRadians(90.0))
        bottomWall.name = "btmWall"
        // bottomWall.scalar = CGVector(dx: dragScalar, dy: 0.0)
        bottomWall.prepareFor(scene:self)
//        self.walls.append(self.bottomWall)
        
        self.leftWall = BVVallNode()
        
        let leftWallContainer = SKNode()
        leftWallContainer.position.x = self.bounds.width * -ratio
        leftWallContainer.addChild(self.leftWall)
        self.addChild(leftWallContainer)
        
        leftWall.name = "lftWall"
        // leftWall.scalar = CGVector(dx: 0.0, dy: dragScalar)
        leftWall.prepareFor(scene:self)
//        self.walls.append(self.leftWall)
    }
    
    private func setupSpringAnchors() {
        topSpringAnchor = BVSpringAnchorNode(rectOf: CGSize(width: self.bounds.width * 0.2, height: self.bounds.width * 0.2))
        topSpringAnchor.position = CGPoint(x: 0, y: self.bounds.width * 0.5)
        topSpringAnchor.addTo(scene: self)
        
        rightSpringAnchor = BVSpringAnchorNode(rectOf: CGSize(width: self.bounds.width * 0.2, height: self.bounds.width * 0.2))
        rightSpringAnchor.position = CGPoint(x: self.bounds.width * 0.5, y: 0)
        rightSpringAnchor.addTo(scene: self)
            
        bottomSpringAnchor = BVSpringAnchorNode(rectOf: CGSize(width: self.bounds.width * 0.2, height: self.bounds.width * 0.2))
        bottomSpringAnchor.position = CGPoint(x: 0, y: self.bounds.width * -0.5)
        bottomSpringAnchor.addTo(scene:self)
        
        leftSpringAnchor = BVSpringAnchorNode(rectOf: CGSize(width: self.bounds.width * 0.2, height: self.bounds.width * 0.2))
        leftSpringAnchor.position = CGPoint(x: self.bounds.width * -0.5, y: 0)
        leftSpringAnchor.addTo(scene:self)
    }
    
    private func setupSpringJoints() {
        
        let topSpringJoint = SKPhysicsJointSpring.joint(withBodyA: self.topSpringAnchor.physicsBody!, bodyB: self.topWall!.physicsBody!, anchorA: self.topSpringAnchor.position, anchorB: self.topWall.position)
        
        topSpringJoint.frequency = 1.0
        topSpringJoint.damping = 1.0
        
        scene?.physicsWorld.add(topSpringJoint)
        
        let rightSpringJoint = SKPhysicsJointSpring.joint(withBodyA: self.rightSpringAnchor.physicsBody!, bodyB: self.rightWall.physicsBody!, anchorA: self.rightSpringAnchor.position, anchorB: self.rightWall.position)
        
        rightSpringJoint.frequency = 1.0
        rightSpringJoint.damping = 1.0
        
        scene?.physicsWorld.add(rightSpringJoint)
        
        let bottomSpringJoint = SKPhysicsJointSpring.joint(withBodyA: self.bottomSpringAnchor.physicsBody!, bodyB: self.bottomWall.physicsBody!, anchorA: self.bottomSpringAnchor.position, anchorB: self.bottomWall.position)
        
        bottomSpringJoint.frequency = 1.0
        bottomSpringJoint.damping = 1.0
        
        scene?.physicsWorld.add(bottomSpringJoint)
        
        let leftSpringJoint = SKPhysicsJointSpring.joint(withBodyA: self.leftSpringAnchor.physicsBody!, bodyB: self.leftWall.physicsBody!, anchorA: self.leftSpringAnchor.position, anchorB: self.leftWall.position)
        
        leftSpringJoint.frequency = 1.0
        leftSpringJoint.damping = 1.0
        
        scene?.physicsWorld.add(leftSpringJoint)
    }
    
    @objc func newGame() {
        
//        if let gameOverView = self.view?.viewWithTag(2) {
//            print("found gameOverView")
//            gameOverView.removeFromSuperview()
//        }
        
        nBalls += 1
        sumVelocity = 200.0
        // self.isPaused = false
        let firstBall = newBall()
        self.launch(ball: firstBall)
        score = 0
        scoreLabel.text = String(score)
    }
    
    // using a delegate in PB
    @objc func pauseGame() {
        self.isPaused = true
        pauseScreen = BVPauseScreen(frame: UIWindow().frame)
        pauseScreen.delegate = self
        self.view?.addSubview(pauseScreen)
    }
    
    func resumeGame() {
        self.isPaused = false
    }
    
    func quitGame() { bvgsDelegate.quitGame() }
    
    func gameOver() { // could just be anonymous in update...does it matter, maybe clearer here
        // make this like the pauseScreen
        // easy to remove when restarting the game
        
        // self.isPaused = true
        // https://stackoverflow.com/a/48587733
        // singleton pattern makes it work, thanks Kevinosaurio
        if gameOverScreen == nil {
            gameOverScreen = BVGameOverScreen(frame: UIWindow().frame)
            gameOverScreen.delegate = self
            // gameOverScreen.tag = 2
        }
        if !gameOverScreen.isDescendant(of: (self.view!)) {
            self.view?.addSubview(gameOverScreen)
        }
    }
    
    func launch(ball: SKSpriteNode) { // take ball as parameter now
        
        let delay = SKAction.wait(forDuration: 1.0)
        self.run(delay) {
            
            // ensure ball is in position and motionless
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            
            // random angle
            let randDeg = arc4random_uniform(360)
            let randRad = Double(randDeg) * .pi/180.0
            let randVec = CGVector(dx: cos(randRad), dy: sin(randRad)).multiplyByScalar(scale: 3.0)
            ball.physicsBody?.applyImpulse(randVec)
        }
        
        reset = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint = touches.first?.location(in: self) ?? CGPoint.zero
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        touchPoint = touches.first?.location(in: self) ?? CGPoint.zero
        let dragX = touchPoint.x - lastTouchPoint.x
        let dragY = touchPoint.y - lastTouchPoint.y
        
        var dragVector = CGVector(dx: 0.0, dy: 0.0)
        
        if movingWall == nil {
            if abs(dragX) > abs(dragY) {
                movingWall = dragX > 0 ? leftWall : rightWall
            } else {
                movingWall = dragY > 0 ? bottomWall : topWall
            }
        }
        
        if movingWall == leftWall || movingWall == rightWall {
            dragVector.dx = dragX * dragScalar
        } else {
            dragVector.dy = dragY * dragScalar
        }
        
        /* original: circular one-touch movement
         // how to blend these two?
         // only one wall per touch is too sticky sometimes, want smoother response
        if abs(dragX) > abs(dragY) {
            movingWall = dragX > 0 ? leftWall : rightWall
            dragVector.dx = dragX * dragScalar
        } else {
            movingWall = dragY > 0 ? bottomWall : topWall
            dragVector.dy = dragY * dragScalar
        }
        */
        
        if movingWall.canMove {
            movingWall.physicsBody?.applyImpulse(dragVector) // 12 / 15 previously worked best
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         movingWall = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if nBalls <= 0 {
            // add some delay so the sound can play first
            gameOver()
        }
        
        // let floatBalls = CGFloat(self.nBalls)
        // let ballVelocity = self.sumVelocity / floatBalls - floatBalls * 10.0

        self.enumerateChildNodes(withName: "ball", using: {
                 (node, stop) in
            node.physicsBody?.velocity = (node.physicsBody?.velocity.normalizeVector().multiplyByScalar(scale: self.ballVelocity))!
        })

        ballTrax.targetNode = self
        ballTrax.particleBirthRate = 50.0
        ballTrax.particleLifetime = 0.4
        ballTrax.particleScale = 0.7
        ballTrax.particleScaleSpeed = -1.0
        // starting to look alright
        // need faster particle generation and death
        // faster particle generation with scaledown over lifetime
                
        if ballVelocity > 350.0 && ballVelocity < CGFloat.greatestFiniteMagnitude {
            nBalls += 1
            launch(ball: newBall())
        }
        
        self.enumerateChildNodes(withName: ".//*Wall", using: {
            (node, stop) in
            
            let wall = node as! BVVallNode
            
            wall.tiltPoints += wall.touchingAnotherWall ? 6.0 : -1.0
            
            if wall.tiltPoints > 0 {
                // enact tilt penalty--elektrisk stød
                // print("tilt happens")
            }
            
            wall.touchingAnotherWall = false
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
         
        // increment ball speed on wall contact
        if contact.bodyA.categoryBitMask == PhysicsCategories.Ball || contact.bodyB.categoryBitMask == PhysicsCategories.Ball {
            
            let ballContactBody = (contact.bodyA.categoryBitMask == PhysicsCategories.Ball) ? contact.bodyA : contact.bodyB
            
            let otherContactBody = ballContactBody == contact.bodyA ? contact.bodyB : contact.bodyA
            
            let ball = ballContactBody.node as! BVBall
            if let baseName = otherContactBody.node!.name?.split(separator: "_")[0] {
                
                if ball.mostRecentContactName != baseName {
                
                    ball.mostRecentContactName = String(baseName)
                    // messy and buggy, but kind of works
                    // ball has reference to how fast it's moving, reset on each impact
                    // so balls only slow down on impact, not when new ball is released
                    // each ball gets a bonus based on its most recent contact segement number
                    // contact segment number as a separate entity, so none of this cumbersome checking
                    
                    var bonus = 0.0
                    
                    if (otherContactBody.node!.name?.contains("Wall"))! {
                        print("contacted \(otherContactBody.node!.name!)")
                        
                    } else {
                        
                        if let segment = otherContactBody.node!.name?.split(separator: "_").last {
                            bonus = CGFloat(truncating: NumberFormatter().number(from: String(segment))!)
                        }
                    }
                    
                    sumVelocity += (10.0 + 2.0 * bonus) / CGFloat(self.nBalls) //15.0
                    score += 1
                    scoreLabel.text = String(score)
                    run(bounceSound)
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == PhysicsCategories.PaddleSegment && contact.bodyB.categoryBitMask == PhysicsCategories.PaddleSegment {
            // print("paddle segments colliding", contact.bodyA.node!.name, contact.bodyB.node!.name)
            
            let contactABaseName = (contact.bodyA.node!.name?.split(separator: "_")[0])!
            let contactBBaseName = (contact.bodyB.node!.name?.split(separator: "_")[0])!
            
            let wallAName = ".//*" + String(contactABaseName) + "Wall"
            let wallBName = ".//*" + String(contactBBaseName) + "Wall"
            
            if wallAName != wallBName { // filter for contacts with other walls only
                
                let wallA = self.childNode(withName: wallAName) as! BVVallNode
                let wallB = self.childNode(withName: wallBName) as! BVVallNode
                
                wallA.touchingAnotherWall = true
                wallB.touchingAnotherWall = true
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
                
        if contact.bodyA.categoryBitMask == PhysicsCategories.GameFrame || contact.bodyB.categoryBitMask == PhysicsCategories.GameFrame {
            
            if contact.bodyA.categoryBitMask == PhysicsCategories.Ball || contact.bodyB.categoryBitMask == PhysicsCategories.Ball {
                
                let ballContactBody = (contact.bodyA.categoryBitMask == PhysicsCategories.Ball) ? contact.bodyA : contact.bodyB
                
                run(SKAction.playSoundFileNamed("WET SUB W_MOVEMENT.wav", waitForCompletion: false))
                
                print("ballVelocity = \(ballVelocity) \t sumVelocity = \(sumVelocity)" )

                ballContactBody.node?.run(SKAction.wait(forDuration: 1.0), completion: { ballContactBody.node?.removeFromParent() })
                sumVelocity -= ballVelocity
                nBalls -= 1
            }
        }
    }
}

extension CGVector {
    // from https://github.com/hatunike/Flying-Wizards/blob/master/FlyingWizards/CGVector%2BAdditions.swift
    
    func normalizeVector () -> CGVector {
        let length = vectorLength()
        if length == 0 {
            return CGVector(dx: 0, dy: 0) //Make(0, 0)
        }
        
        let scale = 1.0 / length
        
        return multiplyByScalar(scale: scale)
    }
    
    func multiplyByScalar (scale:CGFloat) -> CGVector {
        return CGVector(dx: self.dx * scale, dy: self.dy * scale)
    }
    
    func vectorLength() ->  CGFloat {
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }
    
    func vectorAngle() -> CGFloat {
        return atan2(self.dy, self.dx)
    }
}
