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
    var selectedPin: MKPlacemark? = nil

    let debug = true
    
    //TODO: Docstring
    var selectedCell: UITableViewCell?
    
    var businesses = [TABusiness]()
    
    var mapManager: TAMapManager?
        
//    var searchBar: UISearchBar? = nil
    
    var tangentView: TAMapView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MAP VIEW CONTROLLER VIEWDIDLOAD")
        TAUserLocationManager.shared.startUpdatingLocation(completion: {
            
            
        })
        
        self.businesses = Mocking.shared.generateMockBusinesses(count: 10)
    }
    
    override func loadView() {
        print("LOADVIEW")
        self.title = "Map"
        
        let tangentView = TAMapView(
            tableViewDelegate: self,
            tableViewDataSource: self
        )

        self.tangentView = tangentView
        self.definesPresentationContext = true
        
//        NSLayoutConstraint.activate([
//            tangentView.topAnchor.constraint(equalTo: tangentView.topAnchor),
//            tangentView.bottomAnchor.constraint(equalTo: tangentView.bottomAnchor),
//            tangentView.leftAnchor.constraint(equalTo: tangentView.leftAnchor),
//            tangentView.rightAnchor.constraint(equalTo: tangentView.rightAnchor),
//        ])
        
//        view.addSubview(tangentView)
//        self.view = view
        
        let searchResultsController = TASearchResultsTableViewController(mapView: tangentView.mapView)
        let resultSearchController = UISearchController(searchResultsController: searchResultsController)
        resultSearchController.searchResultsUpdater = searchResultsController
        let searchBar = resultSearchController.searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        resultSearchController.obscuresBackgroundDuringPresentation = true
        searchResultsController.handleMapSearchDelegate = self
        
        let mapManager = TAMapManager(mapView: tangentView.getMapView(), mapSpinner: tangentView.mapLoadingSpinner)
        tangentView.setZoomToUserCallback {
            mapManager.centerToUserLocation()
            self.businesses = Mocking.shared.generateMockBusinesses(count: 10)
        }
        
        self.mapManager = mapManager
        TAUserLocationManager.shared.setDelegate(delegate: mapManager)
        
        self.view = tangentView
    }

    
    func printDebug(_ message: String) {
        print("$LOG: \(message)")
    }
    
    func getTangentView() -> TAMapView {
        guard let tangentView = self.tangentView else {
            fatalError("$ERR: Tangent View was nil")
        }
        
        return tangentView
    }
}

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellSelected = tableView.cellForRow(at: indexPath) as? TATangentTableViewCell else {
            fatalError("$ERR: selected cell was not a TATangentTableViewCell")
        }
        
        if cellSelected == selectedCell {
            // User clicked "GO"
            guard let business = cellSelected.getBusiness() else {
                print("$ERR: Cell's business was nil (make sure cell.configure was called.)")
                return
            }
            
            self.mapManager?.plotRoute(to: business.getBusinessLocation())
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

extension MapViewController: TAMapSearchHandler {
    func dropPinZoomIn(placemark: MKPlacemark) {
        
        guard let mapManager = self.mapManager else {
            print("$ERR: map manager was nil when a location was selected.")
            return
        }
        
        let mapView = self.getTangentView().mapView
        
        // cache the pin
        self.selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

protocol TAMapSearchHandler {
    func dropPinZoomIn(placemark:MKPlacemark)
}
