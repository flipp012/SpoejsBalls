//
//  BVGameCenterView.swift
//  BVVallee
//
//  Created by Brian Philippi on 9/28/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//


import Foundation
import UIKit

protocol BVGameCenterViewDelegate {
    func loginGameCenter()
    func skipGameCenter()
}

class BVGameCenterView: UIView {
    
    var delegate: BVGameCenterViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black,
            .font : UIFont(name: "Helvetica-Bold", size: 28) as Any
        ]
        
        let loginGameCenterLabel = UILabel(frame: CGRect(x: 35.0, y: 120.0, width: 305.0, height: 200.0))
        loginGameCenterLabel.text = "Would you like to log in to Game Center so you can compare your scores with the rest of the world?"
        loginGameCenterLabel.lineBreakMode = .byWordWrapping
        loginGameCenterLabel.numberOfLines = 3
        loginGameCenterLabel.textAlignment = .center
        loginGameCenterLabel.font = .systemFont(ofSize: 16.0, weight: .heavy)
        loginGameCenterLabel.textColor = .white
        self.addSubview(loginGameCenterLabel)
        
        let loginGameCenterButton = UIButton(type: UIButton.ButtonType.custom)
        let loginGameCenterTitle = NSAttributedString(string: "Log In", attributes: buttonTitleAttributes)
        loginGameCenterButton.setAttributedTitle(loginGameCenterTitle, for: .normal)
        loginGameCenterButton.frame = CGRect(x: 0, y: 350, width: frame.width * 0.5, height: 100)
        loginGameCenterButton.addTarget(self, action: #selector(loginGameCenter), for: UIControl.Event.touchUpInside)
        self.addSubview(loginGameCenterButton)
        
        let skipGameCenterButton = UIButton(type: UIButton.ButtonType.custom)
        let skipGameCenterTitle = NSAttributedString(string: "Later", attributes: buttonTitleAttributes)
        skipGameCenterButton.setAttributedTitle(skipGameCenterTitle, for: .normal)
        skipGameCenterButton.frame = CGRect(x: frame.midX, y: 350, width: frame.width * 0.5, height: 100)
        skipGameCenterButton.addTarget(self, action: #selector(skipGameCenter), for: UIControl.Event.touchUpInside)
        self.addSubview(skipGameCenterButton)
    }

    @objc func loginGameCenter() { delegate.loginGameCenter() }
    @objc func skipGameCenter() { delegate.skipGameCenter() }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
