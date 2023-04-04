//
//  TAMapManager.swift
//  Tangent
//
//  Created by Vikram Singh on 4/3/23.
//

import Foundation
import MapKit
import UIKit

//TODO: Docstrings
final class TAMapManager: UIViewController, Debuggable {
    
    let debug = true
    
    //TODO: Docstring
    let mapView: MKMapView
    
    //TODO: Docstring
    var currentOverlay: MKOverlay?
    
    //TODO: docstring
    var lastUserLocation: CLLocation?
    
    //TODO: Docstring
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
        mapView.delegate = self
    }
    
    private func removeCurrentOverlay() {
        if let currentOverlay = self.currentOverlay {
            self.mapView.removeOverlay(currentOverlay)
        } else {
            print("$LOG: tried to remove an overlay when there wasn't one.")
        }
    }
    
    // MARK: - Public Functions
    
    //TODO: Docstring
    func resetMap() {
        self.removeCurrentOverlay()
        self.centerToUserLocation()
    }
    
    //TODO: Docstring
    func plotRoute(routeData: [CLLocation]) {
        print("$LOG: Attempting to plot route data. Count: \(routeData.count)")
        
        if routeData.isEmpty {
            print("$ERR: there is no route data to plot")
            return
        }
        
        let coordinates = routeData.map { $0.coordinate }
        
        DispatchQueue.main.async {
            self.removeCurrentOverlay()
            let currentOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
//            self.mapView.addOverlay(currentOverlay, level: .aboveRoads)
            self.mapView.addOverlay(currentOverlay, level: .aboveRoads)
            self.currentOverlay = currentOverlay
            
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            self.mapView.setVisibleMapRect(currentOverlay.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
    
    func centerToUserLocation() {
        if let lastUserLocation = self.lastUserLocation {
            self.mapView.centerToLocation(
                CLLocation(
                    latitude: lastUserLocation.coordinate.latitude,
                    longitude: lastUserLocation.coordinate.longitude
                )
            )
        } else {
            print("$ERR: tried to center to User Location when there is no data.")
        }
    }
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG: \(message)")
        }
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

//TODO: Docstrings
extension TAMapManager: TALocationManagerDelegate {
    
    func handleLocationAuthorizationFailure(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .restricted, .denied:
            print("$ERR: Authorization status failure: \(authorizationStatus)")
        case .notDetermined:
            TAUserLocationManager.shared.requestWhenInUseAuthorization()
        default:
            print("$ERR: Authorization failure detected with a successful status: \(authorizationStatus)")
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
            print("$ERR: User locations is empty.")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("$ERR: failed to update location with error: \(String(describing: error))")
    }
}

extension TAMapManager: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("$LOG: renderer for called.")
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
}
