//
//  TAMapManager.swift
//  Tangent
//
//  Created by Vikram Singh on 4/3/23.
//

import Foundation
import MapKit
import UIKit

//TODO: docstring
protocol ErrorShowingController {
    func showErrorPopup(title: String, message: String)
}


/// Controller for a MapView
final class TAMapViewController: UIViewController, Debuggable {
    
    let debug = false
    
    /// The MapView
    let mapView: MKMapView
    
    /// A pin marking the final destination (not a tangent)
    var finalDestinationPin: MKPlacemark? = nil
    
    /// The spinner which indicates whether the map is loading
    let mapSpinner: UIActivityIndicatorView
    
    //TODO: docstring
    var overlayColorMap = [MKPolyline: UIColor]()
    
    //TODO: docstring
    var tangentOverlays = [MKOverlay]()
    
    //TODO: docstring
    var errorShowingController: ErrorShowingController

    /// Initializes a new TAMapViewController
    /// - Parameters:
    ///   - mapView: The Map View
    ///   - mapSpinner: The Spinner that indicates whether the map is loading
    init(mapView: MKMapView, mapSpinner: UIActivityIndicatorView, errorShowingController: ErrorShowingController) {
        self.mapView = mapView
        self.mapSpinner = mapSpinner
        self.errorShowingController = errorShowingController
        
        super.init(nibName: nil, bundle: nil)
        TABusinessService.shared.appendListener(self)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    // MARK: - Private Functions
    
    //TODO: Docstring
    private func removeAllOverlays() {
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    //TODO: Docstring
    private func removeTangentOverlays() {
        self.mapView.removeOverlays(self.tangentOverlays)
    }
    
    /// Plots a route based on route data
    /// - Parameter routeData: An array of CLLocation objects, representing the route
    private func plotRoute(routeData: [CLLocation]) {
        printDebug("Attempting to plot route data. Count: \(routeData.count)")
        
        if routeData.isEmpty {
            printError("there is no route data to plot")
            return
        }
        
        let coordinates = routeData.map { $0.coordinate }
        
        DispatchQueue.main.async {
            let currentOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(currentOverlay, level: .aboveRoads)
            
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            self.mapView.setVisibleMapRect(currentOverlay.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
    
    
    // MARK: - Public Functions
    
    /// Plots a route to a coordinate
    /// - Parameter coordinate: The destination
    func plotRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, overlayColor: UIColor, isTangentOverlay: Bool) {
        
        self.mapSpinner.startAnimating()
        
        TADirectionsService.shared.getDirections(
            source: source,
            destination: destination,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let route):
                    DispatchQueue.main.async {
                        if isTangentOverlay {
                            self.tangentOverlays.append(route.polyline)
                        }
                        self.overlayColorMap[route.polyline] = overlayColor
                        self.mapView.addOverlay(route.polyline)
                    }
                case .failure(let error):
                    self.printError(error)
                }
                
                self.mapSpinner.stopAnimating()
            }
        )
    }
    
    //TODO: Docstring
    func addPin(
        at location: CLLocationCoordinate2D,
        title: String?,
        subtitle: String? = nil,
        annotationType: TAAnnotationType
    ) {
        // create a "pin" for the business
        let annotation = TAPointAnnotation(annotationType: annotationType)
        
        // set the pin's coordinate
        annotation.coordinate = location
        
        // set the pin's title
        annotation.title = title
    
        self.mapView.addAnnotation(annotation)
    }
    
    //TODO: Docstring
    func addPin(for business: TABusiness) {
        self.addPin(
            at: business.getBusinessLocation(),
            title: business.name,
            subtitle: "\(business.rating)",
            annotationType: .tangent
        )
    }
    
    //TODO: Docstring
    func zoomToFitAllAnnotations() {
        var zoomRect = MKMapRect.null
        
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            
            if zoomRect.isNull {
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
        }
        
        self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40), animated: true)
    }
    
    /// Centers the map to the user's last location
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

/// Rendering for Map overlays (to show routes)
extension TAMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        printDebug("rendererFor MapView called.")

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        
        
        if let overlay = overlay as? MKPolyline {
            let color = self.overlayColorMap[overlay]
            renderer.strokeColor = color
        } else {
            renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        }
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Check if annotation is an MKPointAnnotation object
        guard let pointAnnotation = annotation as? TAPointAnnotation else {
            return nil
        }
        
        // Create a new annotation view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pointAnnotation") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pointAnnotation")
        } else {
            annotationView?.annotation = pointAnnotation
        }
        
        annotationView?.markerTintColor = pointAnnotation.annotationType.color
        
        return annotationView
    }
}

/// Handles what happens when a user searches a location and then clicks it
extension TAMapViewController: TAMapSearchSelectionHandler {
    func handleSearchSelection(placemark: MKPlacemark) {
        // cache the pin
        self.finalDestinationPin = placemark
        
        // clear existing pins
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        self.addPin(at: placemark.coordinate, title: placemark.name, annotationType: .finalDestination)
        
        self.zoomToFitAllAnnotations()
        
        guard let lastUserLocation = TAUserLocationService.shared.getLastUserLocation() else {
            printError("last user location was nil.")
            return
        }
        
        // plot the route from the user's location to the destination on the map
        self.removeAllOverlays()
        self.plotRoute(from: lastUserLocation, to: placemark.coordinate, overlayColor: .blue, isTangentOverlay: false)
        
        if let lastUserLocation = TAUserLocationService.shared.getLastUserLocation() {
            let userLat = Float(lastUserLocation.latitude)
            let userLon = Float(lastUserLocation.longitude)
            
            guard var prices = TAFiltersService.shared.getFilterState(for: .price).selectedValues as? [TAPrice] else {
                printError("Couldn't cast selected price values to TAPrice type")
                return
            }
            
            guard var terms = TAFiltersService.shared.getFilterState(for: .businessType).selectedValues as? [TABusinessTerm] else {
                printError("Couldn't cast selected price values to TABusinessTerm type")
                return
            }
            
            if prices.isEmpty {
                prices = TAPrice.allCases
            }
            
            if terms.isEmpty {
                terms = TABusinessTerm.allCases
            }
            
            let requestBody = TATangentRequestBody(
                startLatitude: userLat,
                startLongitude: userLon,
                endLatitude: Float(placemark.coordinate.latitude),
                endLongitude: Float(placemark.coordinate.longitude),
                preferenceRadius: 24140,
                term: terms,
                price: prices,
                openNow: false,
                responseLimit: 20
            )
            
            TABusinessService.shared.fetchTangents(
                requestBody: requestBody,
                completion: { [weak self] response in
                    guard let self = self else { return }
                    switch response {
                    case .success(_):
                        self.printDebug("TAMapController received fetchTangents Completion")

                    case .failure(let error):
                        self.printError(error)
                        self.errorShowingController.showErrorPopup(title: "Error", message: error.localizedDescription)
                    }
                }
            )
        }
    }
}

//TODO: docstring
extension TAMapViewController: TangentsUpdateListener {
    
    //TODO: docstring
    func tangentsWereUpdated(businesses: [TABusiness]) {
        for business in businesses {
            self.addPin(for: business)
            self.zoomToFitAllAnnotations()
        }
    }
}

//TODO: docstring
extension TAMapViewController {
    
    //TODO: docstring
    func handleTangentSelection(tangent: TABusiness) {
        guard let lastUserLocation = TAUserLocationService.shared.getLastUserLocation(),
              let finalDestinationPin = self.finalDestinationPin else {
            printError("last user location was nil.")
            return
        }
        
        
        let tangentDestination = tangent.getBusinessLocation()
        self.removeTangentOverlays()
        self.plotRoute(from: lastUserLocation, to: tangentDestination, overlayColor: .purple, isTangentOverlay: true)
        self.plotRoute(from: tangentDestination, to: finalDestinationPin.coordinate, overlayColor: .purple, isTangentOverlay: true)
        self.zoomToFitAllAnnotations()
    }
}
