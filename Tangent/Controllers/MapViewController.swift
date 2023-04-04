//
//  ViewController.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import UIKit
import MapKit

//TODO: Docstring
class MapViewController: UIViewController, Debuggable {
    let debug = true
    
    //TODO: Docstring
    var selectedCell: UITableViewCell?
    
    let businesses: [TABusiness] = [
        TABusiness(id: "1", name: "Greenough Sub Shop", rating: 3.5, reviewCount: 10, latitude: 20, longitude: 10, price: .one),
        TABusiness(id: "2", name: "Frank", rating: 3.5, reviewCount: 10, latitude: 20, longitude: 10, price: .one),
        TABusiness(id: "3", name: "Worcester", rating: 3.5, reviewCount: 10, latitude: 20, longitude: 10, price: .one),
        TABusiness(id: "4", name: "Berk", rating: 3.5, reviewCount: 10, latitude: 20, longitude: 10, price: .one)

    ]
    
    var mapManager: TAMapManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TAUserLocationManager.shared.setDelegate(delegate: self)
        TAUserLocationManager.shared.startUpdatingLocation()
        let routeData: [CLLocation] = [
            CLLocation(
                latitude: CLLocationDegrees(floatLiteral: 37.322998),
                longitude: CLLocationDegrees(floatLiteral: -122.032181)
            ),
            
            CLLocation(
                latitude: CLLocationDegrees(floatLiteral: 42.319519),
                longitude: CLLocationDegrees(floatLiteral: -72.629761)
            ),
        ]
        self.mapManager?.plotRoute(routeData: routeData)
    }
    
    override func loadView() {
        let tangentView = TAMapView(
            tableViewDelegate: self,
            tableViewDataSource: self
        )
        
        self.view = tangentView
        
        let mapManager = TAMapManager(mapView: tangentView.getMapView())
        tangentView.setZoomToUserCallback {
            mapManager.centerToUserLocation()
        }
        self.mapManager = mapManager
        TAUserLocationManager.shared.setDelegate(delegate: mapManager)
    }
    
    private func getView() -> TAMapView {
        guard let tangentView = self.view as? TAMapView else {
            fatalError("$ERR: Couldn't retrieve View as TAMapView")
        }
        
        return tangentView
    }
    
    func printDebug(_ message: String) {
        print("$LOG: \(message)")
    }
}

//TODO: Docstring
//extension MapViewController: TALocationManagerDelegate {
//    
//    func handleLocationAuthorizationFailure(authorizationStatus: CLAuthorizationStatus) {
//        switch authorizationStatus {
//        case .restricted, .denied:
//            print("$ERR: Authorization status failure: \(authorizationStatus)")
//        case .notDetermined:
//            TAUserLocationManager.shared.requestWhenInUseAuthorization()
//        default:
//            print("$ERR: Authorization failure detected with a successful status: \(authorizationStatus)")
//        }
//    }
//    
//    func locationManager(
//        _ manager: CLLocationManager,
//        didUpdateLocations locations: [CLLocation]
//    ) {
//        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            printDebug("Last user location: (\(latitude), \(longitude))")
////            self.mapView.centerToLocation(CLLocation(latitude: latitude, longitude: longitude))
//            // Handle location update
//        } else {
//            print("$ERR: User locations is empty.")
//        }
//    }
//
//    func locationManager(
//        _ manager: CLLocationManager,
//        didFailWithError error: Error
//    ) {
//        print("$ERR: failed to update location with error: \(String(describing: error))")
//    }
//}

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellSelected = tableView.cellForRow(at: indexPath) as? TATangentTableViewCell else {
            fatalError("$ERR: selected cell was not a TATangentTableViewCell")
        }
        
        if cellSelected == selectedCell {
            // User clicked "GO"
        } else {
            // User clicked
            cellSelected.setSelected()
            if let previouslySelectedCell = self.selectedCell as? TATangentTableViewCell {
                previouslySelectedCell.setDefault()
            }
            self.selectedCell = cellSelected
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = self.businesses[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: TATangentTableViewCell.reuseIdentifier, for: indexPath) as? TATangentTableViewCell {
            cell.configure(with: business)
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue a TATangentTableViewCell")
    }
}
