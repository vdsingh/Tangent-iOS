//
//  TALocationManager.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import Foundation
import CoreLocation

//TODO: Docstring
protocol TALocationManagerDelegate: CLLocationManagerDelegate {
    
    //TODO: Docstring
    func handleLocationAuthorizationFailure(authorizationStatus: CLAuthorizationStatus)
}

//TODO: Docstring
class TAUserLocationManager: Debuggable {
    
    let debug = true
    
    //TODO: Docstring
    static let shared = TAUserLocationManager()
    
    //TODO: Docstring
    private var delegate: TALocationManagerDelegate?
    
    //TODO: Docstring
    private let locationManager: CLLocationManager = CLLocationManager()
        
    //TODO: Docstring
    private init() { }
    
    //TODO: Docstring
    private func validateAuthorizationStatus() -> Bool {
        switch self.locationManager.authorizationStatus {
        case .denied, .restricted, .notDetermined:
            return false
        default:
            break
        }
        
        return true
    }
    
    // MARK: - Public Functions
    
    //TODO: Docstring
    func setDelegate(delegate: TALocationManagerDelegate) {
        self.locationManager.delegate = delegate
        self.delegate = delegate
        self.requestUserLocationOnce()
    }
    
    //TODO: Docstring
    func requestWhenInUseAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    //TODO: Docstring
    func requestUserLocationOnce() {
        locationManager.requestLocation()
    }
    
    //TODO: Docstring
    func startUpdatingLocation() {
        if self.validateAuthorizationStatus() {
            self.locationManager.startUpdatingLocation()
            printDebug("Started Updating Location: \(locationManager.requestLocation())")
        } else {
            guard let delegate = self.delegate else {
                print("$ERR: LocationManager Delegate not set")
                return
            }
            
            delegate.handleLocationAuthorizationFailure(authorizationStatus: locationManager.authorizationStatus)
        }
    }
    
    //TODO: Docstring
    func stopUpdatingLocation() {
        printDebug("Stopped Updating Location")
        self.locationManager.stopUpdatingLocation()
    }
    
    func printDebug(_ message: String) {
        print("$LOG: \(message)")
    }
}
