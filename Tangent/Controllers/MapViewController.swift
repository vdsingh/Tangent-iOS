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
    
    var businesses = [TABusiness]()
    
    var mapManager: TAMapManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TAUserLocationManager.shared.startUpdatingLocation()
        self.businesses = Mocking.shared.generateMockBusinesses(count: 10)
//        let routeData: [CLLocation] = [
//            CLLocation(
//                latitude: CLLocationDegrees(floatLiteral: 37.322998),
//                longitude: CLLocationDegrees(floatLiteral: -122.032181)
//            ),
//
//            CLLocation(
//                latitude: CLLocationDegrees(floatLiteral: 42.319519),
//                longitude: CLLocationDegrees(floatLiteral: -72.629761)
//            ),
//        ]
//        self.mapManager?.plotRoute(routeData: routeData)
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
            self.businesses = Mocking.shared.generateMockBusinesses(count: 10)
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

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellSelected = tableView.cellForRow(at: indexPath) as? TATangentTableViewCell else {
            fatalError("$ERR: selected cell was not a TATangentTableViewCell")
        }
        
//        let businessSelected = self.businesses[indexPath.row]
        
        
        if cellSelected == selectedCell {
            // User clicked "GO"
            guard let business = cellSelected.getBusiness() else {
                print("$ERR: Cell's business was nil (make sure cell.configure was called.)")
                return
            }
            
            self.mapManager?.plotRoute(to: business)
        } else {
            // User clicked on the business
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
