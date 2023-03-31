//
//  TAEndpoint.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

/// The endpoints that can be used in this applications
enum TAEndpoint: String {

    /// endpoint to get tangents
    case tangents = "tangents"
    
    //TODO: docstring
    var httpMethod: HTTPMethod {
        switch self {
        case .tangents:
            return .GET
        }
    }
}
