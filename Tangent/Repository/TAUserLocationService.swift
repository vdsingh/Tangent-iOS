//
//  TALocationManager.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import Foundation
import CoreLocation

/// Interface with User Location
final class TAUserLocationService: NSObject, Debuggable {
    
    let debug = false
    
    //TODO: Docstring
    static let shared = TAUserLocationService()
    
    /// The CLLocationManager to interact with CoreLocation
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    /// The last observed user location (nil if there is no last known location)
    private var lastUserLocation: CLLocation?
        
    //TODO: Docstring
    private override init() { }
    
    
    /// Returns a bool describing whether the app is usable with the current authorization status
    /// - Returns: a bool describing whether the app is usable with the current authorization status
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
    
    /// Sets the last location of the user
    /// - Parameter location: The last location of the user
    func setLastUserLocation(location: CLLocation) {
        self.lastUserLocation = location
    }
    
    /// Gets the last location of the user
    /// - Returns: The last location of the user
    func getLastUserLocation() -> CLLocationCoordinate2D? {
        return self.lastUserLocation?.coordinate ?? nil
    }
    
    /// Requests the user's location when the app is in use
    func requestWhenInUseAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /// Requests the user's location one time
    func requestUserLocationOnce() {
        locationManager.requestLocation()
    }
    
    /// Start updating the location of the user
    func startUpdatingLocation() {
        if self.validateAuthorizationStatus() {
            self.locationManager.startUpdatingLocation()
            printDebug("Started Updating Location: \(locationManager.requestLocation())")
        } else {
            self.handleLocationAuthorizationFailure(authorizationStatus: locationManager.authorizationStatus)
        }
    }
    
    /// Stops updating the location of the user
    func stopUpdatingLocation() {
        printDebug("Stopped Updating Location")
        self.locationManager.stopUpdatingLocation()
    }
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAUserLocationService): \(message)")
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension TAUserLocationService: CLLocationManagerDelegate {
    
    /// Handle user location authorization failure
    /// - Parameter authorizationStatus: The location authorization status
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
    
    /// The location manager did update locations
    /// - Parameters:
    ///   - manager: The location manager
    ///   - locations: The updated CL locations
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
    
    /// Handle location manager failure
    /// - Parameters:
    ///   - manager: The location manager that failed
    ///   - error: The error
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        printError("failed to update location with error: \(String(describing: error))")
    }
}
