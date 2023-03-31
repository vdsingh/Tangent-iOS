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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with business: TABusiness) {
        self.nameLabel.text = business.name
        self.addSubviewsAndEstablishConstraints()
    }
    
    private func addSubviewsAndEstablishConstraints() {
        self.contentView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }
}
