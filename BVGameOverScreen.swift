//
//  BVGameOverScreen.swift
//  BVVallee
//
//  Created by Brian Philippi on 6/28/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//


import UIKit

protocol BVGameOverScreenDelegate {
    func newGame()
    func quitGame()
}

// add Game Center score fetch to this screen
// restructure with current elements moved to the top
// reveal score with worldwide score comparison
// button to log in to game center again if desired
// ad view as well
//      This screen is actually doing a lot of heavy lifting

class BVGameOverScreen: UIView {
    
    var delegate: BVGameOverScreenDelegate!
    
    var resetButton: UIButton!
    var quitButton: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black,
            .font : UIFont(name: "Helvetica-Bold", size: 28) as Any
        ]
        
        let gameOverLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.textAlignment = .center
        gameOverLabel.baselineAdjustment = .alignCenters
        gameOverLabel.font = UIFont.init(name: "Helvetica Neue Bold", size: 48)!
        self.addSubview(gameOverLabel)
        
        self.backgroundColor = UIColor.clear // UIColor.init(red: 0.84, green: 0.86, blue: 1.0, alpha: 0.5)
        
        // buttons
        let resetTitle = NSAttributedString(string: "Reset", attributes: buttonTitleAttributes)
        self.resetButton = UIButton(frame: CGRect(x: frame.width * 0.5 - 100, y: frame.height * 0.33 - 50, width: 200, height: 100))
        self.resetButton.setAttributedTitle(resetTitle, for: .normal)
        self.resetButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        self.addSubview(resetButton)
        
        let quitTitle = NSAttributedString(string: "Quit", attributes: buttonTitleAttributes)
        self.quitButton = UIButton(frame: CGRect(x: frame.width * 0.5 - 100, y: frame.height * 0.66 - 50, width: 200, height: 100))
        self.quitButton.setAttributedTitle(quitTitle, for: .normal)
        self.quitButton.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        self.addSubview(quitButton)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func newGame() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
        // self.removeFromSuperview()
        delegate.newGame()
    }
    
    @objc func quitGame() { delegate.quitGame() }
}
