//
//  BVGameCenterController.swift
//  BVVallee
//
//  Created by Brian Philippi on 9/28/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//

import Foundation
import UIKit

protocol BVGameCenterControllerDelegate {
    func skipGameCenter()
}

class BVGameCenterController: UIViewController, BVGameCenterViewDelegate {
    
    override var prefersStatusBarHidden: Bool { true }
    var delegate: BVGameCenterControllerDelegate!
    
    override func viewDidLoad() {
        let gameCenterView = BVGameCenterView(frame: self.view.bounds)
        gameCenterView.delegate = self
        self.view.addSubview(gameCenterView)
    }
    
    func skipGameCenter() {
        delegate.skipGameCenter()
    }
    
    func loginGameCenter() { BVGameCenter.shared.authenticateLocalPlayer(presentingVC: self) }
}
