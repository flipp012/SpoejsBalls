//
//  BVPauseScreen.swift
//  BVVallee
//
//  Created by B. Philippi on 11/21/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//

import UIKit

protocol BVPauseScreenDelegate {
    func resumeGame()
    func quitGame()
}

class BVPauseScreen: UIView {
    
    var delegate: BVPauseScreenDelegate!
    
    var resumeButton: UIButton!
    var saveButton: UIButton!
    var quitButton: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
                
        let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black,
            .font : UIFont(name: "Helvetica-Bold", size: 28) as Any
        ]
        
        self.backgroundColor = UIColor.init(red: 0.84, green: 0.86, blue: 1.0, alpha: 0.5)
        
        let resumeTitle = NSAttributedString(string: " Resume ", attributes: buttonTitleAttributes)
        self.resumeButton = UIButton(frame: CGRect(x: frame.width * 0.5 - 100, y: frame.height * 0.33 - 50, width: 200, height: 100))
        self.resumeButton.setAttributedTitle(resumeTitle, for: .normal)
        self.resumeButton.addTarget(self, action: #selector(resumeGame), for: .touchUpInside)
        self.addSubview(resumeButton)
                
        let quitTitle = NSAttributedString(string: " Quit ", attributes: buttonTitleAttributes)
        self.quitButton = UIButton(frame: CGRect(x: frame.width * 0.5 - 100, y: frame.height * 0.66 - 50, width: 200, height: 100))
        self.quitButton.setAttributedTitle(quitTitle, for: .normal)
        self.quitButton.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        self.addSubview(quitButton)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func resumeGame() {
        self.removeFromSuperview()
        delegate.resumeGame()
    }
    
    @objc func quitGame() { delegate.quitGame() }
}
