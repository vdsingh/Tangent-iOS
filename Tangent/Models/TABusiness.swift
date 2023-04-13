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
    let latitude: Float
    let longitude: Float
    let price: TAPrice
    
    func getBusinessLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(self.latitude), longitude: Double(self.longitude))
    }
}

//TODO: Docstrings
enum TAPrice: Int, Codable, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
}

//TODO: Docstrings
enum TABusinessTerm: String, Encodable {
    case hotels
    case rest_stops
    case fuel
    case restaurants
    case bars
    case shopping
}
