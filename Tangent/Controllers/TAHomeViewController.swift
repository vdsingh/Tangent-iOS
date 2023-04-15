//
//  ViewController.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import UIKit
import MapKit

/// Controller for the "Home" View
class TAHomeViewController: UIViewController, Debuggable {
    let debug = true
    
    /// The cell that is currently selected in the TableView (nil if none have been selected yet)
    var selectedCell: UITableViewCell?
    
    // TODO: Remove and use Business Service
    var businesses = [TABusiness]()
    
    /// Controller for the MapView
    lazy var mapController: TAMapViewController = {
        return TAMapViewController(
            mapView: homeView.getMapView(),
            mapSpinner: homeView.mapLoadingSpinner
        )
    }()
    
    /// The View for this screen
    lazy var homeView: TAHomeView = {
        let homeView = TAHomeView(
            tableViewDelegate: self,
            tableViewDataSource: self
        )
        
        homeView.setZoomToUserCallback { [weak self] in
            guard let self = self else { return }
            self.mapController.centerToUserLocation()
            self.businesses = Mocking.shared.generateMockBusinesses(count: 10)
        }
        
        return homeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TAUserLocationService.shared.startUpdatingLocation()
        self.businesses = Mocking.shared.generateMockBusinesses(count: 10)
    }
    
    override func loadView() {
        self.title = "Home"
        self.definesPresentationContext = true
        
        let searchResultsController = TASearchResultsTableViewController(mapView: homeView.mapView)
        let resultSearchController = UISearchController(searchResultsController: searchResultsController)
        resultSearchController.searchResultsUpdater = searchResultsController
        let searchBar = resultSearchController.searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        resultSearchController.obscuresBackgroundDuringPresentation = true
        searchResultsController.handleMapSearchDelegate = self.mapController
        self.view = self.homeView
    }

    
    func printDebug(_ message: String) {
        print("$LOG (MapViewController): \(message)")
    }
}

/// Handle everything associated with the TableView Delegate here
extension TAHomeViewController: UITableViewDelegate {
    
    /// This function handles a cell being clicked in the Table View
    /// - Parameters:
    ///   - tableView: The TableView in which the cell was clicked
    ///   - indexPath: The Index of the cell that was clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Cast the cell selected to type TATangentTableViewCell (Should always work)
        guard let cellSelected = tableView.cellForRow(at: indexPath) as? TATangentTableViewCell else {
            fatalError("$ERR: selected cell was not a TATangentTableViewCell")
        }
        
        // If the user has already selected this cell
        if cellSelected == selectedCell {
            
            // User clicked "GO"
            guard let business = cellSelected.getBusiness() else {
                printError("Cell's business was nil (make sure cell.configure was called.)")
                return
            }
            
            self.mapController.plotRoute(to: business.getBusinessLocation())
        } else {
            
            // User clicked on the business
            cellSelected.setSelected()
            if let previouslySelectedCell = self.selectedCell as? TATangentTableViewCell {
                previouslySelectedCell.setDefault()
            }
            self.selectedCell = cellSelected
        }
        
        // Deselect the row after we selected it
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /// Sets the height for the cells in a TableView
    /// - Parameters:
    ///   - tableView: The TableView for which we are setting the cell height
    ///   - indexPath: The index for the cell for which we are setting the height
    /// - Returns: The height that the cell was set to
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

/// Handle everything associated with the TableView Data Source here
extension TAHomeViewController: UITableViewDataSource {
    
    /// The number of rows in each section of the TableView
    /// - Parameters:
    ///   - tableView: The TableView containing the cells
    ///   - section: The section number
    /// - Returns: The number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    /// Dequeues a cell to the TableView
    /// - Parameters:
    ///   - tableView: The TableView to which we are dequeuing cells
    ///   - indexPath: The index of the cell we are dequeuing
    /// - Returns: The cell that we are dequeuing
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = self.businesses[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: TATangentTableViewCell.reuseIdentifier, for: indexPath) as? TATangentTableViewCell {
            cell.configure(with: business)
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue a TATangentTableViewCell")
    }
}
