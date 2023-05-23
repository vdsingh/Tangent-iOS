//
//  TAFilterValueWrapper.swift
//  Tangent
//
//  Created by Vikram Singh on 5/22/23.
//

import Foundation


/// Wrapper class for TAFilterValues that allows us to compare them (using Hashable)
class TAFilterValueWrapper: Hashable {

    /// The value associated with the filter
    let value: any TAFilterValue
    
    /// Initializer
    /// - Parameter value: The value associated with the filter
    init(value: any TAFilterValue) {
        self.value = value
    }
    
    static func == (lhs: TAFilterValueWrapper, rhs: TAFilterValueWrapper) -> Bool {
        return lhs.value.stringRepresentation == rhs.value.stringRepresentation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }
}
