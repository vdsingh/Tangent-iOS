//
//  Extensions.swift
//  Tangent
//
//  Created by Vikram Singh on 4/3/23.
//

import Foundation
import MapKit

//TODO: Docstring
extension MKMapView {
    
    //TODO: Docstring
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
