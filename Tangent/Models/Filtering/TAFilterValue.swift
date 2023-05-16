//
//  TAFilterValue.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation

/// Protocol that all Filter values must adhere to
protocol TAFilterValue: CaseIterable, Hashable, Comparable {
    
    /// FilterValues must be able to be represented as a String
    var stringRepresentation: String { get }
}
