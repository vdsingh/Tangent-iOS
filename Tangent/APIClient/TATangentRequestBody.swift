//
//  TATangentRequestBody.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

//TODO: Docstrings
struct TATangentRequestBody: Encodable {
    let startLatitude: Float
    let startLongitude: Float
    let endLatitude: Float
    let endLongitude: Float
    let preferenceRadius: Float
    let term: TABusinessTerm
    let price: [TAPrice]
    let openNow: Bool
    let responseLimit: Int
}
