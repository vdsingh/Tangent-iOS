//
//  TASearchResultCell.swift
//  Tangent
//
//  Created by Vikram Singh on 4/13/23.
//

import Foundation
import UIKit
import MapKit

//TODO: Docstrings
class TASearchResultCell: UITableViewCell {
    
    static let reuseIdentifier = "TASearchResultCell"
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "HELLO"
        return title
    }()
    
    func configure(with placemark: MKPlacemark) {
        print("CONFIGURING CELL")
        self.title.text = placemark.title
        self.addSubviewsAndEstablishConstraints()
        self.backgroundColor = .red
    }
    
    private func addSubviewsAndEstablishConstraints() {
        self.contentView.addSubview(self.title)
        
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.title.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}
