//
//  AppDelegate.swift
//  SpeedMeter
//
//  Created by Mustafa GUNES on 29.05.2018.
//  Copyright © 2018 Mustafa GUNES. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController : ViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        SpeedNotifier.sharedNotifier().shouldNotify = shortcutItem.type == "speed.notifications.enable"
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SpeedNotifier.sharedNotifier().clearNotifications()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("ARKAPLAN KONTROL")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            if CLLocationManager.locationServicesEnabled() {
                print("Konum Açık !")
            }
            else {
                
                self.viewController.kmHLabel.isHidden = true
                self.viewController.speedLabel.isHidden = true
                self.viewController.notificationSwitch.isHidden = true
                self.viewController.notificationInfoLabel.isHidden = true
                
                self.viewController.lottieAnimation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                if CLLocationManager.locationServicesEnabled() {
                    print("Konum Açık PinJump!")
                }
                else {
                    self.viewController.showPopupWithStyle(CNPPopupStyle.actionSheet)
                }
            })
        })
    }
}

