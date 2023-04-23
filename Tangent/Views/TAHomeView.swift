//
//  TAMapView.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation
import UIKit
import MapKit

//TODO: Docstring
class TAHomeView: UIView {
    
    let controller: UIViewController
    
    /// Stack Container for the Map and the TableView
    var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.backgroundColor = .blue
        return stack
    }()
    
    /// The Map
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    // TODO: Docstrings
    lazy var filtersView: TAFiltersView = {
        let filtersView = TAFiltersView(filters: [.price(uiString: "Price"), .businessType(uiString: "Business Type")], controller: self.controller)
        return filtersView
    }()
    
    /// Spinner to indicate if the map is loading
    var mapLoadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .lightGray
        spinner.tintColor = .purple
        spinner.color = .white
        spinner.layer.cornerRadius = 10
        return spinner
    }()
    
    //TODO: Docstring
    var zoomToUserContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// Button that enables users to zoom to their location on the map
    var zoomToUserButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(TASystemImage.location.uiImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    /// TableView that contains the Businesses
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    /// Function that is called to zoom to the user's location
    private var zoomToUserCallback: (() -> Void)?
    
//    let navigationBar: UINavigationBar!
    
    /// Normal Initializer
    /// - Parameters:
    ///   - tableViewDelegate: Delegate for the Businesses TableView
    ///   - tableViewDataSource: DataSource for the Business TableView
    init(
        tableViewDelegate: UITableViewDelegate,
        tableViewDataSource: UITableViewDataSource,
        controller: UIViewController
//        navigationBar: UINavigationBar
    ) {
//        self.navigationBar = navigationBar
//        navigationItem
        self.controller = controller
        super.init(frame: .zero)
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDataSource

        self.tableView.register(TATangentTableViewCell.self, forCellReuseIdentifier: TATangentTableViewCell.reuseIdentifier)
        
        self.zoomToUserButton.addTarget(self, action: #selector(zoomToUser), for: .touchUpInside)
        
        self.addSubviewsAndEstablishConstraints()

    }
    
    // MARK: - Public Functions
    
    /// Sets the callback for the Zoom to User
    /// - Parameter zoomToUserCallback: The function called when the user clicks the "Zoom to User" Button
    func setZoomToUserCallback(zoomToUserCallback: @escaping () -> Void) {
        self.zoomToUserCallback = zoomToUserCallback
    }
    
    /// Gets the Map View
    /// - Returns: The MapView
    func getMapView() -> MKMapView {
        return self.mapView
    }
    
    func showTableView(_ show: Bool) {
        tableView.isHidden = !show
    }
    
    // MARK: - Private Functions
    
    /// Calls the zoomToUserCallback in order to zoom to the user
    @objc private func zoomToUser() {
        guard let zoomToUserCallback = self.zoomToUserCallback else {
            printError("tried to zoom to user but callback was not defined.")
            return
        }
        
        zoomToUserCallback()
    }
    
    /// Adds the Sub Views and establishes all constraints
    private func addSubviewsAndEstablishConstraints() {
        
//        self.navigationBar.addSubview(self.filtersView)
        
        // Add the map
        self.mainStack.addArrangedSubview(self.mapView)
        
        // Add the business TableView
        self.mainStack.addArrangedSubview(self.tableView)
        
        // Add the main stack to the View
        self.addSubview(self.mainStack)
        
        // Add the "Zoom to User" Button container
        self.zoomToUserContainer.addSubview(zoomToUserButton)
        
        // Add the "Zoom to User" Button
        self.addSubview(self.zoomToUserContainer)
        
        // Spinner indicates when a route is loading
        self.addSubview(self.mapLoadingSpinner)
        
        //TODO: Docstrings
//        self.addSubview(self.filtersView)

        NSLayoutConstraint.activate([
            
            // Zoom to User Button Constraints
            self.zoomToUserButton.centerXAnchor.constraint(equalTo: self.zoomToUserContainer.centerXAnchor),
            self.zoomToUserButton.centerYAnchor.constraint(equalTo: self.zoomToUserContainer.centerYAnchor),
            self.zoomToUserButton.heightAnchor.constraint(equalToConstant: 20),
            self.zoomToUserButton.widthAnchor.constraint(equalToConstant: 20),

            
            // Zoom to User Button Container Constraints
            self.zoomToUserContainer.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -30),
            self.zoomToUserContainer.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -30),
            self.zoomToUserContainer.heightAnchor.constraint(equalToConstant: 40),
            self.zoomToUserContainer.widthAnchor.constraint(equalToConstant: 40),

            // Main Stack Constraints
            self.mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            // Spinner Constraints
            self.mapLoadingSpinner.heightAnchor.constraint(equalToConstant: 100),
            self.mapLoadingSpinner.widthAnchor.constraint(equalToConstant: 100),
            self.mapLoadingSpinner.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
            self.mapLoadingSpinner.centerYAnchor.constraint(equalTo: self.mapView.centerYAnchor),
            
            // Filter View Constraints
//            self.filtersView.topAnchor.constraint(equalTo: self.mapView.topAnchor, constant: 10),
//            self.filtersView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
//            self.filtersView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
//            self.filtersView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Public Functions
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
