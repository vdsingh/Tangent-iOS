//
//  Extensions.swift
//  Tangent
//
//  Created by Vikram Singh on 4/3/23.
//

import Foundation
import MapKit

extension MKMapView {
    
    /// Centers the MapView to a specified location
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension NSObject {
    func printError(_ errorMessage: String) {
        print("$ERR: \(errorMessage)")
    }
    
    func printError(_ error: Error) {
        print("$ERR: \(String(describing: error))")
    }
}
