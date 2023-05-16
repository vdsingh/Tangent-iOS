//
//  TABusiness.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation
import MapKit

/// Model that represents a Business
struct TABusiness: Decodable {
    
    /// The ID of the business
    let id: String
    
    /// The name of the business
    let name: String
    
    /// Yelp rating of the business (out of 5)
    let rating: Float
    
    /// The number of reviews that the business has
    let reviewCount: Int
    
    /// The URL for the image associated with the business
    let imageURL: String?
    
    /// The coordinate of the business
    let coordinate: TACoordinate
    
    /// The price category of the business (ex: "$$")
    let price: TAPrice
    
    /// The categories associated with the business
    let categories: [TACategory]
    
    
    /// Gets the business location as a CLLocationCoordinate2D
    /// - Returns:  the business location as a CLLocationCoordinate2D
    func getBusinessLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(self.coordinate.latitude), longitude: Double(self.coordinate.longitude))
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case rating = "Rating"
        case reviewCount = "Review_Count"
        case coordinate = "Coordinates"
        case price = "Price"
        case categories = "Categories"
        case imageURL = "Image_Url"
    }
}
