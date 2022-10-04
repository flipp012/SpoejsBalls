//
//  GameViewController.swift
//  BVVallee
//
//  Created by B. Philippi on 6/26/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, BVGameSceneDelegate {

    override var shouldAutorotate: Bool { false }
    override var prefersStatusBarHidden: Bool { true }
    // prevent accidental launch of control center swiping upwards from bottom
    override dynamic var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }
    
    var difficulty: GameDifficultySettings!
    
    let window: UIWindow = {
        let w = UIWindow()
        return w
    }()
    
    override func loadView() {
        self.view = SKView(frame: window.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let scene = SKScene(fileNamed:"GameScene") as! GameScene? { // change this to intro scene
        print("svfs", self.view.frame.size)
        let scene = GameScene(size: self.view.frame.size)
//        if let scene = SKScene(size: self.view.frame.size) as? GameScene { // change this to intro scene
        
        scene.bvgsDelegate = self
        scene.difficulty = self.difficulty
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        print("about to present game scene.")
        skView.presentScene(scene)
    }
    
    func quitGame() { self.dismiss(animated: false, completion: nil) }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}
