//
//  TABusiness.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation
import MapKit

//TODO: Docstrings
struct TABusiness: Decodable {
    let id: String
    let name: String
    let rating: Float
    let reviewCount: Int
    let imageURL: String?
    let coordinate: TACoordinate
    let price: TAPrice
    let categories: [TACategory]
    
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
