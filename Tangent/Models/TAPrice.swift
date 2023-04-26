//
//  TAPrice.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation

//TODO: Docstrings, move
enum TAPrice: String, TAFilterValue, CaseIterable, Codable, Hashable, Comparable {
    
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
    
    var stringRepresentation: String {
        return self.rawValue
    }

    static func createFromInt(intValue: Int) -> TAPrice {
        if intValue == 1 {
            return .one
        } else if intValue == 2 {
            return .two
        } else if intValue == 3 {
            return .three
        } else if intValue == 4 {
            return .four
        } else {
            fatalError("$ERR (TAPrice): tried to construct TAPrice from int, but the int value was not valid: \(intValue)")
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
    
    static func < (lhs: TAPrice, rhs: TAPrice) -> Bool {
        return lhs.rawValue.count < rhs.rawValue.count
    }
    

}
