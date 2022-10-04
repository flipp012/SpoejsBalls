//
//  BVSplashViewController.swift
//  BVVallee
//
//  Created by Brian Philippi on 5/3/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//

import Foundation
import UIKit

protocol BVSplashViewControllerDelegate {
    func endSplash()
}

class BVSplashViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { true }
    var delegate: BVSplashViewControllerDelegate!
    
    override func viewDidLoad() {
        let splashView = BVSplashView(frame: self.view.bounds)
        self.view.addSubview(splashView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate.endSplash()
        }
    }
}
