//
//  BVMenuViewController.swift
//  BVVallee
//
//  Created by B. Philippi on 6/29/19.
//  Copyright © 2019 HipstaarFolies. All rights reserved.
//
import UIKit
import AVKit

class BVMenuViewController: UIViewController, BVMenuViewDelegate {
    
    override var prefersStatusBarHidden: Bool { true }
    override var shouldAutorotate: Bool { false }
    
    private static var backgroundMusicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if BVMenuViewController.backgroundMusicPlayer == nil {
          let backgroundMusicURL = Bundle.main.url(forResource: "MOVEMENT3", withExtension: "wav")
          
          do {
            let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
            BVMenuViewController.backgroundMusicPlayer = theme
          } catch {
            // couldn't load file :[
          }
          
          BVMenuViewController.backgroundMusicPlayer.numberOfLoops = -1
        }
        
        if !BVMenuViewController.backgroundMusicPlayer.isPlaying {
          BVMenuViewController.backgroundMusicPlayer.play()
        }
        
        let menuView = BVMenuView(frame: self.view.bounds)
        menuView.delegate = self
        self.view.addSubview(menuView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGameWith(difficulty: GameDifficultySettings) {
        let gameViewController = GameViewController()
        gameViewController.difficulty = difficulty
        gameViewController.modalPresentationStyle = .fullScreen
        self.present(gameViewController, animated: true, completion: nil)
    }
    
}
