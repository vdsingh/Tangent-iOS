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
    
    let debug = false
    
    //TODO: Docstring
    let mapView: MKMapView
    
    let mapSpinner: UIActivityIndicatorView
    
    //TODO: Docstring
    var currentOverlay: MKOverlay?
    
    //TODO: docstring
    var lastUserLocation: CLLocation? {
        didSet {
            if let lastUserLocation = self.lastUserLocation {
                TAUserLocationManager.shared.setLastUserLocation(location: lastUserLocation)
            }
        }
    }
    
    //TODO: Docstring
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
            print("$LOG: tried to remove an overlay when there wasn't one.")
        }
    }
    
    //TODO: Docstring
    private func plotRoute(routeData: [CLLocation]) {
        print("$LOG: Attempting to plot route data. Count: \(routeData.count)")
        
        if routeData.isEmpty {
            print("$ERR: there is no route data to plot")
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
    
    private enum TAMapManagerError: Error {
        case responseWasNil
    }
    
    private func getDirections(
        source: CLLocationCoordinate2D,
        destination: CLLocationCoordinate2D,
        completion: @escaping (Result<MKRoute, Error>) -> Void
    ) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            if let error = error {
//                print("$ERR (TAMapManager): \(String(describing: error)).")
                completion(.failure(error))
                return
            }
//            if
            guard let unwrappedResponse = response else {
//                print("$ERR (TAMapManager): tried to get directions but response was nil.")
                completion(.failure(TAMapManagerError.responseWasNil))
                return
            }
            
            //for getting just one route
            if let route = unwrappedResponse.routes.first {
                completion(.success(route))
                //show on map
//                self.mapView.addOverlay(route.polyline)
                //set the map area to show the route
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        }
    }
    
    // MARK: - Public Functions
    
    //TODO: Docstring
    func resetMap() {
        self.removeCurrentOverlay()
        self.centerToUserLocation()
    }
    
    func plotRoute(to coordinate: CLLocationCoordinate2D) {
        guard let lastUserLocation = self.lastUserLocation else {
            print("$ERR (TAMapManager): tried to plot a route to coordinate \(coordinate) but last user location was nil.")
            return
        }
        
        self.mapSpinner.startAnimating()
        self.getDirections(
            source: lastUserLocation.coordinate,
            destination: coordinate,
            completion: { result in
                switch result {
                case .success(let route):
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                case .failure(let error):
                    print("$ERR: \(String(describing: error))")
                }
                
                self.mapSpinner.stopAnimating()
            }
        )
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
