//
//  SpeedManager.swift
//  SpeedMeter
//
//  Created by Mustafa GUNES on 1.06.2018.
//  Copyright © 2018 Mustafa GUNES. All rights reserved.
//

import CoreLocation

typealias Speed = CLLocationSpeed

protocol SpeedManagerDelegate {
    func speedDidChange(_ speed: Speed)
}

class SpeedManager: NSObject, CLLocationManagerDelegate {
    
    var delegate : SpeedManagerDelegate?
    fileprivate let locationManager : CLLocationManager?
    
    override init() {
        
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil
        
        super.init()
        
        if let locationManager = self.locationManager {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestAlwaysAuthorization()
            }
            else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0)
            delegate?.speedDidChange(kmph)
        }
    }
}
