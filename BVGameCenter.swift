//
//  BVGameCenter.swift
//  BVVallee
//
//  Created by Brian Philippi on 9/28/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//  from: https://medium.com/@alexanderruzmanov/custom-game-center-leaderboard-in-your-ios-game-ee6358409bb0

import GameKit

class BVGameCenter {
    
    static let shared = BVGameCenter()
    
    private init() {
        
    }
    
    // API
    
    // status of Game Center
    private(set) var isGameCenterEnabled: Bool = false
    
    // try to authenticate local player (takes presenting VC for presenting Game Center VC if necessary)
    func authenticateLocalPlayer(presentingVC: UIViewController) {
        
        localPlayer.authenticateHandler = { [weak self] (gameCenterViewController, error) -> Void in
            
            if error != nil {
                print(error!)
            
            } else if gameCenterViewController != nil {
                // 1. Show login if player is not logged in
                presentingVC.present(gameCenterViewController!, animated: true, completion: nil)
            
            } else if (self?.localPlayer.isAuthenticated ?? false) {
                // 2. Player is already authenticated & logged in, load game center
                self?.isGameCenterEnabled = true
            
            } else {
                // 3. Game center is not enabled on the users device
                self?.isGameCenterEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    // method for loading scores from leaderboard
    func loadScores(finished: @escaping ([(playerName: String, score: Int)]?) -> ()) {
        // fetch leaderboard from Game Center
        fetchLeaderboard { [weak self] in
            if let localLeaderboard = self?.leaderboard {
                // set player scope as .global (it's set by default) for loading all players results
                localLeaderboard.playerScope = .global
                // load scores and then call method in closure
                localLeaderboard.loadScores { [weak self] (scores, error) in
                    
                    if error != nil {
                        print(error!)
                    
                    } else if scores != nil {
                        // assemble leaderboard info
                        var leaderBoardInfo: [(playerName: String, score: Int)] = []
                        for score in scores! {
                            let name = score.player.alias
                            let userScore = Int(score.value)
                            leaderBoardInfo.append((playerName: name, score: userScore))
                        }
                        
                        self?.scores = leaderBoardInfo
                        // call finished method
                        finished(self?.scores)
                    }
                }
            }
        }
    }
    
    // update local player score
    func updateScore(with value: Int) {
        // take score
        let score = GKScore(leaderboardIdentifier: leaderboardID)
        // set value for score
        score.value = Int64(value)
        // push score to Game Center
        GKScore.report([score]) { (error) in
            // check for errors
            if error != nil {
                print("Score updating -- \(error!)")
            }
        }
    }
    
    // local player
    private var localPlayer = GKLocalPlayer.local
    
    // leaderboard ID from iTunes Connect
    private let leaderboardID = "com.spoejsballs.classic"
    
    private var scores: [(playerName: String, score: Int)]?
 
    private var leaderboard: GKLeaderboard?
    
    private func fetchLeaderboard(finished: @escaping () -> ()) {
        
        if localPlayer.isAuthenticated {
            
            GKLeaderboard.loadLeaderboards { [weak self] (leaderboards, error) in
                
                if error != nil {
                    print("Fetching leaderboard -- \(error!)")
                } else {
                    
                    if leaderboards != nil {
                        for leaderboard in leaderboards! {
                            
                            // find leaderboard with given ID (if there are multiple leaderboards)
                            if leaderboard.identifier == self?.leaderboardID {
                                self?.leaderboard = leaderboard
                                finished()
                            }
                        }
                    }
                }
            }
        }
    }
}
