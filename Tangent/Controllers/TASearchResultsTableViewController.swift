//
//  TASearchResultsController.swift
//  Tangent
//
//  Created by Vikram Singh on 4/13/23.
//

import Foundation
import UIKit
import MapKit

//TODO: Docstrings

class TASearchResultsTableViewController: UIViewController {
    
    var matchingItems:[MKMapItem] = [] {
        didSet {
            print("MATCHING ITEMS: \(matchingItems)")
            self.tableView.reloadData()
        }
    }
    var mapView: MKMapView
    
    var handleMapSearchDelegate: TAMapSearchHandler?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .blue
        return tableView
    }()
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
        self.tableView.register(TASearchResultCell.self, forCellReuseIdentifier: TASearchResultCell.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view = self.tableView
        self.tableView.reloadData()
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension TASearchResultsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension TASearchResultsTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TASearchResultCell.reuseIdentifier) as? TASearchResultCell {
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.configure(with: selectedItem)
            return cell
        }

        fatalError("$ERR: couldn't cast cell as TASearchResultCell")
    }
}

extension TASearchResultsTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
