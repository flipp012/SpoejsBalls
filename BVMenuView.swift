//
//  BVMenuView.swift
//  BVVallee
//
//  Created by B. Philippi on 6/29/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import UIKit

protocol BVMenuViewDelegate {
    func startGameWith(difficulty: GameDifficultySettings)
}

class BVMenuView: UIView {
    
    var delegate: BVMenuViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black,
            .font : UIFont(name: "Helvetica-Bold", size: 28) as Any
        ]
        
        let startEasyGameButton = UIButton(type: UIButton.ButtonType.custom)
        let startEasyGameTitle = NSAttributedString(string: " Easy ", attributes: buttonTitleAttributes)
        startEasyGameButton.setAttributedTitle(startEasyGameTitle, for: .normal)
        startEasyGameButton.frame = CGRect(x: frame.midX - 100, y: 100, width: 200, height: 100)
        startEasyGameButton.addTarget(self, action: #selector(startEasyGame), for: UIControl.Event.touchUpInside)
        self.addSubview(startEasyGameButton)
        
        let startNormalGameButton = UIButton(type: UIButton.ButtonType.custom)
        let startNormalGameTitle = NSAttributedString(string: " Normal ", attributes: buttonTitleAttributes)
        startNormalGameButton.setAttributedTitle(startNormalGameTitle, for: .normal)
        startNormalGameButton.frame = CGRect(x: frame.midX - 100, y: 200, width: 200, height: 100)
        startNormalGameButton.addTarget(self, action: #selector(startNormalGame), for: UIControl.Event.touchUpInside)
        self.addSubview(startNormalGameButton)
        
        let startHardGameButton = UIButton(type: UIButton.ButtonType.custom)
        let startHardGameTitle = NSAttributedString(string: " Hard ", attributes: buttonTitleAttributes)
        startHardGameButton.setAttributedTitle(startHardGameTitle, for: .normal)
        startHardGameButton.frame = CGRect(x: frame.midX - 100, y: 300, width: 200, height: 100)
        startHardGameButton.addTarget(self, action: #selector(startHardGame), for: UIControl.Event.touchUpInside)
        self.addSubview(startHardGameButton)
        
        let startInsaneGameButton = UIButton(type: UIButton.ButtonType.custom)
        let startInsaneGameTitle = NSAttributedString(string: " Insane ", attributes: buttonTitleAttributes)
        startInsaneGameButton.setAttributedTitle(startInsaneGameTitle, for: .normal)
        startInsaneGameButton.frame = CGRect(x: frame.midX - 100, y: 400, width: 200, height: 100)
        startInsaneGameButton.addTarget(self, action: #selector(startInsaneGame), for: UIControl.Event.touchUpInside)
        self.addSubview(startInsaneGameButton)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func startEasyGame() { delegate.startGameWith(difficulty: .easy) }
    @objc func startNormalGame() { delegate.startGameWith(difficulty: .normal) }
    @objc func startHardGame() { delegate.startGameWith(difficulty: .hard) }
    @objc func startInsaneGame() { delegate.startGameWith(difficulty: .insane) }
    
}
