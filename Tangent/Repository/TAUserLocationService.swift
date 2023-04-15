//
//  TALocationManager.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import Foundation
import CoreLocation

//TODO: Docstring
final class TAUserLocationService: NSObject, Debuggable {
    
    let debug = false
    
    //TODO: Docstring
    static let shared = TAUserLocationService()
    
    //TODO: Docstring
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    //TODO: Docstring
    private var lastUserLocation: CLLocation?
        
    //TODO: Docstring
    private override init() { }
    
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
    
    func setLastUserLocation(location: CLLocation) {
        self.lastUserLocation = location
    }
    
    func getLastUserLocation() -> CLLocationCoordinate2D? {
        return self.lastUserLocation?.coordinate ?? nil
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
            self.handleLocationAuthorizationFailure(authorizationStatus: locationManager.authorizationStatus)
        }
    }
    
    //TODO: Docstring
    func stopUpdatingLocation() {
        printDebug("Stopped Updating Location")
        self.locationManager.stopUpdatingLocation()
    }
    
    func printDebug(_ message: String) {
        print("$LOG (TAUserLocationManager): \(message)")
    }
}

//TODO: Docstrings
extension TAUserLocationService: CLLocationManagerDelegate {
    
    func handleLocationAuthorizationFailure(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .restricted, .denied:
            printError("Authorization status failure: \(authorizationStatus)")
        case .notDetermined:
            TAUserLocationService.shared.requestWhenInUseAuthorization()
        default:
            printError("Authorization failure detected with a successful status: \(authorizationStatus)")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            printDebug("Last user location: (\(latitude), \(longitude))")
            self.lastUserLocation = location
        } else {
            printError("User locations is empty.")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        printError("failed to update location with error: \(String(describing: error))")
    }
}
