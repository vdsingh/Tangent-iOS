//
//  ViewController.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TALocationManager.shared.setDelegate(delegate: self)
        TALocationManager.shared.startUpdatingLocation()
    }
    
    override func loadView() {
        self.view = TAMapView(tableViewDelegate: self, tableViewDataSource: self)
    }
}

extension MapViewController: TALocationManagerDelegate {
    
    func handleLocationAuthorizationFailure(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .restricted, .denied:
            print("$ERR: authorization status failure: \(authorizationStatus)")
        case .notDetermined:
            TALocationManager.shared.requestWhenInUseAuthorization()
        default:
            print("$ERR: authorization failure called with a successful status: \(authorizationStatus)")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("$LOG: Last user location: (\(latitude), \(longitude))")
            self.mapView.centerToLocation(CLLocation(latitude: latitude, longitude: longitude))
            // Handle location update
        } else {
            print("$ERR: User locations is empty.")
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("$ERR: failed to update location with error: \(String(describing: error))")
        // Handle failure to get a user’s location
    }
}

extension MapViewController: UITableViewDelegate {
    
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let businessSelected = self.businesses[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: TATangentTableViewCell.reuseIdentifier, for: indexPath) as? TATangentTableViewCell {
            cell.configure(with: businessSelected)
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue a TATangentTableViewCell")
    }
}
private extension MKMapView {
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
