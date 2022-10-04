//
//  BVNavigationController.swift
//  BVVallee
//
//  Created by Brian Philippi on 9/28/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//

import Foundation
import UIKit

class BVNavigationController: UINavigationController, BVGameCenterControllerDelegate, BVSplashViewControllerDelegate {
    
    override var prefersStatusBarHidden: Bool { true }
    override var shouldAutorotate: Bool { false }
    
    let svc = BVSplashViewController()
    let gcc = BVGameCenterController()
    let mvc = BVMenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true
        
        self.viewControllers = [mvc, gcc, svc]

        svc.delegate = self
        gcc.delegate = self
    }
    
    func endSplash() {
        let nextVC = BVGameCenter.shared.isGameCenterEnabled ? mvc : gcc
        popToViewController(nextVC, animated: false)
    }
    
    func skipGameCenter() {
        popToViewController(mvc, animated: false)
    }
}
                
