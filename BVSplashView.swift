//
//  BVSplashView.swift
//  BVVallee
//
//  Created by Brian Philippi on 5/3/22.
//  Copyright © 2022 HipstaarFolies. All rights reserved.
//

import Foundation
import UIKit

class BVSplashView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        let sbl = UILabel(frame: CGRect(x: 35.0, y: 220.0, width: 305.0, height: 73.0))
        sbl.text = "SpøjsBalls"
        sbl.font = .systemFont(ofSize: 61.0, weight: .heavy)
        sbl.textColor = .white
        self.addSubview(sbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
