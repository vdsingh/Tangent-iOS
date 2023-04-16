//
//  TATangentResponse.swift
//  Tangent
//
//  Created by Vikram Singh on 4/15/23.
//

import Foundation
struct TATangentResponse: TAAPIResponse {
    let businesses: [TABusiness]
    let coordinates: [[Float]]
}
