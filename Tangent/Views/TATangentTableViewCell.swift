//
//  TATangentTableViewCell.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation
import UIKit

/// Cell that displays and allows interaction with TABusinesses
class TATangentTableViewCell: UITableViewCell {

    /// This is used to uniquely identify the TATangentTableViewCell type
    static let reuseIdentifier = "TATangentTableViewCell"
    
    /// The business that this TableView Cell will show information for
    private var business: TABusiness?
    
    /// Label for the name of the business
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public Functions
    
    /// Sets the UI properties for this cell based on the TABusiness Data Model
    func configure(with business: TABusiness) {
        self.business = business
        self.nameLabel.text = business.name
        self.nameLabel.textColor = .label
        self.backgroundColor = .systemBackground
        self.addSubviewsAndEstablishConstraints()
    }
    
    /// Gets the business associated with this Cell
    /// - Returns: The business associated with this Cell
    func getBusiness() -> TABusiness? {
        return self.business
    }
    
    /// Puts the cell in the "selected" state
    func setSelected() {
        self.nameLabel.text = "GO"
        self.nameLabel.textColor = .white
        self.backgroundColor = .green
    }
    
    
    /// Puts the cell in the "default" state
    func setDefault() {
        guard let business = self.business else {
            fatalError("$ERR: TATangentTableViewCell has no business")
        }
        self.configure(with: business)
        self.backgroundColor = .systemBackground
    }
    
    // MARK: - Private Functions
    
    /// Adds the necessary Sub Views and establishes all constraints
    private func addSubviewsAndEstablishConstraints() {
        
        // Remove all of the existing Views from the content
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        // Add the Business name label to the content view
        self.contentView.addSubview(self.nameLabel)
        
        // Sets the constraints for the View
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }
}
