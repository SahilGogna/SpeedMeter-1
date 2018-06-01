//
//  SpeedNotifier.swift
//  SpeedMeter
//
//  Created by Mustafa GUNES on 1.06.2018.
//  Copyright © 2018 Mustafa GUNES. All rights reserved.
//

import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
    switch (lhs, rhs) {
        
    case let (l?, r?):
        return l < r
        
    case (nil, _?):
        return true
        
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
    switch (lhs, rhs) {
        
    case let (l?, r?):
        return l <= r
        
    default:
        return !(rhs < lhs)
    }
}

protocol SpeedNotifierDelegate {
    func notificationsStatusDidChange(_ shouldNotify: Bool)
}

class SpeedNotifier: NSObject, SpeedManagerDelegate {

    static fileprivate let sharedInstance = SpeedNotifier()
    
    var delegate : SpeedNotifierDelegate?
    var notificationsInterval: TimeInterval = 7
    
    var shouldNotify = false {
        didSet {
            notificationsStatusDidChange()
        }
    }
    
    fileprivate let speedManager = SpeedManager()
    fileprivate var lastNotificationTime : Date? = nil
    
    fileprivate let shortcuts = [
        "enable": UIApplicationShortcutItem(
            type: "speed.notifications.enable",
            localizedTitle: "Notify me",
            localizedSubtitle: "Enable notifications",
            icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.location),
            userInfo: nil
        ),
        
        "disable": UIApplicationShortcutItem(
            type: "speed.notifications.disable",
            localizedTitle: "Do not notify me again",
            localizedSubtitle: "Disable notifications",
            icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.pause),
            userInfo: nil
        )
    ]
    
    static func sharedNotifier() -> SpeedNotifier {
        return sharedInstance
    }
    
    fileprivate override init() {
        
        super.init()
        
        speedManager.delegate = self
        
        let notificationSettings = UIUserNotificationSettings(
            types: [UIUserNotificationType.alert],
            categories: nil
        )
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        notificationsStatusDidChange()
    }
    
    func clearNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func speedDidChange(_ speed: Speed) {
        
        let canNotify = (lastNotificationTime == nil || lastNotificationTime?.timeIntervalSinceNow <= 7) && shouldNotify
        
        if canNotify {
            let notification = UILocalNotification()
            notification.alertBody = "\(Int(speed)) km/h"
            
            clearNotifications()
            UIApplication.shared.scheduleLocalNotification(notification)
            
            lastNotificationTime = Date()
        }
    }
    
    fileprivate func notificationsStatusDidChange() {
        
        let shortcutKey = shouldNotify ? "disable" : "enable"
        
        if let shortcut = shortcuts[shortcutKey] {
            UIApplication.shared.shortcutItems = [shortcut]
        }
        
        delegate?.notificationsStatusDidChange(shouldNotify)
    }
}
