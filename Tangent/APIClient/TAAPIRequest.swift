//
//  TARequest.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import Foundation

/// Protocol that all TARequests must follow to be used in the API Service layer
protocol TAAPIRequest {

    /// The URLRequest to be used in the URLSession task
    var urlRequest: URLRequest? { get }

    /// The HTTP Method that we're using for the request
    var httpMethod: HTTPMethod { get }
}

/// Possible HTTPMethods to be used in our API Service layer.
enum HTTPMethod: String {
    case GET
    case POST
}
