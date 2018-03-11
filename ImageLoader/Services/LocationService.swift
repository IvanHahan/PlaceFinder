//
//  LocationService.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/11/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    private let manager = CLLocationManager()
    
    static let shared = LocationService()
    
    // MARK: - Delegates
    var didChangeLocation: Closure<CLLocation>?
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var currentLocation: CLLocation? {
        return manager.location
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startObservingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopObservingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        startObservingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        didChangeLocation?(location)
        didChangeLocation = nil
        stopObservingLocation()
    }
}

