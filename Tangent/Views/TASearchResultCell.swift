//
//  TASearchResultCell.swift
//  Tangent
//
//  Created by Vikram Singh on 4/13/23.
//

import Foundation
import UIKit
import MapKit

/// A UITableViewCell that displays a search result for an associated location
class TASearchResultCell: UITableViewCell {
    
    /// Reuse Identifier for the Cell
    static let reuseIdentifier = "TASearchResultCell"
    
    /// Shows the title for the search result
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    /// Shows a subtitle for the search result
    let subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        return subtitle
    }()
    
    /// Shows an icon related to the category of the search result
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    /// StackView to contain the title and subtitle
    let textStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = -20
        return stack
    }()
    
    /// StackView to contain all UI elements
    let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    
    /// Configures the View with a MKMapItem
    /// - Parameter mapItem: The MapItem that describes the associated location
    func configure(with mapItem: MKMapItem) {
        self.setImage(category: mapItem.pointOfInterestCategory)
        self.title.attributedText = NSAttributedString(
            string: mapItem.name ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold)
            ]
        )
        
        self.subtitle.attributedText = NSAttributedString(
            string: mapItem.placemark.title ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        self.addSubviewsAndEstablishConstraints()
        self.backgroundColor = .secondarySystemBackground
    }
    
    
    /// Adds the neccessary subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        self.textStack.addArrangedSubview(self.title)
        self.textStack.addArrangedSubview(self.subtitle)
        
        self.contentView.addSubview(self.textStack)
        self.contentView.addSubview(self.iconImageView)
        
        NSLayoutConstraint.activate([
            self.iconImageView.heightAnchor.constraint(equalToConstant: 30),
            self.iconImageView.widthAnchor.constraint(equalToConstant: 30),
            self.iconImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.iconImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            self.textStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.textStack.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 20),
            self.textStack.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.textStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    /// Sets the Image for the location type ImageView
    /// - Parameter category: The cateogry that the location falls into
    private func setImage(category: MKPointOfInterestCategory?) {
        var image: TASystemImage = .location
        if category == MKPointOfInterestCategory.airport {
            image = .airport
        } else if category == MKPointOfInterestCategory.amusementPark {
            image = .amusementPark
        } else if category == MKPointOfInterestCategory.aquarium {
            image = .aquarium
        } else if category == MKPointOfInterestCategory.atm {
            image = .atm
        } else if category == MKPointOfInterestCategory.bakery {
            image = .bakery
        } else if category == MKPointOfInterestCategory.bank {
            image = .bank
        } else if category == MKPointOfInterestCategory.beach {
            image = .beach
        } else if category == MKPointOfInterestCategory.brewery {
            image = .brewery
        } else if category == MKPointOfInterestCategory.cafe {
            image = .cafe
        } else if category == MKPointOfInterestCategory.campground {
            image = .campground
        } else if category == MKPointOfInterestCategory.carRental {
            image = .carRental
        } else if category == MKPointOfInterestCategory.evCharger {
            image = .evCharger
        } else if category == MKPointOfInterestCategory.fireStation {
            image = .fireStation
        } else if category == MKPointOfInterestCategory.fitnessCenter {
            image = .fitnessCenter
        } else if category == MKPointOfInterestCategory.foodMarket {
            image = .foodMarket
        } else if category == MKPointOfInterestCategory.gasStation {
            image = .gasStation
        } else if category == MKPointOfInterestCategory.hospital {
            image = .hospital
        } else if category == MKPointOfInterestCategory.hotel {
            image = .hotel
        } else if category == MKPointOfInterestCategory.laundry {
            image = .laundry
        } else if category == MKPointOfInterestCategory.library {
            image = .library
        } else if category == MKPointOfInterestCategory.marina {
            image = .marina
        } else if category == MKPointOfInterestCategory.movieTheater {
            image = .movieTheater
        } else if category == MKPointOfInterestCategory.museum {
            image = .museum
        } else if category == MKPointOfInterestCategory.nationalPark {
            image = .nationalPark
        } else if category == MKPointOfInterestCategory.nightlife {
            image = .nightlife
        } else if category == MKPointOfInterestCategory.park {
            image = .park
        } else if category == MKPointOfInterestCategory.parking {
            image = .parking
        } else if category == MKPointOfInterestCategory.pharmacy {
            image = .pharmacy
        } else if category == MKPointOfInterestCategory.police {
            image = .police
        } else if category == MKPointOfInterestCategory.postOffice {
            image = .postOffice
        } else if category == MKPointOfInterestCategory.publicTransport {
            image = .publicTransport
        } else if category == MKPointOfInterestCategory.restaurant {
            image = .restaurant
        } else if category == MKPointOfInterestCategory.restroom {
            image = .restroom
        } else if category == MKPointOfInterestCategory.school {
            image = .school
        } else if category == MKPointOfInterestCategory.stadium {
            image = .stadium
        } else if category == MKPointOfInterestCategory.store {
            image = .store
        } else if category == MKPointOfInterestCategory.theater {
            image = .theater
        } else if category == MKPointOfInterestCategory.university {
            image = .university
        } else if category == MKPointOfInterestCategory.winery {
            image = .winery
        } else if category == MKPointOfInterestCategory.zoo {
            image = .zoo
        }
        
        self.iconImageView.image = image.uiImage
    }
}
