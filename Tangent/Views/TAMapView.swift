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
    
    //TODO: Docstring
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //TODO: Docstring
    init(tableViewDelegate: UITableViewDelegate, tableViewDataSource: UITableViewDataSource) {
        super.init(frame: .zero)
        self.backgroundColor = .green
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDataSource
        self.addSubviewsAndEstablishConstraints()
        
        self.tableView.register(TATangentTableViewCell.self, forCellReuseIdentifier: TATangentTableViewCell.reuseIdentifier)
    }
    
    //TODO: Docstring
    private func addSubviewsAndEstablishConstraints() {
        self.mainStack.addArrangedSubview(self.mapView)
        self.mainStack.addArrangedSubview(self.tableView)
        self.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            self.mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
