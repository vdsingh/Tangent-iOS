//
//  TABusinessTerm.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation

//TODO: Docstrings, move
enum TABusinessTerm: String, TAFilterValue, Encodable  {

    case hotels = "Hotel"
    case rest_stops = "Rest Stop"
    case fuel = "Fuel"
    case restaurants = "Restaurants"
    case bars = "Bar"
    case shopping = "Shopping"
    
    var stringRepresentation: String {
        return self.rawValue
    }
    
    var hashValue: Int {
        return self.rawValue.hashValue
    }
    
    static func < (lhs: TABusinessTerm, rhs: TABusinessTerm) -> Bool {
        return lhs.stringRepresentation < rhs.stringRepresentation
    }
}
