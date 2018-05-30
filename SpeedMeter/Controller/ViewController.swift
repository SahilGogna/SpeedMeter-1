//
//  ViewController.swift
//  SpeedMeter
//
//  Created by Mustafa GUNES on 29.05.2018.
//  Copyright © 2018 Mustafa GUNES. All rights reserved.
//

import UIKit
import RevealingSplashView

class ViewController: UIViewController {
    
    let splashView = RevealingSplashView(iconImage: UIImage (named: "Icon-3x")!, iconInitialSize: CGSize (width: 70, height: 70), backgroundColor: UIColor.white)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(splashView)
        splashView.animationType = .heartBeat
        splashView.startAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.splashView.finishHeartBeatAnimation()
        }
    }
}

