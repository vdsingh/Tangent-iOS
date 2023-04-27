//
//  TABusinessTerm.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation

//TODO: Docstrings, move
enum TABusinessTerm: String, TAFilterValue, Encodable  {

    case hotels
    case rest_stops
    case fuel
    case restaurants
    case bars
    case shopping
    
    var stringRepresentation: String {
        switch self {
        case .hotels:
            return "Hotels"
        case .rest_stops:
            return "Rest Stops"
        case .fuel:
            return "Fuel"
        case .restaurants:
            return "Restaurants"
        case .bars:
            return "Bars"
        case .shopping:
            return "Shopping"
        }
    }
    
    var hashValue: Int {
        return self.rawValue.hashValue
    }
    
    static func < (lhs: TABusinessTerm, rhs: TABusinessTerm) -> Bool {
        return lhs.stringRepresentation < rhs.stringRepresentation
    }
}
