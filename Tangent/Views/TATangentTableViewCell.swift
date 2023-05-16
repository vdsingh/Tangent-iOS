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
    
    /// ImageView to display the business image
    let tangentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = TASystemImage.questionMark.uiImage
        return imageView
    }()
    
    /// Label for the name of the business
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    /// Display the business rating
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Display the Yelp review count
    let reviewCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Display the price
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Stack to contain the UI elements
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Public Functions
    
    /// Sets the UI properties for this cell based on the TABusiness Data Model
    func configure(with business: TABusiness) {
        self.business = business
        self.nameLabel.text = business.name
        self.nameLabel.textColor = .label
        self.priceLabel.text = business.price.rawValue
        self.ratingLabel.text = "\(business.rating) stars"
        self.reviewCount.text = "\(business.reviewCount) reviews on Yelp"
        self.backgroundColor = .systemBackground
        
        // Fetch the Image, and attach it to the ImageView
        if let imageURL = business.imageURL {
            TAImageService.shared.loadImage(from: imageURL) { [weak self] uiImage in
                DispatchQueue.main.async {
                    guard let uiImage = uiImage else {
                        self?.printError("Couldn't unwrap UIImage.")
                        return
                    }
                    
                    self?.tangentImageView.image = uiImage
                }
            }
        }
        
        self.addSubviewsAndEstablishConstraints()
    }
    
    /// Gets the business associated with this Cell
    /// - Returns: The business associated with this Cell
    func getBusiness() -> TABusiness? {
        return self.business
    }
    
    /// Puts the cell in the "selected" state
    func setSelected() {
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
        
        // Add subviews
        self.addSubview(self.tangentImageView)
        self.stack.addArrangedSubview(self.nameLabel)
        self.stack.addArrangedSubview(self.ratingLabel)
        self.stack.addArrangedSubview(self.reviewCount)
        
        self.contentView.addSubview(self.stack)
        
        // Sets the constraints for the View
        NSLayoutConstraint.activate([
            self.tangentImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10),
            self.tangentImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -10),
            self.tangentImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            self.tangentImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            
            self.stack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.stack.leftAnchor.constraint(equalTo: self.tangentImageView.rightAnchor, constant: 10),
            self.stack.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }
}
