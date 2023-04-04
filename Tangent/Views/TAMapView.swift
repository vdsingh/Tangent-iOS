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
class TAMapView: UIView {
    
    //TODO: Docstring
    var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    //TODO: Docstring
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var zoomToUserButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "ZOOM TO USER"
        button.backgroundColor = .cyan
        return button
    }()
    
    //TODO: Docstring
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var zoomToUserCallback: (() -> Void)?
    
    //TODO: Docstring
    init(
        tableViewDelegate: UITableViewDelegate,
        tableViewDataSource: UITableViewDataSource
    ) {
        super.init(frame: .zero)
        self.backgroundColor = .green
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDataSource
        self.addSubviewsAndEstablishConstraints()
        
        self.tableView.register(TATangentTableViewCell.self, forCellReuseIdentifier: TATangentTableViewCell.reuseIdentifier)
        
        self.zoomToUserButton.addTarget(self, action: #selector(zoomToUser), for: .touchUpInside)
    }
    
    //TODO: Docstrings + move
    
    func setZoomToUserCallback(zoomToUserCallback: @escaping () -> Void) {
        self.zoomToUserCallback = zoomToUserCallback
    }
    
    
    @objc private func zoomToUser() {
        guard let zoomToUserCallback = self.zoomToUserCallback else {
            print("$ERR: tried to zoom to user but callback was not defined.")
            return
        }
        zoomToUserCallback()
    }
    
    // MARK: - Private Functions
    
    //TODO: Docstring
    private func addSubviewsAndEstablishConstraints() {
        self.mainStack.addArrangedSubview(self.mapView)
        self.mainStack.addArrangedSubview(self.tableView)
        self.addSubview(mainStack)
        
        self.addSubview(self.zoomToUserButton)
        
        NSLayoutConstraint.activate([
            self.zoomToUserButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -5),
            self.zoomToUserButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -5),
            self.zoomToUserButton.heightAnchor.constraint(equalToConstant: 60),
            self.zoomToUserButton.widthAnchor.constraint(equalToConstant: 60),

            
            self.mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    // MARK: - Public Functions
    
    //TODO: Docstrings
    func getMapView() -> MKMapView {
        return self.mapView
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
