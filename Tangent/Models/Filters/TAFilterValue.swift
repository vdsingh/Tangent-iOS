//
//  TAFilterValue.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation
//TODO: Docstring
protocol TAFilterValue: CaseIterable, Hashable, Comparable {
    var stringRepresentation: String { get }
}
