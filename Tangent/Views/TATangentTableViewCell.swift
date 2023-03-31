//
//  TATangentTableViewCell.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation
import UIKit

class TATangentTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TATangentTableViewCell"
    
    var business: TABusiness?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with business: TABusiness) {
        self.business = business
        self.nameLabel.text = business.name
        self.nameLabel.textColor = .label
        self.backgroundColor = .systemBackground
        self.addSubviewsAndEstablishConstraints()
    }
    
    func setSelected() {
        self.nameLabel.text = "GO"
        self.nameLabel.textColor = .white
        self.backgroundColor = .green
    }
    
    func setDefault() {
        guard let business = self.business else {
            fatalError("$ERR: TATangentTableViewCell has no business")
        }
        self.configure(with: business)
        self.backgroundColor = .systemBackground
    }
    
    private func addSubviewsAndEstablishConstraints() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        self.contentView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }
}
