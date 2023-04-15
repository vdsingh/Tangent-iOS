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
final class TAMapViewController: UIViewController, Debuggable {
    
    let debug = false
    
    /// The MapView
    let mapView: MKMapView
    
    /// The spinner which indicates whether the map is loading
    let mapSpinner: UIActivityIndicatorView
    
    //TODO: Docstring
    var currentOverlay: MKOverlay?
    
    /// Initializes a new TAMapViewController
    /// - Parameters:
    ///   - mapView: The Map View
    ///   - mapSpinner: The Spinner that indicates whether the map is loading
    init(mapView: MKMapView, mapSpinner: UIActivityIndicatorView) {
        self.mapView = mapView
        self.mapSpinner = mapSpinner
        super.init(nibName: nil, bundle: nil)
        mapView.delegate = self
    }
    
    
    // MARK: - Private Functions
    
    // TODO: Docstring
    private func removeCurrentOverlay() {
        if let currentOverlay = self.currentOverlay {
            self.mapView.removeOverlay(currentOverlay)
        } else {
            printDebug("tried to remove an overlay when there wasn't one.")
        }
    }
    
    //TODO: Docstring
    private func plotRoute(routeData: [CLLocation]) {
        printDebug("Attempting to plot route data. Count: \(routeData.count)")
        
        if routeData.isEmpty {
            printError("there is no route data to plot")
            return
        }
        
        let coordinates = routeData.map { $0.coordinate }
        
        DispatchQueue.main.async {
            self.removeCurrentOverlay()
            let currentOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(currentOverlay, level: .aboveRoads)
            self.currentOverlay = currentOverlay
            
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            self.mapView.setVisibleMapRect(currentOverlay.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
    
    
    // MARK: - Public Functions
    
    //TODO: Docstring
    func resetMap() {
        self.removeCurrentOverlay()
        self.centerToUserLocation()
    }
    
    func plotRoute(to coordinate: CLLocationCoordinate2D) {
        guard let lastUserLocation = TAUserLocationService.shared.getLastUserLocation() else {
            printError("tried to plot a route to coordinate \(coordinate) but last user location was nil.")
            return
        }
        
        self.mapSpinner.startAnimating()
        
        TADirectionsService.shared.getDirections(
            source: lastUserLocation,
            destination: coordinate,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let route):
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                case .failure(let error):
                    self.printError(error)
                }
                
                self.mapSpinner.stopAnimating()
            }
        )
    }
    
    func centerToUserLocation() {
        if let lastUserLocation = TAUserLocationService.shared.getLastUserLocation() {
            self.mapView.centerToLocation(
                CLLocation(
                    latitude: lastUserLocation.latitude,
                    longitude: lastUserLocation.longitude
                )
            )
        } else {
            printError("tried to center to User Location when there is no data.")
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

extension TAMapViewController: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        printDebug("renderer for called.")
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
}
