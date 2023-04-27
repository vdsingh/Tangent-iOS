//
//  TAFilterOption.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation

//TODO: Docstring
enum TAFilterOption: String, CaseIterable {
    case price = "Price"
    case businessType = "Type"
    
    //TODO: Docstrings
    var allPossibleValues: [any TAFilterValue] {
        switch self {
        case .price:
            return TAPrice.allCases.sorted { price1, price2 in
                return price1.rawValue.count > price2.rawValue.count
            }
        case .businessType:
            return TABusinessTerm.allCases
        }
    }
}
