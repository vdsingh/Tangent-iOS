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
    let coordinate: Coordinate
//    let latitude: Float
//    let longitude: Float
    let price: TAPrice
    let categories: [Category]
    
    func getBusinessLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(self.coordinate.latitude), longitude: Double(self.coordinate.longitude))
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case rating = "Rating"
        case reviewCount = "Review_count"
        case coordinate = "Coordinates"
        case price = "Price"
        case categories = "Categories"
    }
}

struct Coordinate: Decodable {
    let latitude: Float
    let longitude: Float
    
    var clLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: Double(self.latitude),
            longitude: Double(self.longitude)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

struct Category: Decodable {
    let title: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}

//TODO: Docstrings, move
enum TAPrice: String, Codable, CaseIterable {
    case one = "$"
    case two = "$$"
    case three = "$$$"
    case four = "$$$$"
    
    var intValue: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        }
    }
}

//TODO: Docstrings, move
enum TABusinessTerm: String, Encodable {
    case hotels
    case rest_stops
    case fuel
    case restaurants
    case bars
    case shopping
}
