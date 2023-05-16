//
//  TATangentRequestBody.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

/// Struct containing parameters needed for Tangents Request
struct TATangentRequestParameters: Encodable {
    
    private let startLatitude: Float
    private let startLongitude: Float
    private let endLatitude: Float
    private let endLongitude: Float
    private let preferenceRadius: Float
    private let term: String
    private let price: String
    private let openNow: String
    private let responseLimit: Int
    
    enum CodingKeys: String, CodingKey {
        case startLatitude = "start_lat"
        case startLongitude = "start_lon"
        case endLatitude = "end_lat"
        case endLongitude = "end_lon"
        case preferenceRadius = "pref_radius"
        case term = "term"
        case price = "price"
        case openNow = "open_now"
        case responseLimit = "limit"
    }
    
    init(
        startLatitude: Float,
        startLongitude: Float,
        endLatitude: Float,
        endLongitude: Float,
        preferenceRadius: Float,
        term: [TABusinessTerm],
        price: [TAPrice],
        openNow: Bool,
        responseLimit: Int
    ) {
        self.startLatitude = startLatitude
        self.startLongitude = startLongitude
        self.endLatitude = endLatitude
        self.endLongitude = endLongitude
        self.preferenceRadius = preferenceRadius
        self.term = term.map({ String($0.rawValue) }).joined(separator: ",")
        self.price = price.map({ String($0.intValue) }).joined(separator: ",")
        self.openNow = String(openNow)
        self.responseLimit = responseLimit
    }
}
